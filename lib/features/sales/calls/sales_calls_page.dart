import 'package:flutter/material.dart';
import '../../../core/layout/adaptive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../data/sales_repository.dart';
import '../domain/sales_domain_models.dart';
import '../domain/sales_enums.dart';
import '../widgets/crm_header.dart';
import '../widgets/lead_detail_360_modal.dart';

/// Screen 6: Calls & AI Autodialer Console
/// Includes Call Logs with Audio Playback Simulation, AI Transcript Analysis,
/// Autodialer Campaign Queue, and Telephony Performance Metrics.
class SalesCallsPage extends StatefulWidget {
  const SalesCallsPage({super.key});

  @override
  State<SalesCallsPage> createState() => _SalesCallsPageState();
}

class _SalesCallsPageState extends State<SalesCallsPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  bool _isLoading = true;
  String _selectedScope = 'All Organization';
  CallOutcome? _selectedOutcome;
  CallCategory? _selectedCategory;

  List<CallLogRecord> _callLogs = [];
  String? _currentlyPlayingCallId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCallLogs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCallLogs({bool preserveScroll = true}) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isLoading = true);

    final results = await SalesRepository.instance.getCallLogs(
      query: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      outcome: _selectedOutcome,
      category: _selectedCategory,
    );

    if (!mounted) return;
    setState(() {
      _callLogs = results;
      _isLoading = false;
    });

    if (preserveScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(savedOffset.clamp(0.0, max));
        }
      });
    }
  }

  void _toggleAudioPlay(String callId) {
    setState(() {
      if (_currentlyPlayingCallId == callId) {
        _currentlyPlayingCallId = null;
      } else {
        _currentlyPlayingCallId = callId;
      }
    });
  }

  void _showTranscriptDialog(CallLogRecord call) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.psychology_alt_rounded, color: AppColors.primary, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'AI Call Transcript & Insights: ${call.clientName}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 540,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Summary Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text('HOMIO AI Key Takeaways', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(call.aiSummary, style: const TextStyle(fontSize: 12, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Sentiment & Action items
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sentiment_satisfied_alt_rounded, size: 14, color: Colors.green),
                          SizedBox(width: 4),
                          Text('Sentiment: High Intent (94%)', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Duration: ${call.durationSeconds}s', style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                const Text('Verbatim Transcript:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).brightness == Brightness.dark ? Colors.black26 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    call.transcript,
                    style: const TextStyle(fontSize: 12, height: 1.5, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (c) => LeadDetail360Modal(leadId: call.leadId),
              );
            },
            icon: const Icon(Icons.person_rounded, size: 16),
            label: const Text('Open Lead 360° Profile'),
          ),
        ],
      ),
    );
  }

  void _openDialpad() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.dialpad_rounded, color: AppColors.primary),
            SizedBox(width: 10),
            Text('Quick Dialpad & VoIP Call'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                hintText: '+91 98XXX XXXXX',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'].map((d) {
                return SizedBox(
                  width: 54,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(d, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting Cloud VoIP call...')),
              );
            },
            icon: const Icon(Icons.call_rounded),
            label: const Text('Connect Call'),
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenType = AdaptiveLayout.getScreenType(context);
    final isDesktop = screenType == ScreenType.desktop || screenType == ScreenType.laptop;

    // Metrics calculations
    final connectedCount = _callLogs.where((c) => c.outcome == CallOutcome.connected).length;
    final totalDuration = _callLogs.fold(0, (sum, c) => sum + c.durationSeconds);
    final avgDuration = _callLogs.isNotEmpty ? (totalDuration / _callLogs.length).round() : 0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CrmHeader(
            title: 'Calls & Telephony Intelligence',
            subtitle: 'Cloud VoIP call logs, audio waveform playback, AI auto-transcripts, and autodialer queues.',
            scope: _selectedScope,
            onScopeChanged: (val) {
              setState(() => _selectedScope = val);
              _loadCallLogs(preserveScroll: true);
            },
            onRefresh: () => _loadCallLogs(preserveScroll: true),
            actionButtons: [
              FilledButton.icon(
                onPressed: _openDialpad,
                icon: const Icon(Icons.dialpad_rounded, size: 18),
                label: const Text('Launch Dialpad'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),

          // Main View Body
          Expanded(
            child: _isLoading && _callLogs.isEmpty
                ? const DashboardSkeleton(itemCount: 6, height: 75)
                : RefreshIndicator(
                    onRefresh: () => _loadCallLogs(preserveScroll: true),
                    child: SingleChildScrollView(
                      key: const PageStorageKey('sales_calls_page_scroll'),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // KPI Metric Strip
                          _buildCallKpis(connectedCount, avgDuration, _callLogs.length, isDark, isDesktop),
                          const SizedBox(height: 16),

                          // Tabs: Call Logs vs AI Campaign Queue
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: _tabController,
                                  labelColor: AppColors.primary,
                                  unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  indicatorColor: AppColors.primary,
                                  tabs: const [
                                    Tab(icon: Icon(Icons.call_end_rounded, size: 18), text: 'Call Logs & Audio Playback'),
                                    Tab(icon: Icon(Icons.campaign_rounded, size: 18), text: 'AI Autodialer Campaigns'),
                                  ],
                                ),
                                SizedBox(
                                  height: 600,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildCallLogsTab(isDark),
                                      _buildAutodialerCampaignsTab(isDark),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallKpis(int connected, int avgDurationSec, int total, bool isDark, bool isDesktop) {
    final connectionRate = total > 0 ? ((connected / total) * 100).toStringAsFixed(1) : '0.0';
    final cards = [
      _buildMiniKpi(
        title: 'Total Calls Logged',
        value: '$total Calls',
        subtitle: 'Inbound & Outbound VoIP',
        icon: Icons.phone_in_talk_rounded,
        color: AppColors.primary,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Connection Rate',
        value: '$connectionRate%',
        subtitle: '$connected connected conversations',
        icon: Icons.verified_user_rounded,
        color: Colors.green,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'Average Duration',
        value: '${avgDurationSec ~/ 60}m ${avgDurationSec % 60}s',
        subtitle: 'Sufficient discovery depth',
        icon: Icons.timer_rounded,
        color: Colors.blue,
        isDark: isDark,
      ),
      _buildMiniKpi(
        title: 'AI Transcribed',
        value: '$total / $total',
        subtitle: '100% automated analysis',
        icon: Icons.auto_awesome_rounded,
        color: Colors.purple,
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    }
  }

  Widget _buildMiniKpi({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallLogsTab(bool isDark) {
    return Column(
      children: [
        // Filter bar
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _loadCallLogs(preserveScroll: true),
                  decoration: const InputDecoration(
                    hintText: 'Search client, phone...',
                    hintStyle: TextStyle(fontSize: 12),
                    prefixIcon: Icon(Icons.search, size: 16),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButton<CallOutcome?>(
                    value: _selectedOutcome,
                    isDense: true,
                    hint: const Text('All Outcomes', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Outcomes', style: TextStyle(fontSize: 12))),
                      ...CallOutcome.values.map((o) => DropdownMenuItem(value: o, child: Text(o.displayName, style: const TextStyle(fontSize: 12)))),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedOutcome = val);
                      _loadCallLogs(preserveScroll: true);
                    },
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${_callLogs.length} calls',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // List of Call Logs
        Expanded(
          child: _callLogs.isEmpty
              ? const Center(child: Text('No call logs recorded.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _callLogs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (ctx, idx) {
                    final call = _callLogs[idx];
                    final isPlaying = _currentlyPlayingCallId == call.id;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBackground : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                call.direction == CallDirection.inbound ? Icons.call_received_rounded : Icons.call_made_rounded,
                                size: 16,
                                color: call.direction == CallDirection.inbound ? Colors.green : Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  call.clientName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: call.outcome.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  call.outcome.displayName,
                                  style: TextStyle(color: call.outcome.color, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${call.durationSeconds ~/ 60}m ${call.durationSeconds % 60}s',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${call.phone} • Agent: ${call.employeeName} • ${call.timestamp.hour.toString().padLeft(2, '0')}:${call.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                          const SizedBox(height: 8),

                          // Waveform Audio simulation
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
                                  color: AppColors.primary,
                                  iconSize: 26,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => _toggleAudioPlay(call.id),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: isPlaying
                                      ? const LinearProgressIndicator(minHeight: 4)
                                      : Row(
                                          children: List.generate(
                                            24,
                                            (i) => Expanded(
                                              child: Container(
                                                height: (i % 4 + 1) * 4.0 + 4.0,
                                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                                decoration: BoxDecoration(
                                                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () => _showTranscriptDialog(call),
                                  icon: const Icon(Icons.psychology_alt_rounded, size: 14),
                                  label: const Text('AI Insights', style: TextStyle(fontSize: 11)),
                                  style: OutlinedButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAutodialerCampaignsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Active Campaign Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy_rounded, color: Colors.blue, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DLF & Golf Course Road Re-engagement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('AI Voice Agent: Priya (Luxury Interior Specialist)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                    child: const Text('RUNNING', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Campaign Progress: 38 / 60 contacted (63%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: LinearProgressIndicator(value: 0.63, minHeight: 6, valueColor: AlwaysStoppedAnimation(Colors.blue)),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Meetings Booked: 6 | Qualified: 14', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('AI Outbound Autodialer paused')),
                      );
                    },
                    icon: const Icon(Icons.pause_rounded, size: 16),
                    label: const Text('Pause Campaign'),
                    style: FilledButton.styleFrom(backgroundColor: Colors.amber.shade800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
