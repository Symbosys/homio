import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// Screen 1: PROJECT CHAT & MEETINGS
/// Connected client-side communication hub:
/// - WhatsApp-synced project chat thread with Lead Architect, PM & Supervisor
/// - File & CAD attachments, milestone context tags, quick chips
/// - Meeting scheduler (Virtual & Physical site walk) with MOM & Action items
/// - 100% Dark & Light mode compatible
class ClientProjectChatMeetingsPage extends StatefulWidget {
  const ClientProjectChatMeetingsPage({super.key});

  @override
  State<ClientProjectChatMeetingsPage> createState() =>
      _ClientProjectChatMeetingsPageState();
}

class _ClientProjectChatMeetingsPageState
    extends State<ClientProjectChatMeetingsPage> {
  int _activeTab = 0; // 0 = Project Chat, 1 = Review Meetings
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  String _selectedMeetingFilter = 'all'; // all, upcoming, completed

  @override
  void initState() {
    super.initState();
    ClientDataRepository.stateVersionNotifier.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    ClientDataRepository.stateVersionNotifier.removeListener(_onDataChanged);
    _messageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  void _sendMessage({String? text, String? attachmentName, ChatAttachmentType? attachmentType}) {
    final content = text ?? _messageController.text.trim();
    if (content.isEmpty && attachmentName == null) return;

    ClientDataRepository.sendChatMessage(
      content.isNotEmpty ? content : 'Shared an attachment: $attachmentName',
      attachment: attachmentName != null
          ? ChatAttachment(
              name: attachmentName,
              size: '2.4 MB',
              type: attachmentType ?? ChatAttachmentType.document,
              icon: attachmentType == ChatAttachmentType.photo
                  ? Icons.image_outlined
                  : (attachmentType == ChatAttachmentType.cad
                      ? Icons.architecture_rounded
                      : Icons.picture_as_pdf_rounded),
            )
          : null,
      contextTag: 'Stage 5: Modular Kitchen',
    );

    _messageController.clear();

    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate realistic PM response after 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      ClientDataRepository.chatMessages.add(
        CustomerChatMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderName: 'Amit Verma',
          senderRole: 'Site Execution Supervisor',
          senderAvatar: 'AV',
          avatarColor: const Color(0xFF10B981),
          message: 'Noted! I have coordinated this with the joinery carpentry team on site. We will share the updated installation photos by this evening.',
          timestamp: 'Today, Just now',
          dateGroup: 'Today',
          contextTag: 'Stage 5: Modular Kitchen',
        ),
      );
      ClientDataRepository.stateVersionNotifier.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Dual Tab Header (Chat vs Meetings)
            _buildTabBar(isDark),

            // Tab Content
            Expanded(
              child: _activeTab == 0
                  ? _buildChatTab(isDark)
                  : _buildMeetingsTab(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTabButton(
            isDark: isDark,
            index: 0,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Project Chat',
            badgeCount: 1,
          ),
          const SizedBox(width: 8),
          _buildTabButton(
            isDark: isDark,
            index: 1,
            icon: Icons.calendar_month_outlined,
            label: 'Review Meetings',
            badgeCount: ClientDataRepository.projectMeetings
                .where((m) => m.isUpcoming)
                .length,
          ),
          const Spacer(),
          if (_activeTab == 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.18 : 0.1),
                borderRadius: AppRadius.full,
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.4 : 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'WhatsApp Synced',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: () {
                CustomerBookMeetingModal.show(
                  context,
                  onBooked: () {
                    setState(() {});
                  },
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Book Meeting'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedAppRadius.md,
                elevation: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required bool isDark,
    required int index,
    required IconData icon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08)
              : Colors.transparent,
          borderRadius: AppRadius.md,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? (isDark ? const Color(0xFF818CF8) : AppColors.primary)
                  : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : AppColors.primary)
                    : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
              ),
            ),
            if (badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade300),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '$badgeCount',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // CHAT TAB
  // ===========================================================================

  Widget _buildChatTab(bool isDark) {
    final messages = ClientDataRepository.chatMessages;
    final isDesktop = Breakpoints.isDesktop(context);

    return Row(
      children: [
        // Chat Area
        Expanded(
          flex: 7,
          child: Column(
            children: [
              // Online Team Members Strip
              _buildTeamOnlineStrip(isDark),

              // Chat Messages List
              Expanded(
                child: ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final showDateHeader = index == 0 ||
                        messages[index - 1].dateGroup != msg.dateGroup;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showDateHeader) _buildDateHeader(msg.dateGroup, isDark),
                        _buildMessageBubble(msg, isDark),
                      ],
                    );
                  },
                ),
              ),

              // Quick Response Chips
              _buildQuickChips(isDark),

              // Message Composer
              _buildMessageComposer(isDark),
            ],
          ),
        ),

        // Right Details Panel on Desktop
        if (isDesktop) ...[
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              border: Border(
                left: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: _buildChatSidebarInfo(isDark),
          ),
        ],
      ],
    );
  }

  Widget _buildTeamOnlineStrip(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people_alt_outlined,
            size: 16,
            color: isDark ? AppColors.darkTextMuted : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            'Active Team Members:',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTeamAvatarChip('Rajesh Verma', 'Lead Architect', const Color(0xFF2563EB), isDark),
                  const SizedBox(width: 8),
                  _buildTeamAvatarChip('Amit Verma', 'Site Supervisor', const Color(0xFF10B981), isDark),
                  const SizedBox(width: 8),
                  _buildTeamAvatarChip('Priya Mehta', 'Senior Designer', const Color(0xFF8B5CF6), isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamAvatarChip(String name, String role, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
        borderRadius: AppRadius.full,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: color,
            child: Text(
              name.split(' ').map((e) => e[0]).take(2).join(),
              style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String dateGroup, bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade200,
          borderRadius: AppRadius.full,
        ),
        child: Text(
          dateGroup,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(CustomerChatMessage msg, bool isDark) {
    final isClient = msg.isClient;

    return Align(
      alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isClient) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: msg.avatarColor,
                child: Text(
                  msg.senderAvatar,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isClient
                      ? AppColors.primary
                      : (isDark ? AppColors.darkSurfaceElevated : Colors.white),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.mdVal),
                    topRight: const Radius.circular(AppRadius.mdVal),
                    bottomLeft: Radius.circular(isClient ? AppRadius.mdVal : 2),
                    bottomRight: Radius.circular(isClient ? 2 : AppRadius.mdVal),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: isClient
                      ? null
                      : Border.all(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                        ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isClient ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    // Sender info for team
                    if (!isClient) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            msg.senderName,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: msg.avatarColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '• ${msg.senderRole}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Context Tag badge
                    if (msg.contextTag != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isClient
                              ? Colors.white.withValues(alpha: 0.2)
                              : (isDark
                                  ? const Color(0xFF78350F).withValues(alpha: 0.3)
                                  : Colors.amber.shade50),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isClient
                                ? Colors.white.withValues(alpha: 0.3)
                                : (isDark
                                    ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
                                    : Colors.amber.shade300),
                          ),
                        ),
                        child: Text(
                          msg.contextTag!,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isClient
                                ? Colors.white
                                : (isDark ? const Color(0xFFFBBF24) : Colors.amber.shade900),
                          ),
                        ),
                      ),
                    ],

                    // Text
                    Text(
                      msg.message,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        height: 1.4,
                        color: isClient
                            ? Colors.white
                            : (isDark ? AppColors.darkTextPrimary : Colors.grey.shade900),
                      ),
                    ),

                    // Attachments
                    if (msg.attachments.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...msg.attachments.map((att) => _buildAttachmentCard(att, isClient, isDark)),
                    ],

                    const SizedBox(height: 4),

                    // Time & Status
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          msg.timestamp,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isClient
                                ? Colors.white.withValues(alpha: 0.7)
                                : (isDark ? AppColors.darkTextMuted : Colors.grey.shade500),
                          ),
                        ),
                        if (isClient) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentCard(ChatAttachment att, bool isClient, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isClient
            ? Colors.black.withValues(alpha: 0.15)
            : (isDark ? AppColors.darkSurfaceSubtle : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isClient
              ? Colors.white.withValues(alpha: 0.2)
              : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            att.type == ChatAttachmentType.photo
                ? Icons.image_outlined
                : (att.type == ChatAttachmentType.cad
                    ? Icons.architecture_rounded
                    : Icons.description_outlined),
            size: 24,
            color: isClient ? Colors.white : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  att.name,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isClient
                        ? Colors.white
                        : (isDark ? AppColors.darkTextPrimary : Colors.grey.shade900),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  att.size,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isClient
                        ? Colors.white70
                        : (isDark ? AppColors.darkTextMuted : Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.download_rounded,
              size: 18,
              color: isClient ? Colors.white : AppColors.primary,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading ${att.name}...'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChips(bool isDark) {
    final chips = [
      'Can we review the kitchen counter finish?',
      'When is the next material delivery scheduled?',
      'Please share the updated electrical plan.',
      'Request a quick site walkthrough call.',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: isDark ? AppColors.darkCard : Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips.map((chip) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(chip),
                labelStyle: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                ),
                backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.fullVal),
                ),
                onPressed: () {
                  _messageController.text = chip;
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMessageComposer(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file_rounded,
              color: isDark ? AppColors.darkTextMuted : Colors.grey,
            ),
            tooltip: 'Attach CAD, PDF, or Photo',
            onPressed: () => _showAttachmentSheet(isDark),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Type your message for the HOMIO project team...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextMuted : Colors.grey.shade400,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.full,
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.full,
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: AppRadius.full,
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
              onPressed: () => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lgVal)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share Attachment with Project Team',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEFF6FF),
                    child: Icon(Icons.photo_library_outlined, color: Color(0xFF2563EB)),
                  ),
                  title: Text(
                    'Site / Inspiration Photo',
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                  ),
                  subtitle: Text(
                    'PNG, JPG up to 15MB',
                    style: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _sendMessage(
                      attachmentName: 'inspiration_kitchen_island.jpg',
                      attachmentType: ChatAttachmentType.photo,
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFEF3C7),
                    child: Icon(Icons.description_outlined, color: Color(0xFFD97706)),
                  ),
                  title: Text(
                    'Specification or CAD Drawing',
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.black),
                  ),
                  subtitle: Text(
                    'PDF, DWG, DXF up to 50MB',
                    style: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _sendMessage(
                      attachmentName: 'custom_wardrobe_dimension_req.pdf',
                      attachmentType: ChatAttachmentType.document,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatSidebarInfo(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Project Communication',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HOM-PROJ-2026-0084',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextMuted : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '3BHK Luxury Residence',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Saraidhela, Dhanbad • Stage 5 (68%)',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Shared Files in Thread',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        _buildSharedFileTile('kitchen_carcase_elevation_v2.dwg', '4.2 MB', 'Aug 29', isDark),
        _buildSharedFileTile('centuryply_warranty_cert.pdf', '1.1 MB', 'Sep 01', isDark),
        _buildSharedFileTile('countertop_quartz_sample.jpg', '3.8 MB', 'Sep 03', isDark),
        const SizedBox(height: 16),
        Text(
          'Emergency Site Contact',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                : Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF047857) : Colors.green.shade200,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.phone_in_talk, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amit Verma (Site Supervisor)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF34D399) : Colors.green.shade900,
                      ),
                    ),
                    Text(
                      '+91 98351 22910',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? Colors.white70 : Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSharedFileTile(String name, String size, String date, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: 16,
            color: isDark ? AppColors.darkTextMuted : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$size • $date',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MEETINGS TAB
  // ===========================================================================

  Widget _buildMeetingsTab(bool isDark) {
    var meetings = ClientDataRepository.projectMeetings;
    if (_selectedMeetingFilter == 'upcoming') {
      meetings = meetings.where((m) => m.isUpcoming).toList();
    } else if (_selectedMeetingFilter == 'completed') {
      meetings = meetings.where((m) => m.status == 'Completed').toList();
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Meeting Filter Bar
        Row(
          children: [
            _buildMeetingFilterChip('all', 'All Meetings (${ClientDataRepository.projectMeetings.length})', isDark),
            const SizedBox(width: 8),
            _buildMeetingFilterChip(
              'upcoming',
              'Upcoming (${ClientDataRepository.projectMeetings.where((m) => m.isUpcoming).length})',
              isDark,
            ),
            const SizedBox(width: 8),
            _buildMeetingFilterChip(
              'completed',
              'Past / Completed (${ClientDataRepository.projectMeetings.where((m) => m.status == 'Completed').length})',
              isDark,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Meeting Cards
        if (meetings.isEmpty) ...[
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(
                  Icons.event_busy_outlined,
                  size: 48,
                  color: isDark ? AppColors.darkTextMuted : Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  'No meetings found under this filter.',
                  style: GoogleFonts.inter(
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          ...meetings.map((meeting) => _buildMeetingCard(meeting, isDark)),
        ],
      ],
    );
  }

  Widget _buildMeetingFilterChip(String key, String label, bool isDark) {
    final isSelected = _selectedMeetingFilter == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12),
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected
            ? (isDark ? const Color(0xFF818CF8) : AppColors.primary)
            : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade700),
      ),
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      side: BorderSide(
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
      ),
      onSelected: (_) => setState(() => _selectedMeetingFilter = key),
    );
  }

  Widget _buildMeetingCard(CustomerProjectMeeting meeting, bool isDark) {
    final isUpcoming = meeting.isUpcoming;
    final isVirtual = meeting.type == CustomerMeetingType.online;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isUpcoming
              ? AppColors.primary.withValues(alpha: isDark ? 0.5 : 0.3)
              : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
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
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceSubtle
                  : (isUpcoming
                      ? AppColors.primary.withValues(alpha: 0.04)
                      : Colors.grey.shade50),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lgVal)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isVirtual ? const Color(0xFFEFF6FF) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isVirtual ? Icons.videocam_rounded : Icons.location_on_rounded,
                    color: isVirtual ? const Color(0xFF2563EB) : const Color(0xFFD97706),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meeting.title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${meeting.date} • ${meeting.timeSlot} (${meeting.duration})',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildMeetingStatusBadge(meeting.status, isDark),
              ],
            ),
          ),

          // Card Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purpose / Agenda
                Text(
                  'Agenda:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meeting.agenda ?? meeting.purpose,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // Host and Attendees
                Row(
                  children: [
                    Text(
                      'Host: ',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextMuted : Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${meeting.attendeeName} (${meeting.attendeeRole})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade900,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Location: ',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextMuted : Colors.grey.shade600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        meeting.locationOrLink,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Minutes of Meeting if Completed
                if (meeting.minutesOfMeeting != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.article_outlined, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Minutes of Meeting & Agreed Actions:',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF818CF8) : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          meeting.minutesOfMeeting!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isUpcoming) ...[
                      OutlinedButton(
                        onPressed: () {
                          ClientDataRepository.cancelMeeting(meeting.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Meeting cancelled.')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? const Color(0xFFF87171) : Colors.red.shade700,
                          side: BorderSide(
                            color: isDark ? const Color(0xFFEF4444).withValues(alpha: 0.5) : Colors.red.shade300,
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      if (isVirtual) ...[
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening Google Meet: ${meeting.locationOrLink}'),
                                backgroundColor: const Color(0xFF047857),
                              ),
                            );
                          },
                          icon: const Icon(Icons.video_call_rounded, size: 18),
                          label: const Text('Join Video Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF047857),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ] else ...[
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Site location pinned: Saraidhela, Dhanbad')),
                            );
                          },
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text('Get Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ] else ...[
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Downloading MOM PDF summary...')),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: const Text('Download MOM PDF'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.darkTextPrimary : Colors.grey.shade800,
                          side: BorderSide(
                            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingStatusBadge(String status, bool isDark) {
    Color bg;
    Color fg;
    String label;

    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'scheduled':
        bg = isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.4) : const Color(0xFFEFF6FF);
        fg = const Color(0xFF60A5FA);
        label = status.toUpperCase();
        break;
      case 'completed':
        bg = isDark ? const Color(0xFF064E3B).withValues(alpha: 0.4) : const Color(0xFFECFDF5);
        fg = const Color(0xFF34D399);
        label = 'COMPLETED';
        break;
      case 'cancelled':
        bg = isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.4) : const Color(0xFFFEF2F2);
        fg = const Color(0xFFF87171);
        label = 'CANCELLED';
        break;
      default:
        bg = isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100;
        fg = isDark ? AppColors.darkTextSecondary : Colors.grey.shade700;
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
