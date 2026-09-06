import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/assigned_team/index.dart';

void main() {
  group('Assigned Team Domain Models & Data Integrity Tests', () {
    test('TeamMember model contains complete profile attributes', () {
      const member = TeamMember(
        id: 'test_1',
        name: 'Vikram Malhotra',
        role: 'Senior Project Manager',
        department: DepartmentCategory.leadership,
        departmentLabel: 'Project Leadership',
        initials: 'VM',
        avatarColor: Color(0xFF6366F1),
        status: TeamMemberDutyStatus.available,
        experienceYears: 10,
        completedProjects: 52,
        rating: 4.97,
        reviewCount: 48,
        phoneNumber: '+91 98201 44521',
        whatsappNumber: '+91 98201 44521',
        email: 'vikram.m@homio.in',
        qualification: 'B.Arch • PMP® Certified',
        coreResponsibilities: [
          'Single point of contact for project governance & milestone tracking',
        ],
        activeFocus: 'Coordinating Stage 5 Modular Kitchen joinery',
        onSiteSchedule: 'On-Site Tue & Fri',
      );

      expect(member.name, 'Vikram Malhotra');
      expect(member.status.label, 'Available');
      expect(member.status.color, const Color(0xFF10B981));
      expect(member.department, DepartmentCategory.leadership);
    });

    test('WeeklyEvaluationScores computes average score correctly', () {
      final scores = WeeklyEvaluationScores(
        qualityScore: 9.6,
        timelineScore: 9.3,
        behaviourScore: 9.9,
        clientNote: 'Great communication',
        updatedAt: DateTime(2026, 9, 5),
      );

      expect(scores.averageScore, closeTo(9.6, 0.01));
    });

    test('EscalationTier model holds hierarchy, SLAs, and scope details', () {
      const tier = EscalationTier(
        level: 1,
        title: 'Level 1: Immediate On-Site Action',
        role: 'Site Execution Supervisor',
        name: 'Rajesh Verma',
        sla: '< 2 Hours',
        scope: 'On-site execution, labour issues, daily work snags',
        phoneNumber: '+91 98190 77319',
        badgeColor: Color(0xFF10B981),
      );

      expect(tier.level, 1);
      expect(tier.sla, contains('< 2 Hours'));
    });
  });

  group('Assigned Team Widget & Layout Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: ClientAssignedTeamPage(),
      );
    }

    testWidgets('ClientAssignedTeamPage renders all sections on desktop viewport',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Check Clean Header
      expect(find.text('Assigned Team'), findsOneWidget);
      expect(find.text('Skyline Villa Penthouse 402, Worli • 4 BHK Luxury'), findsOneWidget);
      expect(find.text('6 Specialists'), findsOneWidget);

      // Check Clean Weekly Evaluation Card
      expect(find.text('Weekly Team Evaluation'), findsOneWidget);
      expect(find.text('Design Quality'), findsOneWidget);
      expect(find.text('On-Time Execution'), findsOneWidget);
      expect(find.text('Professional Behaviour'), findsOneWidget);

      // Check Clean Filter Tabs
      expect(find.text('All Stakeholders'), findsOneWidget);
      expect(find.text('Project Leadership'), findsOneWidget);
      expect(find.text('Design & 3D'), findsOneWidget);
      expect(find.text('Site Execution'), findsOneWidget);
      expect(find.text('Quality & Handover'), findsOneWidget);

      // Check Assigned Team Members
      expect(find.text('Vikram Malhotra'), findsOneWidget);
      expect(find.text('Pooja Hegde'), findsOneWidget);
      expect(find.text('Rajesh Verma'), findsOneWidget);
      expect(find.text('Dr. Neha Kulkarni'), findsOneWidget);

      // Check Clean Escalation Section
      expect(find.text('Direct SLA Escalation Desk'), findsOneWidget);
      expect(find.text('Level 1: Immediate On-Site Action'), findsOneWidget);
      expect(find.text('Level 4: Client Ombudsman Hotline'), findsOneWidget);
    });

    testWidgets('ClientAssignedTeamPage renders smoothly on mobile viewport (390x844)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Assigned Team'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('ClientAssignedTeamPage filters team members by department category',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap on "Design & 3D"
      final designFilter = find.text('Design & 3D');
      expect(designFilter, findsOneWidget);
      await tester.tap(designFilter);
      await tester.pumpAndSettle();

      // Designer should be present
      expect(find.text('Pooja Hegde'), findsOneWidget);
      expect(find.text('Rohan Deshpande'), findsOneWidget);

      // Supervisor should now be hidden
      expect(find.text('Rajesh Verma'), findsNothing);

      // Switch back to "All Stakeholders"
      await tester.tap(find.text('All Stakeholders'));
      await tester.pumpAndSettle();
      expect(find.text('Rajesh Verma'), findsOneWidget);
    });

    testWidgets('ClientAssignedTeamPage triggers WhatsApp and Call action SnackBars',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap first WhatsApp button
      final whatsappButtons = find.widgetWithText(OutlinedButton, 'WhatsApp');
      expect(whatsappButtons, findsWidgets);
      await tester.ensureVisible(whatsappButtons.first);
      await tester.pumpAndSettle();
      await tester.tap(whatsappButtons.first);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Opening WhatsApp Chat with Vikram Malhotra'), findsOneWidget);
    });

    testWidgets('ClientAssignedTeamPage opens and submits Weekly Rating dialog',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap "Rate Your Team"
      final rateButton = find.widgetWithText(OutlinedButton, 'Rate Your Team');
      expect(rateButton, findsOneWidget);
      await tester.tap(rateButton);
      await tester.pumpAndSettle();

      // Verify modal dialog opened
      expect(find.text('1. Design & Workmanship Quality'), findsOneWidget);

      // Tap "Submit Official Weekly Rating"
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit Official Weekly Rating');
      expect(submitButton, findsOneWidget);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Modal closed and SnackBar shown
      expect(find.text('1. Design & Workmanship Quality'), findsNothing);
      expect(find.textContaining('Weekly evaluation successfully logged'), findsOneWidget);
    });

    testWidgets('ClientAssignedTeamPage triggers Call action for team member',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap first Call button
      final callButtons = find.widgetWithText(OutlinedButton, 'Call');
      expect(callButtons, findsWidgets);
      await tester.ensureVisible(callButtons.first);
      await tester.pumpAndSettle();
      await tester.tap(callButtons.first);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Calling Vikram Malhotra'), findsOneWidget);
    });
  });
}
