// Homio CRM — Enterprise Scheduled Messages Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';
import '../widgets/comm_page_header.dart';
import '../widgets/comm_kpi_card.dart';
import '../widgets/comm_status_badge.dart';
import '../widgets/comm_filter_bar.dart';
import '../widgets/comm_data_table.dart';

class ScheduledMessagesPage extends StatefulWidget {
  const ScheduledMessagesPage({super.key});

  @override
  State<ScheduledMessagesPage> createState() => _ScheduledMessagesPageState();
}

class _ScheduledMessagesPageState extends State<ScheduledMessagesPage> {
  late List<ScheduledMessage> _messages;
  String _searchQuery = '';
  String _selectedTab = 'All';
  CommunicationChannel? _channelFilter;

  @override
  void initState() {
    super.initState();
    _messages = List.from(CommunicationMockData.scheduledMessages);
  }

  List<ScheduledMessage> get _filteredMessages {
    return _messages.where((m) {
      final q = _searchQuery.toLowerCase();
      if (q.isNotEmpty &&
          !m.recipientName.toLowerCase().contains(q) &&
          !m.recipientPhone.toLowerCase().contains(q) &&
          !m.content.toLowerCase().contains(q)) {
        return false;
      }
      if (_channelFilter != null && m.channel != _channelFilter) {
        return false;
      }
      if (_selectedTab == 'Scheduled' && m.status != ScheduledMessageStatus.scheduled) return false;
      if (_selectedTab == 'Sent' && m.status != ScheduledMessageStatus.sent) return false;
      if (_selectedTab == 'Cancelled' && m.status != ScheduledMessageStatus.cancelled) return false;
      return true;
    }).toList();
  }

  void _showScheduleModal() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    CommunicationChannel channel = CommunicationChannel.whatsapp;
    DateTime scheduledDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Schedule Outbound Communication', style: TextStyle(fontSize: 16)),
              content: SizedBox(
                width: 460,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recipient Client Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Vikram Malhotra',
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Phone Number (+91)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: phoneCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. +91 98450 12345',
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Channel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<CommunicationChannel>(
                        initialValue: channel,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: CommunicationChannel.values.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c.label));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => channel = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text('Message Text', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: contentCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Reminder message content...',
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final phone = phoneCtrl.text.trim();
                    final text = contentCtrl.text.trim();
                    if (name.isEmpty || text.isEmpty) return;

                    final newMsg = ScheduledMessage(
                      id: 'sch_${DateTime.now().millisecondsSinceEpoch}',
                      recipientName: name,
                      recipientPhone: phone.isEmpty ? '+91 98000 00000' : phone,
                      channel: channel,
                      content: text,
                      scheduledFor: scheduledDate,
                      status: ScheduledMessageStatus.scheduled,
                      createdBy: 'Current User',
                    );

                    setState(() {
                      _messages.insert(0, newMsg);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Message scheduled for $name.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Schedule Dispatch'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _cancelScheduled(ScheduledMessage msg) {
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == msg.id);
      if (idx != -1) {
        _messages[idx] = ScheduledMessage(
          id: msg.id,
          recipientName: msg.recipientName,
          recipientPhone: msg.recipientPhone,
          channel: msg.channel,
          templateId: msg.templateId,
          templateName: msg.templateName,
          content: msg.content,
          scheduledFor: msg.scheduledFor,
          timezone: msg.timezone,
          status: ScheduledMessageStatus.cancelled,
          createdBy: msg.createdBy,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scheduled message for ${msg.recipientName} has been cancelled.')),
    );
  }

  void _sendNow(ScheduledMessage msg) {
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == msg.id);
      if (idx != -1) {
        _messages[idx] = ScheduledMessage(
          id: msg.id,
          recipientName: msg.recipientName,
          recipientPhone: msg.recipientPhone,
          channel: msg.channel,
          templateId: msg.templateId,
          templateName: msg.templateName,
          content: msg.content,
          scheduledFor: DateTime.now(),
          timezone: msg.timezone,
          status: ScheduledMessageStatus.sent,
          createdBy: msg.createdBy,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dispatched message immediately to ${msg.recipientName}.')),
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
            title: 'Scheduled Outbound Messages',
            subtitle: 'Manage upcoming timed customer reminders, consultation alerts & milestone notices',
            icon: Icons.schedule_send_rounded,
            primaryActionLabel: 'Schedule Message',
            primaryActionIcon: Icons.add_alarm,
            onPrimaryAction: _showScheduleModal,
            onRefresh: () {
              setState(() {
                _messages = List.from(CommunicationMockData.scheduledMessages);
              });
            },
          ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // KPI Cards
                Row(
                  children: [
                    Expanded(
                      child: CommKpiCard(
                        title: 'Total Queued',
                        value: '${_messages.where((m) => m.status == ScheduledMessageStatus.scheduled).length}',
                        subtitle: 'Awaiting timer trigger',
                        icon: Icons.timer_outlined,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Due Within 24 Hours',
                        value: '4',
                        subtitle: 'Immediate queue',
                        icon: Icons.hourglass_bottom,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Sent Successfully',
                        value: '${_messages.where((m) => m.status == ScheduledMessageStatus.sent).length}',
                        subtitle: 'Triggered jobs',
                        icon: Icons.check_circle_outline,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Cancelled by Staff',
                        value: '${_messages.where((m) => m.status == ScheduledMessageStatus.cancelled).length}',
                        subtitle: 'Halted before send',
                        icon: Icons.cancel_outlined,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Filters
                CommFilterBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                  searchHint: 'Search scheduled messages by recipient, phone, or message text...',
                  categories: const ['All', 'Scheduled', 'Sent', 'Cancelled'],
                  selectedCategory: _selectedTab,
                  onCategorySelected: (cat) => setState(() => _selectedTab = cat),
                  selectedChannel: _channelFilter,
                  onChannelChanged: (c) => setState(() => _channelFilter = c),
                  onResetFilters: () {
                    setState(() {
                      _searchQuery = '';
                      _selectedTab = 'All';
                      _channelFilter = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Table
                _buildScheduledTable(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledTable(bool isDark) {
    final filtered = _filteredMessages;

    final columns = [
      const CommDataColumn(label: 'Recipient', width: 200),
      const CommDataColumn(label: 'Channel', width: 110),
      const CommDataColumn(label: 'Message Preview', width: 280),
      const CommDataColumn(label: 'Scheduled For (IST)', width: 160),
      const CommDataColumn(label: 'Created By', width: 130),
      const CommDataColumn(label: 'Status', width: 120),
      const CommDataColumn(label: 'Actions', width: 120),
    ];

    final rows = filtered.map((m) {
      return CommDataRow(
        cells: [
          // Recipient
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(m.recipientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(m.recipientPhone, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ],
          ),

          // Channel
          CommStatusBadge.fromChannel(m.channel),

          // Content
          Text(
            m.content,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Scheduled Date
          Text(
            m.scheduledFor.toString().substring(0, 16),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),

          // Created By
          Text(
            m.createdBy,
            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),

          // Status
          CommStatusBadge.fromScheduledStatus(m.status),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (m.status == ScheduledMessageStatus.scheduled) ...[
                IconButton(
                  icon: const Icon(Icons.send, size: 16, color: AppColors.primary),
                  tooltip: 'Send Now',
                  onPressed: () => _sendNow(m),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, size: 16, color: Color(0xFFEF4444)),
                  tooltip: 'Cancel',
                  onPressed: () => _cancelScheduled(m),
                ),
              ],
            ],
          ),
        ],
      );
    }).toList();

    return CommDataTable(
      columns: columns,
      rows: rows,
      totalItems: rows.length,
      totalPages: 1,
      currentPage: 1,
    );
  }
}
