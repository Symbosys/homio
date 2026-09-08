import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/chat_models.dart';

class LiveCustomerChatsPage extends StatefulWidget {
  const LiveCustomerChatsPage({super.key});

  @override
  State<LiveCustomerChatsPage> createState() => _LiveCustomerChatsPageState();
}

class _LiveCustomerChatsPageState extends State<LiveCustomerChatsPage> {
  late List<ChatThread> _threads;
  late String _selectedThreadId;
  String _searchQuery = '';
  ClientStage? _filterStage;
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _msgInputCtrl = TextEditingController();

  final List<String> _quickReplies = [
    'Sharing the revised 3D Matterport walkthrough link now.',
    'Civil inspection passed successfully. Preparing site milestone photos.',
    'Would Saturday 4:00 PM suit you for the on-site consultation?',
    'Revised BOQ has been updated in your Client Portal.',
  ];

  @override
  void initState() {
    super.initState();
    _threads = List.from(ChatMockData.threads);
    _selectedThreadId = _threads.first.id;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _msgInputCtrl.dispose();
    super.dispose();
  }

  ChatThread get _activeThread {
    return _threads.firstWhere(
      (t) => t.id == _selectedThreadId,
      orElse: () => _threads.first,
    );
  }

  List<ChatThread> get _filteredThreads {
    return _threads.where((t) {
      if (_filterStage != null && t.stage != _filterStage) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = t.customerName.toLowerCase().contains(q);
        final matchPhone = t.customerPhone.contains(q);
        final matchProject = t.projectTitle.toLowerCase().contains(q);
        if (!matchName && !matchPhone && !matchProject) return false;
      }
      return true;
    }).toList();
  }

  void _sendMessage() {
    final text = _msgInputCtrl.text.trim();
    if (text.isEmpty) return;

    _msgInputCtrl.clear();
    final now = TimeOfDay.now();
    final timeStr = '${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}';

    setState(() {
      _activeThread.messages.add(
        ChatMessage(
          id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
          sender: 'agent',
          text: text,
          timestamp: timeStr,
          isRead: true,
          isDelivered: true,
        ),
      );
    });
  }

  void _sendQuickReply(String reply) {
    _msgInputCtrl.text = reply;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textMuted = AppColors.getTextMuted(context);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 750;
          final isTablet = constraints.maxWidth >= 750 && constraints.maxWidth < 1150;

          if (isMobile) {
            // Mobile 1-pane flow
            return _buildMobileView(context, isDark, surfaceColor, borderColor, textPrimary, textMuted);
          }

          if (isTablet) {
            // Tablet 2-pane (Thread List + Chat Conversation)
            return Row(
              children: [
                SizedBox(
                  width: 320,
                  child: _buildThreadListPane(context, isDark, surfaceColor, borderColor, textPrimary, textMuted),
                ),
                VerticalDivider(width: 1, color: borderColor),
                Expanded(
                  child: _buildConversationPane(context, isDark, surfaceColor, borderColor, textPrimary, textMuted, showDrawerAction: true),
                ),
              ],
            );
          }

          // Desktop 3-pane (Thread List + Chat Conversation + Client CRM Drawer)
          return Row(
            children: [
              SizedBox(
                width: 340,
                child: _buildThreadListPane(context, isDark, surfaceColor, borderColor, textPrimary, textMuted),
              ),
              VerticalDivider(width: 1, color: borderColor),
              Expanded(
                flex: 3,
                child: _buildConversationPane(context, isDark, surfaceColor, borderColor, textPrimary, textMuted),
              ),
              VerticalDivider(width: 1, color: borderColor),
              SizedBox(
                width: 330,
                child: _buildClientInfoDrawer(context, isDark, surfaceColor, borderColor, textPrimary, textMuted),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileView(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    return _buildConversationPane(
      context,
      isDark,
      surfaceColor,
      borderColor,
      textPrimary,
      textMuted,
      showBackButton: true,
      showDrawerAction: true,
    );
  }

  // ---------------------------------------------------------------------------
  // PANE 1: THREAD LIST
  // ---------------------------------------------------------------------------
  Widget _buildThreadListPane(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    final filtered = _filteredThreads;

    return Container(
      color: surfaceColor,
      child: Column(
        children: [
          // Header & Search
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Live Chats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.circle, size: 8, color: Color(0xFF25D366)),
                          const SizedBox(width: 5),
                          Text('${_threads.length} Threads', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF25D366))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: TextStyle(fontSize: 12.5, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search customer name, phone, project...',
                    hintStyle: TextStyle(fontSize: 12.5, color: textMuted),
                    prefixIcon: Icon(Icons.search_rounded, size: 18, color: textMuted),
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStageFilterChip('All', null),
                      ...ClientStage.values.map((stg) => _buildStageFilterChip(stg.label, stg)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Thread List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('No matching chats', style: TextStyle(color: textMuted, fontSize: 13)),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (ctx, idx) => Divider(height: 1, color: borderColor),
                    itemBuilder: (ctx, idx) {
                      final t = filtered[idx];
                      final isSelected = t.id == _selectedThreadId;
                      final last = t.lastMessage;

                      return ListTile(
                        onTap: () {
                          setState(() {
                            _selectedThreadId = t.id;
                            t.unreadCount = 0;
                          });
                        },
                        tileColor: isSelected ? const Color(0xFF25D366).withValues(alpha: isDark ? 0.12 : 0.08) : Colors.transparent,
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: t.stage.color.withValues(alpha: 0.2),
                              child: Text(
                                t.customerName.isNotEmpty ? t.customerName.substring(0, 1) : 'C',
                                style: TextStyle(fontWeight: FontWeight.w800, color: t.stage.color),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(t.channel.icon, size: 12, color: t.channel.color),
                              ),
                            ),
                          ],
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                t.customerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: t.unreadCount > 0 ? FontWeight.w800 : FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            Text(last.timestamp, style: TextStyle(fontSize: 10.5, color: textMuted)),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 3),
                            Text(
                              last.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: t.unreadCount > 0 ? textPrimary : textMuted,
                                fontWeight: t.unreadCount > 0 ? FontWeight.w700 : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: t.stage.color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    t.stage.label,
                                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: t.stage.color),
                                  ),
                                ),
                                const Spacer(),
                                if (t.unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF25D366),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${t.unreadCount}',
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageFilterChip(String label, ClientStage? stage) {
    final isSelected = _filterStage == stage;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        selected: isSelected,
        onSelected: (_) => setState(() => _filterStage = isSelected ? null : stage),
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PANE 2: CONVERSATION PANE
  // ---------------------------------------------------------------------------
  Widget _buildConversationPane(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted, {
    bool showBackButton = false,
    bool showDrawerAction = false,
  }) {
    final thread = _activeThread;

    return Container(
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Sticky Top Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                if (showBackButton) ...[
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 4),
                ],
                CircleAvatar(
                  radius: 18,
                  backgroundColor: thread.stage.color.withValues(alpha: 0.15),
                  child: Text(
                    thread.customerName.substring(0, 1),
                    style: TextStyle(fontWeight: FontWeight.w800, color: thread.stage.color),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(thread.customerName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Meta Cloud Verified', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('${thread.projectTitle} • ${thread.propertyLocation}', style: TextStyle(fontSize: 11.5, color: textMuted)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling ${thread.customerPhone}...')),
                    );
                  },
                  icon: const Icon(Icons.phone_rounded, color: Color(0xFF3B82F6), size: 20),
                  tooltip: 'Call Customer',
                ),
                if (showDrawerAction)
                  IconButton(
                    onPressed: () => _openMobileClientDrawer(context, isDark, surfaceColor, borderColor, textPrimary, textMuted),
                    icon: const Icon(Icons.info_outline_rounded, size: 20),
                    tooltip: 'View Client CRM Info',
                  ),
              ],
            ),
          ),

          // Message Bubbles Area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: thread.messages.length,
              itemBuilder: (ctx, idx) {
                final msg = thread.messages[idx];
                final isAgent = msg.sender == 'agent';

                return Align(
                  alignment: isAgent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: const BoxConstraints(maxWidth: 480),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isAgent
                          ? const Color(0xFF25D366).withValues(alpha: isDark ? 0.25 : 0.15)
                          : surfaceColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isAgent ? 12 : 0),
                        bottomRight: Radius.circular(isAgent ? 0 : 12),
                      ),
                      border: Border.all(
                        color: isAgent
                            ? const Color(0xFF25D366).withValues(alpha: 0.3)
                            : borderColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.attachmentType == 'image' && msg.attachmentUrl != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              msg.attachmentUrl!,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (msg.attachmentType == 'pdf') ...[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 20),
                                SizedBox(width: 8),
                                Expanded(child: Text('Digital_Warranty_Docket.pdf', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(msg.text, style: TextStyle(fontSize: 13, color: textPrimary, height: 1.35)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(msg.timestamp, style: TextStyle(fontSize: 10, color: textMuted)),
                            if (isAgent) ...[
                              const SizedBox(width: 4),
                              Icon(
                                msg.isRead ? Icons.done_all : Icons.done,
                                size: 14,
                                color: msg.isRead ? const Color(0xFF34B7F1) : textMuted,
                              ),
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

          // Quick Replies Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: surfaceColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  ..._quickReplies.map((r) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(r, style: const TextStyle(fontSize: 11)),
                        onPressed: () => _sendQuickReply(r),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, size: 20),
                  tooltip: 'Attach Drawing / Photos',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening file browser for drawings & photos...')),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _msgInputCtrl,
                    onSubmitted: (_) => _sendMessage(),
                    style: TextStyle(fontSize: 13, color: textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Type a WhatsApp message or choose quick reply...',
                      hintStyle: TextStyle(fontSize: 13, color: textMuted),
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: borderColor)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF25D366),
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PANE 3: CLIENT CRM DRAWER
  // ---------------------------------------------------------------------------
  Widget _buildClientInfoDrawer(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    final thread = _activeThread;
    final numFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      color: surfaceColor,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: thread.stage.color.withValues(alpha: 0.15),
                    child: Text(
                      thread.customerName.substring(0, 1),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: thread.stage.color),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(thread.customerName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                  const SizedBox(height: 2),
                  Text(thread.customerPhone, style: TextStyle(fontSize: 12, color: textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 16),

            Text('PROJECT SUMMARY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: textMuted)),
            const SizedBox(height: 10),
            _buildDrawerInfoRow('Project:', thread.projectTitle, textPrimary, textMuted),
            _buildDrawerInfoRow('Location:', thread.propertyLocation, textPrimary, textMuted),
            _buildDrawerInfoRow('Estimated BOQ:', numFormat.format(thread.budget), const Color(0xFF10B981), textMuted),
            _buildDrawerInfoRow('Assigned Lead:', thread.assignedAgent, textPrimary, textMuted),

            const SizedBox(height: 20),
            Text('CURRENT STAGE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: textMuted)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: thread.stage.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: thread.stage.color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag_rounded, color: thread.stage.color, size: 18),
                  const SizedBox(width: 8),
                  Text(thread.stage.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: thread.stage.color)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text('QUICK CRM ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: textMuted)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening quotation generator for ${thread.customerName}...')),
                  );
                },
                icon: const Icon(Icons.request_quote_rounded, size: 16),
                label: const Text('Generate New BOQ / Quote'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scheduling site visit for ${thread.customerName}...')),
                  );
                },
                icon: const Icon(Icons.calendar_month_rounded, size: 16),
                label: const Text('Schedule Site Measurement'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerInfoRow(String label, String value, Color valColor, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 95, child: Text(label, style: TextStyle(fontSize: 11.5, color: labelColor))),
          Expanded(child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: valColor))),
        ],
      ),
    );
  }

  void _openMobileClientDrawer(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: _buildClientInfoDrawer(context, isDark, surfaceColor, borderColor, textPrimary, textMuted),
      ),
    );
  }
}
