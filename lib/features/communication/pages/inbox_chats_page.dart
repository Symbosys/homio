// Homio CRM — Enterprise Shared Inbox & Customer Chats Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';
import '../widgets/comm_page_header.dart';
import '../widgets/comm_status_badge.dart';
import '../widgets/conversation_list_tile.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';
import '../widgets/customer_context_panel.dart';

class InboxChatsPage extends StatefulWidget {
  const InboxChatsPage({super.key});

  @override
  State<InboxChatsPage> createState() => _InboxChatsPageState();
}

class _InboxChatsPageState extends State<InboxChatsPage> {
  late List<Conversation> _conversations;
  Conversation? _selectedConversation;
  String _searchQuery = '';
  String _selectedTab = 'All'; // All, Unread, Assigned to Me, Starred, Open, Pending
  CommunicationChannel? _channelFilter;
  CustomerCrmStage? _stageFilter;
  bool _showRightPanel = true;

  @override
  void initState() {
    super.initState();
    _conversations = List.from(CommunicationMockData.conversations);
    if (_conversations.isNotEmpty) {
      _selectedConversation = _conversations.first;
    }
  }

  List<Conversation> get _filteredConversations {
    return _conversations.where((conv) {
      final name = conv.customerContext.customerName.toLowerCase();
      final phone = conv.customerContext.customerPhone.toLowerCase();
      final lastMsg = conv.lastMessage.toLowerCase();
      final q = _searchQuery.toLowerCase();

      if (q.isNotEmpty && !name.contains(q) && !phone.contains(q) && !lastMsg.contains(q)) {
        return false;
      }

      if (_channelFilter != null && conv.channel != _channelFilter) {
        return false;
      }

      if (_stageFilter != null && conv.customerContext.crmStage != _stageFilter) {
        return false;
      }

      if (_selectedTab == 'Unread' && conv.unreadCount == 0) return false;
      if (_selectedTab == 'Starred' && !conv.isStarred) return false;
      if (_selectedTab == 'Assigned to Me' && conv.assignedEmployeeName != 'Priya Sharma') return false;
      if (_selectedTab == 'Open' && conv.status != ConversationStatus.open) return false;
      if (_selectedTab == 'Pending' && conv.status != ConversationStatus.pending) return false;

      return true;
    }).toList();
  }

  void _handleSendMessage(ChatMessage message) {
    if (_selectedConversation == null) return;

    setState(() {
      final updatedMessages = List<ChatMessage>.from(_selectedConversation!.messages)..add(message);
      final updatedConv = _selectedConversation!.copyWith(
        messages: updatedMessages,
        lastMessage: message.isInternalNote ? '[Note] ${message.content}' : message.content,
        lastMessageTime: message.timestamp,
        unreadCount: 0,
      );

      final idx = _conversations.indexWhere((c) => c.id == updatedConv.id);
      if (idx != -1) {
        _conversations[idx] = updatedConv;
        _selectedConversation = updatedConv;
      }
    });
  }

  void _toggleStarred(Conversation conv) {
    setState(() {
      final updated = conv.copyWith(isStarred: !conv.isStarred);
      final idx = _conversations.indexWhere((c) => c.id == conv.id);
      if (idx != -1) {
        _conversations[idx] = updated;
        if (_selectedConversation?.id == conv.id) {
          _selectedConversation = updated;
        }
      }
    });
  }

  void _resolveConversation() {
    if (_selectedConversation == null) return;
    setState(() {
      final updated = _selectedConversation!.copyWith(status: ConversationStatus.resolved);
      final idx = _conversations.indexWhere((c) => c.id == updated.id);
      if (idx != -1) {
        _conversations[idx] = updated;
        _selectedConversation = updated;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation #${_selectedConversation!.id} marked as Resolved.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CommPageHeader(
            title: 'Customer Conversations & Shared Inbox',
            subtitle: 'Centralized omnichannel customer communication workspace with CRM 360° sync',
            icon: Icons.inbox_rounded,
            primaryActionLabel: 'New Outbound Chat',
            primaryActionIcon: Icons.edit_note,
            onPrimaryAction: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Initiating new outbound WhatsApp message dialog...')),
              );
            },
            onRefresh: () {
              setState(() {
                _conversations = List.from(CommunicationMockData.conversations);
              });
            },
          ),

          // Main 3-Column Content Layout
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1080;
                final isTablet = constraints.maxWidth >= 720 && constraints.maxWidth < 1080;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column: Conversation Directory & Filters
                    SizedBox(
                      width: isDesktop ? 340 : (isTablet ? 300 : constraints.maxWidth),
                      child: _buildConversationListPane(isDark),
                    ),

                    // Middle Column: Active Conversation Stream & Composer
                    if (isDesktop || isTablet) ...[
                      Expanded(
                        child: _selectedConversation == null
                            ? _buildEmptyConversationPlaceholder(isDark)
                            : _buildActiveChatPane(isDark),
                      ),
                    ],

                    // Right Column: CRM Context 360 Panel
                    if (isDesktop && _showRightPanel && _selectedConversation != null) ...[
                      CustomerContextPanel(
                        contextData: _selectedConversation!.customerContext,
                        onClose: () => setState(() => _showRightPanel = false),
                        onScheduleMeeting: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Scheduling design meeting with ${_selectedConversation!.customerContext.customerName}...'),
                            ),
                          );
                        },
                        onViewCrmProfile: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Navigating to CRM Profile for ${_selectedConversation!.customerContext.customerId}...'),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationListPane(bool isDark) {
    final filtered = _filteredConversations;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: SizedBox(
              height: 38,
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search chats, clients, phones...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  contentPadding: EdgeInsets.zero,
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
            ),
          ),

          // Quick Filter Tabs (All, Unread, Assigned to Me, Starred, Open)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: ['All', 'Unread', 'Assigned to Me', 'Starred', 'Open', 'Pending'].map((tab) {
                final isSelected = _selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => setState(() => _selectedTab = tab),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Filter by Channel & CRM Stage Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CommunicationChannel?>(
                        value: _channelFilter,
                        isDense: true,
                        hint: const Text('Channel', style: TextStyle(fontSize: 11)),
                        icon: const Icon(Icons.arrow_drop_down, size: 16),
                        onChanged: (c) => setState(() => _channelFilter = c),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Channels', style: TextStyle(fontSize: 11))),
                          ...CommunicationChannel.values.map(
                            (c) => DropdownMenuItem(value: c, child: Text(c.label, style: const TextStyle(fontSize: 11))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CustomerCrmStage?>(
                        value: _stageFilter,
                        isDense: true,
                        hint: const Text('CRM Stage', style: TextStyle(fontSize: 11)),
                        icon: const Icon(Icons.arrow_drop_down, size: 16),
                        onChanged: (s) => setState(() => _stageFilter = s),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Stages', style: TextStyle(fontSize: 11))),
                          ...CustomerCrmStage.values.map(
                            (s) => DropdownMenuItem(value: s, child: Text(s.label, style: const TextStyle(fontSize: 11))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Conversation Tiles List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'No conversations match selected criteria.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final conv = filtered[idx];
                      final isSelected = _selectedConversation?.id == conv.id;
                      return ConversationListTile(
                        conversation: conv,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedConversation = conv;
                            // Clear unread count on select
                            if (conv.unreadCount > 0) {
                              final updated = conv.copyWith(unreadCount: 0);
                              final cIdx = _conversations.indexWhere((c) => c.id == conv.id);
                              if (cIdx != -1) _conversations[cIdx] = updated;
                            }
                          });
                        },
                        onToggleStarred: () => _toggleStarred(conv),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChatPane(bool isDark) {
    final conv = _selectedConversation!;
    final ctx = conv.customerContext;

    return Container(
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      child: Column(
        children: [
          // Active Chat Top Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    ctx.customerName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ctx.customerName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          CommStatusBadge.fromChannel(conv.channel),
                          const SizedBox(width: 6),
                          CommStatusBadge.fromPriority(conv.priority),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${ctx.customerPhone} • ${ctx.projectName ?? ctx.propertyType} • Assigned: ${conv.assignedEmployeeName}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  tooltip: 'Resolve Conversation',
                  onPressed: _resolveConversation,
                ),
                IconButton(
                  icon: Icon(
                    _showRightPanel ? Icons.dock : Icons.arrow_back_ios_new,
                    size: 18,
                  ),
                  tooltip: _showRightPanel ? 'Hide CRM Panel' : 'Show CRM Panel',
                  onPressed: () => setState(() => _showRightPanel = !_showRightPanel),
                ),
              ],
            ),
          ),

          // Message Timeline List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: conv.messages.length,
              itemBuilder: (context, idx) {
                final msg = conv.messages[idx];
                return MessageBubble(
                  message: msg,
                  onButtonClicked: (title) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Action: $title triggered for ${ctx.customerName}')),
                    );
                  },
                );
              },
            ),
          ),

          // Message Composer at Bottom
          MessageComposer(
            initialChannel: conv.channel,
            conversationId: conv.id,
            recipientName: ctx.customerName,
            onSendMessage: _handleSendMessage,
            onScheduleMessage: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening message schedule dialog for this conversation...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyConversationPlaceholder(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(height: 16),
          const Text(
            'Select a conversation to start messaging',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose from the list on the left or initiate a new outbound WhatsApp broadcast.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
