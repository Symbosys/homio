import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sales_models.dart';
import '../models/sales_mock_data.dart';
import '../widgets/sales_header.dart';

class SalesWhatsAppPage extends StatefulWidget {
  const SalesWhatsAppPage({super.key});

  @override
  State<SalesWhatsAppPage> createState() => _SalesWhatsAppPageState();
}

class _SalesWhatsAppPageState extends State<SalesWhatsAppPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SalesDateFilter _selectedDateFilter = SalesDateFilter.thisMonth;
  late List<WhatsAppChatThread> _threads;
  late String _activeThreadId;
  final TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _threads = List<WhatsAppChatThread>.from(SalesMockData.whatsappThreads);
    _activeThreadId = _threads.first.id;
  }

  WhatsAppChatThread get _activeChat => _threads.firstWhere(
        (c) => c.id == _activeThreadId,
        orElse: () => _threads.first,
      );

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    final text = _msgController.text.trim();
    _msgController.clear();

    setState(() {
      final chat = _activeChat;
      final newMsg = WhatsAppMessageBubble(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        sender: 'agent',
        text: text,
        timestamp: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        isRead: true,
      );
      chat.messages.add(newMsg);
    });
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
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
            child: SalesHeader(
              title: 'WhatsApp Cloud API Hub',
              subtitle: 'Official Meta Platform, shared team inbox, broadcast campaigns & automated drips',
              icon: Icons.chat_outlined,
              activeFilter: _selectedDateFilter,
              onFilterChanged: (filter) => setState(() => _selectedDateFilter = filter),
              additionalFilters: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 12, color: Color(0xFF10B981)),
                      SizedBox(width: 5),
                      Text(
                        'Meta Cloud API Connected',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.bolt_outlined, size: 14),
                  label: const Text('Drips', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () => setState(() => _tabController.index = 2),
                ),
              ],
              primaryAction: ElevatedButton.icon(
                icon: const Icon(Icons.campaign_outlined, size: 14),
                label: const Text('New Broadcast', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                onPressed: () => _showNewBroadcastModal(context),
              ),
            ),
          ),

          // Tabs Navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: const Color(0xFF2563EB),
                unselectedLabelColor: const Color(0xFF64748B),
                labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(icon: Icon(Icons.chat_outlined, size: 14), text: 'Shared Team Inbox'),
                  Tab(icon: Icon(Icons.send_rounded, size: 14), text: 'Broadcast Campaigns'),
                  Tab(icon: Icon(Icons.auto_mode_outlined, size: 14), text: 'Automated Drips'),
                ],
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSharedInbox(context, isDark),
                _buildBroadcastTab(context, isDark),
                _buildDripTab(context, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharedInbox(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Row(
          children: [
            // Left Column: Chat List
            SizedBox(
              width: 290,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 32,
                      child: TextField(
                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search chat threads...',
                          hintStyle: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          prefixIcon: Icon(Icons.search, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 32),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _threads.length,
                      separatorBuilder: (c, i) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightSurfaceSubtle),
                      itemBuilder: (ctx, idx) {
                        final thread = _threads[idx];
                        final isSelected = thread.id == _activeThreadId;
                        return InkWell(
                          onTap: () => setState(() => _activeThreadId = thread.id),
                          child: Container(
                            color: isSelected
                                ? (isDark ? const Color(0xFF2563EB).withValues(alpha: 0.15) : const Color(0xFFEFF6FF))
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                                  child: Text(
                                    thread.contactName.isNotEmpty ? thread.contactName[0] : 'C',
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            thread.contactName,
                                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            thread.lastMessageTime,
                                            style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 1.5),
                                      Text(
                                        thread.lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 10.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                      ),
                                      const SizedBox(height: 3),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: thread.stageColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Text(
                                          thread.stageTag,
                                          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w600, color: thread.stageColor),
                                        ),
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
              ),
            ),
            VerticalDivider(width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Middle Column: Conversation Canvas
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: const Color(0xFF2563EB),
                              child: Text(_activeChat.contactName[0], style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(_activeChat.contactName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 5),
                                    const Icon(Icons.verified, size: 12, color: Color(0xFF2563EB)),
                                  ],
                                ),
                                Text(
                                  _activeChat.phone,
                                  style: TextStyle(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.call, size: 12, color: Color(0xFF2563EB)),
                          label: const Text('Call', style: TextStyle(fontSize: 10.5)),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // Messages Area
                  Expanded(
                    child: Container(
                      color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _activeChat.messages.length,
                        itemBuilder: (ctx, idx) {
                          final msg = _activeChat.messages[idx];
                          final isAgent = msg.sender == 'agent' || msg.sender == 'ai';

                          return Align(
                            alignment: isAgent ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              constraints: const BoxConstraints(maxWidth: 380),
                              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                              decoration: BoxDecoration(
                                color: isAgent
                                    ? const Color(0xFF2563EB)
                                    : (isDark ? AppColors.darkSurfaceSubtle : Colors.white),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft: Radius.circular(isAgent ? 10 : 2),
                                  bottomRight: Radius.circular(isAgent ? 2 : 10),
                                ),
                                border: isAgent ? null : Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 3, offset: const Offset(0, 1)),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: isAgent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg.text,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isAgent ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        msg.timestamp,
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          color: isAgent ? Colors.white.withValues(alpha: 0.7) : AppColors.darkTextSecondary,
                                        ),
                                      ),
                                      if (isAgent) ...[
                                        const SizedBox(width: 3),
                                        const Icon(Icons.done_all, size: 11, color: Colors.lightBlueAccent),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Quick Replies Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text('Replies: ', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                          const SizedBox(width: 4),
                          _buildQuickReplyChip('Share Catalog', () {
                            _msgController.text = 'Hi ${_activeChat.contactName}, please check our luxury catalog: homio.in/catalog/2026';
                          }),
                          _buildQuickReplyChip('Confirm Survey', () {
                            _msgController.text = 'Would tomorrow at 3:00 PM work for our lead architect to conduct the 3D laser survey?';
                          }),
                          _buildQuickReplyChip('BOQ Revision', () {
                            _msgController.text = 'Attached is your updated BOQ revision with Blum hardware included.';
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Message Input Bar
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_file, size: 16, color: Color(0xFF64748B)),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                          tooltip: 'Attach File',
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 34,
                            child: TextField(
                              controller: _msgController,
                              style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              decoration: InputDecoration(
                                hintText: 'Type WhatsApp message...',
                                hintStyle: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                filled: true,
                                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send_rounded, size: 16, color: Color(0xFF2563EB)),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: _sendMessage,
                          tooltip: 'Send',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right Column: Client Context Drawer
            Container(
              width: 240,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Client CRM Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _buildProfileRow('Client Name', _activeChat.contactName, isDark),
                  _buildProfileRow('Phone', _activeChat.phone, isDark),
                  _buildProfileRow('Stage', _activeChat.stageTag, isDark, isHighlight: true),
                  const Divider(height: 18),
                  const Text('Quick Actions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.straighten, size: 12),
                      label: const Text('Book Laser Survey', style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Survey scheduler opened for ${_activeChat.contactName}')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.swap_horiz, size: 12),
                      label: const Text('Advance Stage', style: TextStyle(fontSize: 10)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${_activeChat.contactName} advanced')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplyChip(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ActionChip(
        label: Text(title, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isHighlight ? const Color(0xFF2563EB) : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastTab(BuildContext context, bool isDark) {
    final campaigns = SalesMockData.broadcastCampaigns;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Official WhatsApp Broadcast Campaigns', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 1),
                Text(
                  'Compliant template broadcasts with verified delivery and response tracking',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(height: 12),
                ...campaigns.map((camp) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(camp.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: camp.statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    camp.status.toUpperCase(),
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: camp.statusColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Sent: ${camp.recipientCount} • Delivered: ${camp.deliveredCount} • Read: ${camp.readCount} • Replies: ${camp.repliedCount}',
                              style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Viewing campaign performance for "${camp.name}"')),
                            );
                          },
                          child: const Text('Analytics', style: TextStyle(fontSize: 10.5)),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDripTab(BuildContext context, bool isDark) {
    final drips = [
      {'step': 'Step 1 (Instant)', 'title': 'Automated Welcome Brochure & 3D Video', 'trigger': 'Meta ad lead created', 'status': 'Active'},
      {'step': 'Step 2 (+24h)', 'title': 'Social Proof Carousel (Top 5 Finished Bangalore Villas)', 'trigger': 'No response within 24h', 'status': 'Active'},
      {'step': 'Step 3 (+72h)', 'title': 'Complimentary 3D Laser Measurement Booking Link', 'trigger': 'Discovery stage inactive', 'status': 'Active'},
      {'step': 'Step 4 (+7d)', 'title': 'Limited-Time Seasonal Appliance Cash-Back Voucher', 'trigger': 'Re-engagement nudge', 'status': 'Active'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Automated Lifecycle Nurturing Drips', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 1),
            Text(
              'Multi-step WhatsApp triggers that nurture leads automatically',
              style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 12),
            ...drips.map((d) {
              return Container(
                margin: const EdgeInsets.only(bottom: 9),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(d['step']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d['title']!, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                          Text('Trigger: ${d['trigger']}', style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(value: true, onChanged: (v) {}),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showNewBroadcastModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration modalInputDeco(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        isDense: true,
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: const Text('Schedule WhatsApp Broadcast', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Campaign Title *'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: 'Interior Clients - Qualified Leads',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                decoration: modalInputDeco('Target Audience Segment'),
                items: [
                  'Interior Clients - Qualified Leads',
                  'High Budget Villa Prospects (> ₹25L)',
                  'Unresponsive Leads (> 7 Days)',
                  'Designer Hiring Talent Pool',
                ].map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 11.5)))).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 2,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Pre-Approved Template Body'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 11.5)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Broadcast queued with Meta Cloud API.')),
              );
            },
            child: const Text('Dispatch', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}
