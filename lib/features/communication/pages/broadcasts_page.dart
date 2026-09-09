// Homio CRM — Enterprise Broadcast Communication Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';
import '../widgets/comm_page_header.dart';
import '../widgets/comm_kpi_card.dart';
import '../widgets/comm_status_badge.dart';
import '../widgets/comm_filter_bar.dart';
import '../widgets/comm_data_table.dart';
import '../widgets/broadcast_progress_indicator.dart';

class BroadcastsPage extends StatefulWidget {
  const BroadcastsPage({super.key});

  @override
  State<BroadcastsPage> createState() => _BroadcastsPageState();
}

class _BroadcastsPageState extends State<BroadcastsPage> {
  late List<Broadcast> _broadcasts;
  String _searchQuery = '';
  String _selectedTab = 'All';
  CommunicationChannel? _channelFilter;

  @override
  void initState() {
    super.initState();
    _broadcasts = List.from(CommunicationMockData.broadcasts);
  }

  List<Broadcast> get _filteredBroadcasts {
    return _broadcasts.where((b) {
      final q = _searchQuery.toLowerCase();
      if (q.isNotEmpty && !b.title.toLowerCase().contains(q) && !b.audienceFilter.toLowerCase().contains(q)) {
        return false;
      }
      if (_channelFilter != null && b.channel != _channelFilter) {
        return false;
      }
      if (_selectedTab == 'Processing' && b.status != BroadcastStatus.processing) return false;
      if (_selectedTab == 'Completed' && b.status != BroadcastStatus.completed) return false;
      if (_selectedTab == 'Scheduled' && b.status != BroadcastStatus.scheduled) return false;
      if (_selectedTab == 'Draft' && b.status != BroadcastStatus.draft) return false;
      return true;
    }).toList();
  }

  void _showCreateBroadcastDialog() {
    final titleCtrl = TextEditingController();
    CommunicationChannel channel = CommunicationChannel.whatsapp;
    String audience = 'Qualified Leads (Budget > ₹30L)';
    String templateName = CommunicationMockData.templates.first.name;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create Outbound Broadcast Campaign', style: TextStyle(fontSize: 16)),
              content: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Campaign Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        hintText: 'e.g. Festive Lighting Upgrade Early Bird',
                        filled: true,
                        fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Delivery Channel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                        if (val != null) setDialogState(() => channel = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text('Audience Target Segment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: audience,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Qualified Leads (Budget > ₹30L)', child: Text('Qualified Leads (Budget > ₹30L)')),
                        DropdownMenuItem(value: 'Active Execution Projects', child: Text('Active Execution Projects')),
                        DropdownMenuItem(value: 'All High-Intent Inquiries', child: Text('All High-Intent Inquiries')),
                        DropdownMenuItem(value: 'Handed-Over Clients (After-Sales)', child: Text('Handed-Over Clients (After-Sales)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => audience = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text('WhatsApp Approved Template', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: templateName,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: CommunicationMockData.templates.map((t) {
                        return DropdownMenuItem(value: t.name, child: Text(t.name));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => templateName = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) return;

                    final newBc = Broadcast(
                      id: 'bc_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      channel: channel,
                      audienceFilter: audience,
                      targetCount: 650,
                      sentCount: 0,
                      deliveredCount: 0,
                      readCount: 0,
                      failedCount: 0,
                      templateId: 'tpl_welcome_01',
                      templateName: templateName,
                      status: BroadcastStatus.scheduled,
                      scheduledAt: DateTime.now().add(const Duration(hours: 4)),
                      createdBy: 'Current User',
                      rawMessage: 'Campaign draft scheduled for automated dispatch.',
                    );

                    setState(() {
                      _broadcasts.insert(0, newBc);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Broadcast "$title" created and scheduled.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Schedule Broadcast'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final processingBroadcast = _broadcasts.firstWhere(
      (b) => b.status == BroadcastStatus.processing,
      orElse: () => _broadcasts.first,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CommPageHeader(
            title: 'Broadcast Campaigns',
            subtitle: 'One-to-many segmented messaging for marketing announcements, price alerts & newsletters',
            icon: Icons.podcasts_rounded,
            primaryActionLabel: 'Create Broadcast',
            primaryActionIcon: Icons.add_circle_outline,
            onPrimaryAction: _showCreateBroadcastDialog,
            onRefresh: () {
              setState(() {
                _broadcasts = List.from(CommunicationMockData.broadcasts);
              });
            },
          ),

          // Scrollable Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // KPI Cards
                Row(
                  children: [
                    Expanded(
                      child: CommKpiCard(
                        title: 'Total Broadcasts',
                        value: '${_broadcasts.length}',
                        subtitle: 'All channels',
                        icon: Icons.campaign_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Live Processing',
                        value: '${_broadcasts.where((b) => b.status == BroadcastStatus.processing).length}',
                        subtitle: 'Active queue',
                        icon: Icons.sync,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Completed',
                        value: '${_broadcasts.where((b) => b.status == BroadcastStatus.completed).length}',
                        subtitle: 'Delivered successfully',
                        icon: Icons.check_circle_outline,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Scheduled Future',
                        value: '${_broadcasts.where((b) => b.status == BroadcastStatus.scheduled).length}',
                        subtitle: 'In pipeline',
                        icon: Icons.schedule_outlined,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Live Active Processing Highlight Banner
                if (_broadcasts.any((b) => b.status == BroadcastStatus.processing)) ...[
                  BroadcastProgressIndicator(
                    broadcast: processingBroadcast,
                    onPause: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Broadcast queue paused.')),
                      );
                    },
                    onCancel: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Broadcast cancelled.')),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // Filter Bar
                CommFilterBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                  searchHint: 'Search broadcasts by campaign name or target audience...',
                  categories: const ['All', 'Processing', 'Completed', 'Scheduled', 'Draft'],
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

                // Broadcasts Data Table
                _buildBroadcastsTable(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastsTable(bool isDark) {
    final filtered = _filteredBroadcasts;

    final columns = [
      const CommDataColumn(label: 'Campaign Title', width: 260),
      const CommDataColumn(label: 'Channel', width: 110),
      const CommDataColumn(label: 'Target Audience', width: 220),
      const CommDataColumn(label: 'Status', width: 120),
      const CommDataColumn(label: 'Recipients', width: 110),
      const CommDataColumn(label: 'Delivery Rate', width: 110),
      const CommDataColumn(label: 'Read Rate', width: 100),
      const CommDataColumn(label: 'Scheduled At', width: 140),
    ];

    final rows = filtered.map((b) {
      return CommDataRow(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing campaign details: ${b.title}')),
          );
        },
        cells: [
          // Title + Template Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                b.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Template: ${b.templateName}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),

          // Channel
          CommStatusBadge.fromChannel(b.channel),

          // Audience
          Text(
            b.audienceFilter,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Status
          CommStatusBadge.fromBroadcastStatus(b.status),

          // Recipients (Sent / Target)
          Text(
            '${b.sentCount} / ${b.targetCount}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),

          // Delivery Rate
          Text(
            b.targetCount == 0 ? '0%' : '${(b.deliveryRate * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: b.deliveryRate > 0.9 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
            ),
          ),

          // Read Rate
          Text(
            b.deliveredCount == 0 ? '0%' : '${(b.readRate * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
          ),

          // Scheduled Date
          Text(
            b.scheduledAt.toString().substring(0, 16),
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
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
