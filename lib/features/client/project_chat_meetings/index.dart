import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ============================================================================
// DOMAIN MODELS & ENUMS
// ============================================================================

enum AttachmentType { image, document, video }

class ChatMessage {
  final String id;
  final String senderName;
  final String senderRole;
  final Color avatarColor;
  final String message;
  final String timestamp;
  final bool isClient;
  final bool hasAttachment;
  final String? attachmentName;
  final AttachmentType? attachmentType;
  final bool isWhatsAppSynced;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.avatarColor,
    required this.message,
    required this.timestamp,
    required this.isClient,
    this.hasAttachment = false,
    this.attachmentName,
    this.attachmentType,
    this.isWhatsAppSynced = true,
  });
}

class ChatConversation {
  final String id;
  final String title;
  final String role;
  final Color avatarColor;
  final String initials;
  final bool isOnline;
  final String statusLabel;
  String lastMessage;
  String lastTime;
  int unreadCount;
  final bool isGroup;
  final String phoneNumber;
  final String email;
  final List<String> quickChips;
  final List<ChatMessage> messages;

  ChatConversation({
    required this.id,
    required this.title,
    required this.role,
    required this.avatarColor,
    required this.initials,
    this.isOnline = true,
    required this.statusLabel,
    required this.lastMessage,
    required this.lastTime,
    this.unreadCount = 0,
    this.isGroup = false,
    required this.phoneNumber,
    required this.email,
    required this.quickChips,
    required this.messages,
  });
}

enum MeetingStatus { scheduled, completed, rescheduled }

class MeetingActionItem {
  final String id;
  final String task;
  final String owner;
  bool isCompleted;
  final String dueDate;

  MeetingActionItem({
    required this.id,
    required this.task,
    required this.owner,
    required this.isCompleted,
    required this.dueDate,
  });
}

class ProjectMeeting {
  final String id;
  final String title;
  final String type; // Virtual Review, Physical Site Walkthrough, Design Alignment
  final String date;
  final String timeSlot;
  final String meetingLink;
  final List<String> attendees;
  MeetingStatus status;
  final String agenda;
  final String minutesOfMeeting;
  final List<MeetingActionItem> actionItems;

  ProjectMeeting({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.timeSlot,
    required this.meetingLink,
    required this.attendees,
    required this.status,
    required this.agenda,
    required this.minutesOfMeeting,
    required this.actionItems,
  });
}

// ============================================================================
// MAIN PAGE WIDGET: PROJECT CHAT & MEETINGS
// ============================================================================

class ClientProjectChatMeetingsPage extends StatefulWidget {
  const ClientProjectChatMeetingsPage({super.key});

  @override
  State<ClientProjectChatMeetingsPage> createState() => _ClientProjectChatMeetingsPageState();
}

class _ClientProjectChatMeetingsPageState extends State<ClientProjectChatMeetingsPage> {
  String _selectedTab = 'Project Chat Channels';
  String _selectedConversationId = 'conv_team';
  bool _mobileViewingChat = false;
  String _memberSearchQuery = '';

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // 1. Initial Conversations List with Direct Channels & Group Channel
  late final List<ChatConversation> _conversations = [
    ChatConversation(
      id: 'conv_team',
      title: 'Unified Project Team',
      role: 'All Assigned Stakeholders (4 Specialists)',
      avatarColor: const Color(0xFF6366F1),
      initials: 'ALL',
      isOnline: true,
      statusLabel: 'WhatsApp Bridge Active • 4 Members',
      lastMessage: 'Häfele soft-close hinges arrived at 9:30 AM today.',
      lastTime: '11:18 AM',
      unreadCount: 2,
      isGroup: true,
      phoneNumber: '+91 98201 44521',
      email: 'worli.penthouse402@homio.in',
      quickChips: [
        'Request On-Site Photo Update',
        'Confirm Sample Delivery',
        'Schedule Tomorrow\'s Site Visit',
      ],
      messages: [
        const ChatMessage(
          id: 'team_msg_1',
          senderName: 'Vikram Malhotra',
          senderRole: 'Senior Project Manager',
          avatarColor: Color(0xFF6366F1),
          message: 'Good morning Mr. & Mrs. Sharma! Today our carpentry team has completed the lower carcase assembly for the Modular Kitchen. Blum tandem box alignment cleared QC.',
          timestamp: '10:15 AM',
          isClient: false,
          hasAttachment: true,
          attachmentName: 'Kitchen_Carcase_Laser_Alignment.jpg',
          attachmentType: AttachmentType.image,
          isWhatsAppSynced: true,
        ),
        const ChatMessage(
          id: 'team_msg_2',
          senderName: 'Pooja Hegde',
          senderRole: 'Sr. Interior Designer',
          avatarColor: Color(0xFFEC4899),
          message: 'I have also uploaded Rev 3.0 of the kitchen 3D render to your Designs Vault with the requested smoked oak fluted breakfast bar overhang.',
          timestamp: '10:42 AM',
          isClient: false,
          hasAttachment: true,
          attachmentName: 'Bespoke_Kitchen_Rev3_Render.pdf',
          attachmentType: AttachmentType.document,
          isWhatsAppSynced: true,
        ),
        const ChatMessage(
          id: 'team_msg_3',
          senderName: 'You (Client)',
          senderRole: 'Homeowner',
          avatarColor: Color(0xFF10B981),
          message: 'Thank you Vikram & Pooja! The smoked oak finish looks stunning. Are the Häfele soft-close hinges already delivered on-site?',
          timestamp: '11:05 AM',
          isClient: true,
          isWhatsAppSynced: true,
        ),
        const ChatMessage(
          id: 'team_msg_4',
          senderName: 'Rajesh Verma',
          senderRole: 'Site Execution Supervisor',
          avatarColor: Color(0xFFF59E0B),
          message: 'Yes sir! 18 pairs of Häfele concealed soft-close hinges arrived at 9:30 AM today from our authorized depot. Installation will begin right after lunch.',
          timestamp: '11:18 AM',
          isClient: false,
          isWhatsAppSynced: true,
        ),
      ],
    ),
    ChatConversation(
      id: 'conv_vikram',
      title: 'Vikram Malhotra',
      role: 'Senior Project Manager • PMP®',
      avatarColor: const Color(0xFF6366F1),
      initials: 'VM',
      isOnline: true,
      statusLabel: 'Online • Quick Response (< 5 min)',
      lastMessage: 'Stage 5 joinery milestone is tracking 2 days ahead of schedule.',
      lastTime: '09:45 AM',
      unreadCount: 1,
      isGroup: false,
      phoneNumber: '+91 98201 44521',
      email: 'vikram.m@homio.in',
      quickChips: [
        'Ask about Stage 5 milestone timeline',
        'Request invoice clarification',
        'Schedule weekly progress review',
      ],
      messages: [
        const ChatMessage(
          id: 'vm_1',
          senderName: 'Vikram Malhotra',
          senderRole: 'Senior Project Manager',
          avatarColor: Color(0xFF6366F1),
          message: 'Hello Mr. Sharma! Here is the weekly milestone summary: Stage 4 Italian Marble is 100% certified, and Stage 5 Modular Kitchen joinery is tracking 2 days ahead of schedule.',
          timestamp: '09:30 AM',
          isClient: false,
          isWhatsAppSynced: true,
        ),
        const ChatMessage(
          id: 'vm_2',
          senderName: 'You (Client)',
          senderRole: 'Homeowner',
          avatarColor: Color(0xFF10B981),
          message: 'Excellent update Vikram! Can we schedule our virtual walkthrough for tomorrow afternoon at 4 PM?',
          timestamp: '09:40 AM',
          isClient: true,
          isWhatsAppSynced: true,
        ),
        const ChatMessage(
          id: 'vm_3',
          senderName: 'Vikram Malhotra',
          senderRole: 'Senior Project Manager',
          avatarColor: Color(0xFF6366F1),
          message: 'Confirmed! I have locked 04:00 PM tomorrow with Designer Pooja. Calendar invite and WhatsApp reminder have been dispatched.',
          timestamp: '09:45 AM',
          isClient: false,
          isWhatsAppSynced: true,
        ),
      ],
    ),
    ChatConversation(
      id: 'conv_pooja',
      title: 'Pooja Hegde',
      role: 'Lead Interior Designer • B.Arch',
      avatarColor: const Color(0xFFEC4899),
      initials: 'PH',
      isOnline: true,
      statusLabel: 'Online • Design Studio',
      lastMessage: 'I have updated the 3D renders with the warm 3000K lighting.',
      lastTime: 'Yesterday',
      unreadCount: 0,
      isGroup: false,
      phoneNumber: '+91 98332 11984',
      email: 'pooja.h@homio.in',
      quickChips: [
        'Request 3D render revision',
        'Ask for laminate swatch sample',
        'Discuss master bedroom lighting',
      ],
      messages: [
        const ChatMessage(
          id: 'ph_1',
          senderName: 'Pooja Hegde',
          senderRole: 'Lead Interior Designer',
          avatarColor: Color(0xFFEC4899),
          message: 'Hi Mr. & Mrs. Sharma! I updated the 3D renders with the warm 3000K cove lighting in the grand living lounge. You can check the day/night lighting simulation in your Designs Vault.',
          timestamp: 'Yesterday, 04:20 PM',
          isClient: false,
          hasAttachment: true,
          attachmentName: 'LivingLounge_3000K_Cove_Night.jpg',
          attachmentType: AttachmentType.image,
          isWhatsAppSynced: true,
        ),
        const ChatMessage(
          id: 'ph_2',
          senderName: 'You (Client)',
          senderRole: 'Homeowner',
          avatarColor: Color(0xFF10B981),
          message: 'The evening mood looks spectacular Pooja! We loved how the Statuario reflections blend with the brass inlays.',
          timestamp: 'Yesterday, 05:10 PM',
          isClient: true,
          isWhatsAppSynced: true,
        ),
      ],
    ),
    ChatConversation(
      id: 'conv_rajesh',
      title: 'Rajesh Verma',
      role: 'Site Execution Supervisor',
      avatarColor: const Color(0xFFF59E0B),
      initials: 'RV',
      isOnline: true,
      statusLabel: 'On-Site • Penthouse 402',
      lastMessage: 'Anti-scratch film applied over living room marble flooring.',
      lastTime: 'Aug 30',
      unreadCount: 0,
      isGroup: false,
      phoneNumber: '+91 98190 77319',
      email: 'rajesh.v@homio.in',
      quickChips: [
        'Request on-site photo update',
        'Check carpenter attendance',
        'Report on-site query or snag',
      ],
      messages: [
        const ChatMessage(
          id: 'rv_1',
          senderName: 'Rajesh Verma',
          senderRole: 'Site Execution Supervisor',
          avatarColor: Color(0xFFF59E0B),
          message: 'Sir, today 6 master carpenters and 2 polishers are on site. Anti-scratch film has been carefully applied over the entire living room Italian marble flooring.',
          timestamp: 'Aug 30, 02:15 PM',
          isClient: false,
          hasAttachment: true,
          attachmentName: 'Floor_Polyurethane_Scratch_Guard.jpg',
          attachmentType: AttachmentType.image,
          isWhatsAppSynced: true,
        ),
        const ChatMessage(
          id: 'rv_2',
          senderName: 'You (Client)',
          senderRole: 'Homeowner',
          avatarColor: Color(0xFF10B981),
          message: 'Great care taken Rajesh, thank you! Keep the protection active until painting finishes.',
          timestamp: 'Aug 30, 02:40 PM',
          isClient: true,
          isWhatsAppSynced: true,
        ),
      ],
    ),
    ChatConversation(
      id: 'conv_neha',
      title: 'Dr. Neha Kulkarni',
      role: 'Acoustics & MEP Consultant',
      avatarColor: const Color(0xFF10B981),
      initials: 'NK',
      isOnline: false,
      statusLabel: 'Available • Reports Cleared',
      lastMessage: 'All Daikin VRV refrigerant pressure tests cleared at 450 PSI.',
      lastTime: 'Aug 24',
      unreadCount: 0,
      isGroup: false,
      phoneNumber: '+91 98211 66341',
      email: 'neha.k@homio.in',
      quickChips: [
        'Ask about acoustic test report',
        'Check HVAC drainage isolation',
      ],
      messages: [
        const ChatMessage(
          id: 'nk_1',
          senderName: 'Dr. Neha Kulkarni',
          senderRole: 'Acoustics & MEP Consultant',
          avatarColor: Color(0xFF10B981),
          message: 'Hello Mr. Sharma, all Daikin VRV refrigerant pressure tests cleared at 450 PSI for 48 continuous hours without any pressure drop. MEP Stage 2 compliance certificate is verified.',
          timestamp: 'Aug 24, 11:30 AM',
          isClient: false,
          isWhatsAppSynced: true,
        ),
      ],
    ),
    ChatConversation(
      id: 'conv_sameer',
      title: 'Ar. Sameer Mehta',
      role: 'Principal Architect & Project Director',
      avatarColor: const Color(0xFF0EA5E9),
      initials: 'SM',
      isOnline: true,
      statusLabel: 'Director Desk • Escalations',
      lastMessage: 'Quality audit for Stage 4 dry lay completed and signed off.',
      lastTime: 'Aug 20',
      unreadCount: 0,
      isGroup: false,
      phoneNumber: '+91 98200 11200',
      email: 'sameer.m@homio.in',
      quickChips: [
        'Request director inspection',
        'Escalate milestone matter',
      ],
      messages: [
        const ChatMessage(
          id: 'sm_1',
          senderName: 'Ar. Sameer Mehta',
          senderRole: 'Principal Architect & Project Director',
          avatarColor: Color(0xFF0EA5E9),
          message: 'Dear Mr. & Mrs. Sharma, I personally inspected the Italian Statuario 8-slab bookmatch dry lay last Friday. The slab vein continuity is impeccable.',
          timestamp: 'Aug 20, 06:00 PM',
          isClient: false,
          isWhatsAppSynced: true,
        ),
      ],
    ),
  ];

  // 2. Meetings & MoMs List (conforming to docs/requirmenet.md: MEETING SCHEDULING SECTION)
  late final List<ProjectMeeting> _meetings = [
    ProjectMeeting(
      id: 'meet_upcoming_1',
      title: 'Virtual 3D Walkthrough & Stage 6 Priming Review',
      type: 'Virtual Review (Google Meet)',
      date: 'Tomorrow (Sep 06, 2026)',
      timeSlot: '04:00 PM - 04:45 PM',
      meetingLink: 'https://meet.google.com/homio-worli-402',
      attendees: ['Vikram Malhotra (PM)', 'Pooja Hegde (Designer)', 'Homeowner (Client)'],
      status: MeetingStatus.scheduled,
      agenda: 'Review Stage 5 completed joinery QC stamps, align on Italian Statuario diamond polish finish, and authorize Stage 6 paint priming commencement.',
      minutesOfMeeting: 'Scheduled session. WhatsApp reminders active at 24 hours & 1 hour prior.',
      actionItems: [
        MeetingActionItem(
          id: 'act_1',
          task: 'Finalize Asian Paints Royale Aspira emulsion shade card (L102 vs L104)',
          owner: 'Client & Designer Pooja',
          isCompleted: false,
          dueDate: 'Sep 06, 2026',
        ),
        MeetingActionItem(
          id: 'act_2',
          task: 'Provide quartz counter edge polish sample photos to Client',
          owner: 'Supervisor Rajesh Verma',
          isCompleted: true,
          dueDate: 'Sep 04, 2026',
        ),
      ],
    ),
    ProjectMeeting(
      id: 'meet_past_1',
      title: 'Stage 4 Marble Dry Lay & Electrical Box Inspection',
      type: 'Physical On-Site Walkthrough',
      date: 'Aug 26, 2026',
      timeSlot: '11:30 AM - 01:00 PM',
      meetingLink: 'Penthouse 402, Skyline Villa, Worli',
      attendees: ['Ar. Sameer Mehta (Director)', 'Rajesh Verma (Supervisor)', 'Homeowner (Client)'],
      status: MeetingStatus.completed,
      agenda: 'Inspect Italian Statuario 8-slab bookmatch layout in the grand living lounge and verify AC refrigerant conduit isolation.',
      minutesOfMeeting: 'Client verified and approved slab vein continuity. Verified no hollow spots under acoustic underlayment. Approved Stage 4 milestone sign-off.',
      actionItems: [
        MeetingActionItem(
          id: 'act_3',
          task: 'Apply polyurethane scratch protection membrane over polished Statuario flooring',
          owner: 'Supervisor Rajesh Verma',
          isCompleted: true,
          dueDate: 'Aug 28, 2026',
        ),
        MeetingActionItem(
          id: 'act_4',
          task: 'Issue Stage 4 Completion Handover Certificate in Audit Vault',
          owner: 'Project Manager Vikram',
          isCompleted: true,
          dueDate: 'Aug 29, 2026',
        ),
      ],
    ),
  ];

  ChatConversation get _activeConversation {
    return _conversations.firstWhere(
      (c) => c.id == _selectedConversationId,
      orElse: () => _conversations.first,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final conv = _activeConversation;

    setState(() {
      final newMsg = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderName: 'You (Client)',
        senderRole: 'Homeowner',
        avatarColor: const Color(0xFF10B981),
        message: text,
        timestamp: 'Just now',
        isClient: true,
        isWhatsAppSynced: true,
      );

      conv.messages.add(newMsg);
      conv.lastMessage = text;
      conv.lastTime = 'Just now';
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message sent to ${conv.title} & synced with WhatsApp Bridge!'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < Breakpoints.compact;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 28.0,
          vertical: 20.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Executive Header (Concise without stats pushing chat down)
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 16),

                // 2. Segmented Navigation Tabs
                _buildSegmentedTabs(context, isDark, isMobile),

                const SizedBox(height: 16),

                // 3. Active View (Chat with Member Sidebar OR Meeting Scheduler)
                if (_selectedTab == 'Project Chat Channels')
                  _buildMasterDetailChatInterface(context, isDark, isMobile)
                else
                  _buildMeetingsView(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 4. WhatsApp Cloud Sync Assurance Banner
                _buildWhatsAppBridgeBanner(context, isDark, isMobile),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. EXECUTIVE HEADER
  // ==========================================================================
  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Context Pill & WhatsApp Status
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 260 : 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.apartment_rounded, size: 12, color: Color(0xFF6366F1)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Skyline Villa Penthouse 402, Worli • 4 BHK Luxury',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: isMobile ? 260 : 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mark_chat_read_rounded, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '5 Specialists Online • WhatsApp Bridge Active',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title & CTAs
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? (screenWidth - 72) : 580),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Chat & Meetings',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Direct messaging with every specialist on your project and the unified team thread with automatic WhatsApp synchronization.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showInstantCallModal(context, isDark),
                    icon: const Icon(Icons.video_call_rounded, size: 16, color: Color(0xFF6366F1)),
                    label: Text(
                      'Video Call PM',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showScheduleMeetingDialog(context, isDark),
                    icon: const Icon(Icons.calendar_month_rounded, size: 15, color: Colors.white),
                    label: Text(
                      'Schedule Review Meeting',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 2. SEGMENTED NAVIGATION TABS
  // ==========================================================================
  Widget _buildSegmentedTabs(BuildContext context, bool isDark, bool isMobile) {
    final tabs = [
      ('Project Chat Channels', Icons.forum_rounded, '${_conversations.length} Channels'),
      ('Meeting Scheduler & MoMs', Icons.event_note_rounded, '${_meetings.length} Meetings'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tabs.map((t) {
          final isSelected = _selectedTab == t.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = t.$1;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6366F1) : (isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      t.$2,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '${t.$1} (${t.$3})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // 3. MASTER-DETAIL CHAT INTERFACE WITH MEMBER SIDEBAR
  // ==========================================================================
  Widget _buildMasterDetailChatInterface(BuildContext context, bool isDark, bool isMobile) {
    final filteredConversations = _conversations.where((conv) {
      if (_memberSearchQuery.isEmpty) return true;
      final query = _memberSearchQuery.toLowerCase();
      return conv.title.toLowerCase().contains(query) ||
          conv.role.toLowerCase().contains(query);
    }).toList();

    return Container(
      height: isMobile ? 640 : 700,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lg,
        child: isMobile
            ? (_mobileViewingChat
                ? _buildActiveChatPane(context, isDark, isMobile, showBackButton: true)
                : _buildMembersSidebar(context, filteredConversations, isDark, isMobile))
            : Row(
                children: [
                  // Left Pane: Members & Channels Sidebar (310px)
                  SizedBox(
                    width: 310,
                    child: _buildMembersSidebar(context, filteredConversations, isDark, isMobile),
                  ),

                  // Vertical Divider
                  Container(
                    width: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),

                  // Right Pane: Active Chat Window
                  Expanded(
                    child: _buildActiveChatPane(context, isDark, isMobile, showBackButton: false),
                  ),
                ],
              ),
      ),
    );
  }

  // ==========================================================================
  // 3A. MEMBERS & CHANNELS SIDEBAR
  // ==========================================================================
  Widget _buildMembersSidebar(
    BuildContext context,
    List<ChatConversation> conversations,
    bool isDark,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sidebar Top Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Conversations',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_conversations.length} Available',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Search Box
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _memberSearchQuery = val.trim();
                  });
                },
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: 'Search specialists or team...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, size: 16),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Conversations List
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: conversations.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorder.withValues(alpha: 0.5),
            ),
            itemBuilder: (context, index) {
              final conv = conversations[index];
              final isSelected = conv.id == _selectedConversationId;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedConversationId = conv.id;
                    conv.unreadCount = 0;
                    if (isMobile) {
                      _mobileViewingChat = true;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? const Color(0xFF6366F1).withValues(alpha: 0.2) : const Color(0xFF6366F1).withValues(alpha: 0.08))
                        : Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
                        width: 3.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Avatar with online status badge
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 19,
                            backgroundColor: conv.avatarColor,
                            child: conv.isGroup
                                ? const Icon(Icons.groups_rounded, color: Colors.white, size: 18)
                                : Text(
                                    conv.initials,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          if (conv.isOnline)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark ? AppColors.darkSurface : Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      // Name, Role & Last Message
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    conv.title,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  conv.lastTime,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              conv.role,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? const Color(0xFF6366F1) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    conv.lastMessage,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (conv.unreadCount > 0)
                                  Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6366F1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${conv.unreadCount}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // 3B. ACTIVE CHAT PANE
  // ==========================================================================
  Widget _buildActiveChatPane(
    BuildContext context,
    bool isDark,
    bool isMobile, {
    required bool showBackButton,
  }) {
    final conv = _activeConversation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Chat Header Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          child: Row(
            children: [
              if (showBackButton) ...[
                IconButton(
                  onPressed: () {
                    setState(() {
                      _mobileViewingChat = false;
                    });
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: 'Back to conversations list',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
              ],

              // Avatar
              CircleAvatar(
                radius: 17,
                backgroundColor: conv.avatarColor,
                child: conv.isGroup
                    ? const Icon(Icons.groups_rounded, color: Colors.white, size: 16)
                    : Text(
                        conv.initials,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(width: 10),

              // Title & Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            conv.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded, size: 13, color: Color(0xFF10B981)),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      conv.statusLabel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Action Buttons in Chat Header
              Wrap(
                spacing: 6,
                children: [
                  IconButton(
                    onPressed: () => _showInstantCallModal(context, isDark),
                    icon: const Icon(Icons.videocam_rounded, size: 18),
                    color: const Color(0xFF6366F1),
                    tooltip: 'Instant Video Call ${conv.title}',
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Direct call routing to ${conv.title} (${conv.phoneNumber})...'),
                          backgroundColor: const Color(0xFF10B981),
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone_outlined, size: 18),
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    tooltip: 'Call ${conv.title}',
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 2. Message History Stream
        Expanded(
          child: Container(
            color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: ListView.builder(
              controller: _chatScrollController,
              itemCount: conv.messages.length,
              itemBuilder: (context, index) {
                final msg = conv.messages[index];
                return _buildMessageBubble(context, msg, isDark, isMobile);
              },
            ),
          ),
        ),

        const Divider(height: 1),

        // 3. Quick Action Canned Chips (Personalized for current active contact)
        if (conv.quickChips.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            color: isDark ? AppColors.darkSurface : Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: conv.quickChips.map((chipText) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _messageController.text = chipText;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_rounded, size: 12, color: Color(0xFF6366F1)),
                            const SizedBox(width: 4),
                            Text(
                              chipText,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        const Divider(height: 1),

        // 4. Message Composer
        Container(
          padding: const EdgeInsets.all(10.0),
          color: isDark ? AppColors.darkSurface : Colors.white,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Media attachment simulator: JPG, PNG, PDF supported.'),
                      backgroundColor: Color(0xFF6366F1),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.attach_file_rounded, size: 20, color: Color(0xFF6366F1)),
                tooltip: 'Attach Image or Document',
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  onSubmitted: (_) => _sendMessage(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type message to ${conv.title}...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.all(10),
                ),
                tooltip: 'Send Message',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // MESSAGE BUBBLE WIDGET
  // ==========================================================================
  Widget _buildMessageBubble(BuildContext context, ChatMessage msg, bool isDark, bool isMobile) {
    final isMe = msg.isClient;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: msg.avatarColor,
              child: Text(
                msg.senderName.isNotEmpty ? msg.senderName[0] : 'U',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isMobile ? 250 : 440),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color(0xFF6366F1)
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                  ),
                  border: Border.all(
                    color: isMe
                        ? const Color(0xFF6366F1)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe) ...[
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 2,
                        children: [
                          Text(
                            msg.senderName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: msg.avatarColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              msg.senderRole,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: msg.avatarColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],

                    // Message Text
                    Text(
                      msg.message,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: isMe ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                        height: 1.35,
                      ),
                    ),

                    // Attachment Card
                    if (msg.hasAttachment && msg.attachmentName != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.black.withValues(alpha: 0.15)
                              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              msg.attachmentType == AttachmentType.image
                                  ? Icons.image_rounded
                                  : Icons.picture_as_pdf_rounded,
                              size: 16,
                              color: isMe ? Colors.white : const Color(0xFF6366F1),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                msg.attachmentName!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isMe ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 4),

                    // Time & Sync status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          msg.timestamp,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            color: isMe ? Colors.white.withValues(alpha: 0.7) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        if (msg.isWhatsAppSynced) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all_rounded,
                            size: 13,
                            color: isMe ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF10B981),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 4. MEETINGS SCHEDULER & MOMS VIEW
  // ==========================================================================
  Widget _buildMeetingsView(BuildContext context, bool isDark, bool isMobile) {
    final upcomingMeeting = _meetings.firstWhere((m) => m.status == MeetingStatus.scheduled);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Upcoming Meeting Spotlight Card
        _buildUpcomingMeetingCard(
          context,
          upcomingMeeting,
          isDark,
          isMobile,
        ),
        const SizedBox(height: 20),

        // Past Meetings & MoMs Log
        _buildSectionHeader(
          'Archived Meetings & MoM Decision Records',
          'Official minutes of past design reviews, site walkthroughs, and verified action items',
          isDark,
        ),
        const SizedBox(height: 12),

        ..._meetings
            .where((m) => m.status == MeetingStatus.completed)
            .map((meeting) => Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: _buildPastMeetingCard(context, meeting, isDark, isMobile),
                )),
      ],
    );
  }

  Widget _buildUpcomingMeetingCard(
    BuildContext context,
    ProjectMeeting meeting,
    bool isDark,
    bool isMobile,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge Row
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'UPCOMING SCHEDULED MEETING',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF6366F1),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? (screenWidth - 100) : 300),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.alarm_on_rounded, size: 14, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '24h & 1h WhatsApp Alerts Active',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            meeting.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${meeting.date} • ${meeting.timeSlot} • ${meeting.type}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6366F1),
            ),
          ),

          const SizedBox(height: 12),

          // Agenda Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.subject_rounded, size: 14, color: Color(0xFF6366F1)),
                    const SizedBox(width: 6),
                    Text(
                      'Discussion Agenda',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  meeting.agenda,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Action items checklist
          if (meeting.actionItems.isNotEmpty) ...[
            Text(
              'Preparation Checklist & Action Items',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            ...meeting.actionItems.map((act) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          act.isCompleted = !act.isCompleted;
                        });
                      },
                      child: Icon(
                        act.isCompleted ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        size: 18,
                        color: act.isCompleted ? const Color(0xFF10B981) : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        act.task,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          decoration: act.isCompleted ? TextDecoration.lineThrough : null,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        act.owner,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          const SizedBox(height: 14),

          // Attendees & Join Actions
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                'Attendees: ${meeting.attendees.join(', ')}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Meeting added to Google Calendar & Apple iCal!'),
                          backgroundColor: Color(0xFF6366F1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today_rounded, size: 14),
                    label: Text(
                      'Add to Calendar',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showInstantCallModal(context, isDark),
                    icon: const Icon(Icons.videocam_rounded, size: 15, color: Colors.white),
                    label: Text(
                      'Join Google Meet',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPastMeetingCard(
    BuildContext context,
    ProjectMeeting meeting,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'COMPLETED SESSION',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              Text(
                meeting.date,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meeting.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${meeting.timeSlot} • ${meeting.type}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 10),

          // MoM Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.assignment_turned_in_rounded, size: 14, color: Color(0xFF10B981)),
                    const SizedBox(width: 5),
                    Text(
                      'Official Minutes of Meeting (MoM)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  meeting.minutesOfMeeting,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // 5. SECURITY & WHATSAPP BRIDGE BANNER
  // ==========================================================================
  Widget _buildWhatsAppBridgeBanner(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mark_chat_read_rounded, size: 20, color: Color(0xFF10B981)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unified WhatsApp Business Cloud Sync',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'All project discussions, meeting reminders, and milestone documents sent here are mirrored in your private WhatsApp project group. Messages from your phone automatically synchronize with the Homio CRM timeline.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // MODALS & DIALOGS
  // ==========================================================================

  void _showScheduleMeetingDialog(BuildContext context, bool isDark) {
    final titleController = TextEditingController();
    final agendaController = TextEditingController();
    String selectedSlot = '04:00 PM - 04:45 PM';
    String selectedType = 'Virtual Review (Google Meet)';
    bool sendWhatsAppReminder = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.event_available_rounded, color: Color(0xFF6366F1), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Schedule Project Review Meeting',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Coordinate virtual or on-site alignment with PM & Lead Designer',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Text(
                          'Meeting Title / Topic',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Stage 6 Paint Priming & Lighting Alignment',
                            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Meeting Format',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            'Virtual Review (Google Meet)',
                            'Physical Site Walkthrough',
                            'Design Studio Visit',
                          ].map((type) {
                            final isSel = selectedType == type;
                            return ChoiceChip(
                              label: Text(type),
                              selected: isSel,
                              onSelected: (val) {
                                setDialogState(() => selectedType = type);
                              },
                              selectedColor: const Color(0xFF6366F1),
                              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Available Time Slot (Tomorrow)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            '11:00 AM - 11:45 AM',
                            '02:30 PM - 03:15 PM',
                            '04:00 PM - 04:45 PM',
                            '06:00 PM - 06:45 PM',
                          ].map((slot) {
                            final isSel = selectedSlot == slot;
                            return ChoiceChip(
                              label: Text(slot),
                              selected: isSel,
                              onSelected: (val) {
                                setDialogState(() => selectedSlot = slot);
                              },
                              selectedColor: const Color(0xFF10B981),
                              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Meeting Agenda & Topics',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: agendaController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Items you would like the team to prepare for...',
                            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // WhatsApp reminder checkbox
                        InkWell(
                          onTap: () {
                            setDialogState(() {
                              sendWhatsAppReminder = !sendWhatsAppReminder;
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: sendWhatsAppReminder,
                                onChanged: (val) {
                                  setDialogState(() {
                                    sendWhatsAppReminder = val ?? true;
                                  });
                                },
                                activeColor: const Color(0xFF10B981),
                              ),
                              Expanded(
                                child: Text(
                                  'Send automated 24h & 1h WhatsApp calendar reminders',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final title = titleController.text.trim().isEmpty
                                    ? 'Project Review Session'
                                    : titleController.text.trim();
                                Navigator.of(ctx).pop();
                                setState(() {
                                  _meetings.insert(
                                    0,
                                    ProjectMeeting(
                                      id: 'meet_${DateTime.now().millisecondsSinceEpoch}',
                                      title: title,
                                      type: selectedType,
                                      date: 'Sep 06, 2026',
                                      timeSlot: selectedSlot,
                                      meetingLink: 'https://meet.google.com/homio-worli-402',
                                      attendees: ['Vikram Malhotra (PM)', 'Pooja Hegde (Designer)', 'You (Client)'],
                                      status: MeetingStatus.scheduled,
                                      agenda: agendaController.text.trim().isEmpty
                                          ? 'Project progress review and milestone discussion.'
                                          : agendaController.text.trim(),
                                      minutesOfMeeting: 'Meeting scheduled. WhatsApp reminder active.',
                                      actionItems: [],
                                    ),
                                  );
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Meeting scheduled: $title for $selectedSlot!'),
                                    backgroundColor: const Color(0xFF10B981),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                'Confirm & Schedule',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showInstantCallModal(BuildContext context, bool isDark) {
    bool isMuted = false;
    bool isVideoOff = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Video Viewport Simulator
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: const Color(0xFF1E293B),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircleAvatar(
                                        radius: 36,
                                        backgroundColor: Color(0xFF6366F1),
                                        child: Text(
                                          'VM',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Vikram Malhotra (Senior PM)',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Connecting securely via Homio Encrypted Video...',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.fiber_manual_record, size: 10, color: Color(0xFF10B981)),
                                        SizedBox(width: 5),
                                        Text(
                                          '00:14 • HD 1080p',
                                          style: TextStyle(fontSize: 10, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Call Controls Bar
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 10,
                        children: [
                          IconButton.filled(
                            onPressed: () {
                              setDialogState(() => isMuted = !isMuted);
                            },
                            icon: Icon(isMuted ? Icons.mic_off_rounded : Icons.mic_rounded),
                            style: IconButton.styleFrom(
                              backgroundColor: isMuted ? const Color(0xFFEF4444) : const Color(0xFF334155),
                              foregroundColor: Colors.white,
                            ),
                            tooltip: isMuted ? 'Unmute' : 'Mute',
                          ),
                          IconButton.filled(
                            onPressed: () {
                              setDialogState(() => isVideoOff = !isVideoOff);
                            },
                            icon: Icon(isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded),
                            style: IconButton.styleFrom(
                              backgroundColor: isVideoOff ? const Color(0xFFEF4444) : const Color(0xFF334155),
                              foregroundColor: Colors.white,
                            ),
                            tooltip: isVideoOff ? 'Start Video' : 'Stop Video',
                          ),
                          IconButton.filled(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Screen sharing requested with PM Vikram Malhotra.'),
                                  backgroundColor: Color(0xFF6366F1),
                                ),
                              );
                            },
                            icon: const Icon(Icons.screen_share_rounded),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF334155),
                              foregroundColor: Colors.white,
                            ),
                            tooltip: 'Share 3D Window',
                          ),
                          IconButton.filled(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(Icons.call_end_rounded),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFEF4444),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            tooltip: 'End Call',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
