import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/features/client/project_chat_meetings/index.dart';

void main() {
  group('Project Chat & Meetings Domain Models Tests', () {
    test('ChatMessage model holds all metadata and WhatsApp bridge flags', () {
      const msg = ChatMessage(
        id: 'test_msg_1',
        senderName: 'Vikram Malhotra',
        senderRole: 'Senior Project Manager',
        avatarColor: Color(0xFF6366F1),
        message: 'Carpentry lower carcase completed.',
        timestamp: '10:15 AM',
        isClient: false,
        hasAttachment: true,
        attachmentName: 'Laser_Alignment.jpg',
        attachmentType: AttachmentType.image,
        isWhatsAppSynced: true,
      );

      expect(msg.senderName, 'Vikram Malhotra');
      expect(msg.isClient, false);
      expect(msg.hasAttachment, true);
      expect(msg.attachmentType, AttachmentType.image);
      expect(msg.isWhatsAppSynced, true);
    });

    test('ChatConversation model maintains member profile, last message and thread', () {
      final conv = ChatConversation(
        id: 'conv_test',
        title: 'Pooja Hegde',
        role: 'Lead Interior Designer',
        avatarColor: const Color(0xFFEC4899),
        initials: 'PH',
        isOnline: true,
        statusLabel: 'Online',
        lastMessage: '3D Renders ready.',
        lastTime: '10:00 AM',
        unreadCount: 1,
        isGroup: false,
        phoneNumber: '+91 98332 11984',
        email: 'pooja.h@homio.in',
        quickChips: ['Request 3D render revision'],
        messages: [],
      );

      expect(conv.title, 'Pooja Hegde');
      expect(conv.isOnline, true);
      expect(conv.quickChips.first, 'Request 3D render revision');
      expect(conv.messages.isEmpty, true);
    });

    test('ProjectMeeting and MeetingActionItem models maintain task states and MoMs', () {
      final actionItem = MeetingActionItem(
        id: 'act_101',
        task: 'Finalize paint shade card',
        owner: 'Client & Pooja',
        isCompleted: false,
        dueDate: 'Sep 06, 2026',
      );

      final meeting = ProjectMeeting(
        id: 'meet_101',
        title: 'Virtual 3D Walkthrough',
        type: 'Virtual Review (Google Meet)',
        date: 'Sep 06, 2026',
        timeSlot: '04:00 PM - 04:45 PM',
        meetingLink: 'https://meet.google.com/homio-worli-402',
        attendees: ['Vikram (PM)', 'Pooja (Designer)'],
        status: MeetingStatus.scheduled,
        agenda: 'Review Stage 5 joinery QC',
        minutesOfMeeting: 'Scheduled session with WhatsApp reminders.',
        actionItems: [actionItem],
      );

      expect(meeting.title, 'Virtual 3D Walkthrough');
      expect(meeting.status, MeetingStatus.scheduled);
      expect(meeting.actionItems.length, 1);
      expect(actionItem.isCompleted, false);

      actionItem.isCompleted = true;
      expect(actionItem.isCompleted, true);
    });
  });

  group('Project Chat & Meetings Widget & Interactive UI Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: ClientProjectChatMeetingsPage(),
      );
    }

    testWidgets('ClientProjectChatMeetingsPage renders desktop layout with member sidebar and no stats',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Check Executive Header
      expect(find.text('Project Chat & Meetings'), findsOneWidget);
      expect(find.text('Skyline Villa Penthouse 402, Worli • 4 BHK Luxury'), findsOneWidget);
      expect(find.text('5 Specialists Online • WhatsApp Bridge Active'), findsOneWidget);
      expect(find.text('Video Call PM'), findsOneWidget);
      expect(find.text('Schedule Review Meeting'), findsOneWidget);

      // Verify that stats strip is REMOVED
      expect(find.text('Average Response Time'), findsNothing);
      expect(find.text('Total Meetings Held'), findsNothing);

      // Check Segmented Tabs
      expect(find.textContaining('Project Chat Channels'), findsOneWidget);
      expect(find.textContaining('Meeting Scheduler & MoMs'), findsOneWidget);

      // Check Sidebar Conversations
      expect(find.text('Conversations'), findsOneWidget);
      expect(find.text('Unified Project Team'), findsWidgets);
      expect(find.text('Vikram Malhotra'), findsWidgets);
      expect(find.text('Pooja Hegde'), findsWidgets);
      expect(find.text('Rajesh Verma'), findsWidgets);
      expect(find.text('Dr. Neha Kulkarni'), findsWidgets);

      // Check WhatsApp Security Banner
      expect(find.text('Unified WhatsApp Business Cloud Sync'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('ClientProjectChatMeetingsPage renders cleanly on mobile viewport (390x844)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Project Chat & Meetings'), findsOneWidget);
      expect(find.text('Conversations'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Selecting a member opens their dedicated chat pane and quick chips',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap on Pooja Hegde in the sidebar
      final poojaTile = find.text('Pooja Hegde');
      expect(poojaTile, findsWidgets);
      await tester.tap(poojaTile.first);
      await tester.pumpAndSettle();

      // Verify Pooja's quick chips appear
      expect(find.text('Request 3D render revision'), findsOneWidget);
      expect(find.text('Ask for laminate swatch sample'), findsOneWidget);

      // Tap quick chip
      await tester.tap(find.text('Request 3D render revision'));
      await tester.pumpAndSettle();

      final inputField = find.byType(TextField);
      expect(inputField, findsWidgets);
      expect(find.text('Request 3D render revision'), findsWidgets);
    });

    testWidgets('Client can send a message in selected conversation and it syncs with bridge',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Vikram Malhotra in sidebar
      final vikramTile = find.text('Vikram Malhotra');
      await tester.tap(vikramTile.first);
      await tester.pumpAndSettle();

      final composerFinder = find.widgetWithText(TextField, 'Type message to Vikram Malhotra...');
      expect(composerFinder, findsOneWidget);

      await tester.enterText(composerFinder, 'Hi Vikram, please share the revised stage timeline.');
      await tester.pumpAndSettle();

      // Tap send button
      final sendButton = find.byIcon(Icons.send_rounded);
      expect(sendButton, findsOneWidget);
      await tester.tap(sendButton);
      await tester.pumpAndSettle();

      expect(find.text('Hi Vikram, please share the revised stage timeline.'), findsWidgets);
      expect(find.textContaining('Message sent to Vikram Malhotra'), findsOneWidget);
    });

    testWidgets('Search input filters the member directory',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final searchField = find.widgetWithText(TextField, 'Search specialists or team...');
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Acoustics');
      await tester.pumpAndSettle();

      expect(find.text('Dr. Neha Kulkarni'), findsWidgets);
      expect(find.text('Ar. Sameer Mehta'), findsNothing);
      expect(find.text('Rajesh Verma'), findsNothing);
    });

    testWidgets('Mobile responsive navigation: list to chat and back',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // On mobile initial view: member list is visible
      expect(find.text('Conversations'), findsOneWidget);

      // Tap a conversation
      final teamConv = find.text('Unified Project Team');
      expect(teamConv, findsOneWidget);
      await tester.tap(teamConv);
      await tester.pumpAndSettle();

      // Now mobile is viewing chat, back button should be visible
      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);

      // Tap back button
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Returns to conversations list
      expect(find.text('Conversations'), findsOneWidget);
    });

    testWidgets('Switching to Meeting Scheduler tab displays upcoming sessions & MoMs',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap tab
      final meetingTab = find.textContaining('Meeting Scheduler & MoMs');
      expect(meetingTab, findsOneWidget);
      await tester.tap(meetingTab);
      await tester.pumpAndSettle();

      expect(find.text('UPCOMING SCHEDULED MEETING'), findsOneWidget);
      expect(find.text('Virtual 3D Walkthrough & Stage 6 Priming Review'), findsOneWidget);
      expect(find.text('Archived Meetings & MoM Decision Records'), findsOneWidget);
      expect(find.text('Stage 4 Marble Dry Lay & Electrical Box Inspection'), findsOneWidget);
    });

    testWidgets('Instant Video Call PM opens modal and toggles controls',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final videoCallBtn = find.text('Video Call PM');
      expect(videoCallBtn, findsOneWidget);
      await tester.tap(videoCallBtn);
      await tester.pumpAndSettle();

      expect(find.text('Vikram Malhotra (Senior PM)'), findsOneWidget);
      expect(find.text('Connecting securely via Homio Encrypted Video...'), findsOneWidget);

      // Tap End Call icon
      final endCallBtn = find.byIcon(Icons.call_end_rounded);
      expect(endCallBtn, findsOneWidget);
      await tester.tap(endCallBtn);
      await tester.pumpAndSettle();

      expect(find.text('Vikram Malhotra (Senior PM)'), findsNothing);
    });

    testWidgets('Schedule Review Meeting opens dialog and allows confirmation',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final scheduleBtn = find.text('Schedule Review Meeting');
      expect(scheduleBtn, findsOneWidget);
      await tester.tap(scheduleBtn);
      await tester.pumpAndSettle();

      expect(find.text('Schedule Project Review Meeting'), findsOneWidget);
      expect(find.text('Confirm & Schedule'), findsOneWidget);

      await tester.tap(find.text('Confirm & Schedule'));
      await tester.pumpAndSettle();

      expect(find.text('Schedule Project Review Meeting'), findsNothing);
      expect(find.textContaining('Meeting scheduled: Project Review Session'), findsOneWidget);
    });
  });
}
