import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/history_models.dart';

class CallMessageHistoryPage extends StatefulWidget {
  const CallMessageHistoryPage({super.key});

  @override
  State<CallMessageHistoryPage> createState() => _CallMessageHistoryPageState();
}

class _CallMessageHistoryPageState extends State<CallMessageHistoryPage> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  CallHistoryItem? _selectedCall;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  double _playbackProgress = 0.35;

  @override
  void initState() {
    super.initState();
    if (HistoryMockData.calls.isNotEmpty) {
      _selectedCall = HistoryMockData.calls.first;
    }
  }

  List<CallHistoryItem> get _filteredCalls {
    return HistoryMockData.calls.where((call) {
      final matchesSearch = call.contactName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          call.phoneNumber.contains(_searchQuery) ||
          call.projectTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          call.summary.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'AI Voice' && call.channel == CommunicationChannel.aiCall) return true;
      if (_selectedFilter == 'Phone' && call.channel == CommunicationChannel.phoneCall) return true;
      if (_selectedFilter == 'WhatsApp' && (call.channel == CommunicationChannel.whatsappVoice || call.channel == CommunicationChannel.whatsappVideo)) return true;
      if (_selectedFilter == 'SMS' && call.channel == CommunicationChannel.sms) return true;
      if (_selectedFilter == 'Missed' && call.outcome == CallOutcome.missed) return true;

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 950;

          return Column(
            children: [
              _buildHeader(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
              _buildKpiMetrics(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
              Expanded(
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left List
                          SizedBox(
                            width: 420,
                            child: _buildCallList(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
                          ),
                          VerticalDivider(width: 1, thickness: 1, color: borderColor),
                          // Right Detail
                          Expanded(
                            child: _selectedCall != null
                                ? _buildCallDetailPane(_selectedCall!, isDark, surfaceColor, borderColor, textPrimary, textSecondary)
                                : Center(
                                    child: Text(
                                      'Select a call to view transcript & analysis',
                                      style: TextStyle(color: textSecondary),
                                    ),
                                  ),
                          ),
                        ],
                      )
                    : _buildCallList(
                        isDark,
                        surfaceColor,
                        borderColor,
                        textPrimary,
                        textSecondary,
                        onTapMobile: (call) {
                          _showMobileDetailSheet(context, call, isDark, surfaceColor, borderColor, textPrimary, textSecondary);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.history_rounded, color: Color(0xFF3B82F6), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Call & Message History',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${HistoryMockData.calls.length} logs',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Unified audio timeline of AI voice agent calls, WhatsApp voice notes & CRM transcripts',
                      style: TextStyle(fontSize: 13, color: textSecondary),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exporting 6 call logs with AI transcripts to CSV...'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
                icon: const Icon(Icons.file_download_outlined, size: 18),
                label: const Text('Export Logs'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textPrimary,
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search & Filter Row
          Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 260,
                height: 38,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(fontSize: 13, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search client, phone, note...',
                    hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                    prefixIcon: Icon(Icons.search, size: 18, color: textSecondary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: ['All', 'AI Voice', 'Phone', 'WhatsApp', 'SMS', 'Missed'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : textSecondary,
                    ),
                    selectedColor: const Color(0xFF3B82F6),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetrics(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 700;
          return Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildKpiCard('Total Calls Handled', '18', '12 Today', Icons.call_rounded, const Color(0xFF3B82F6), isDark, surfaceColor, borderColor, textPrimary, textSecondary, isSmall),
              _buildKpiCard('AI Voice Agent Saved', '4h 12m', '91% Autonomous', Icons.smart_toy_rounded, const Color(0xFF8B5CF6), isDark, surfaceColor, borderColor, textPrimary, textSecondary, isSmall),
              _buildKpiCard('Positive Sentiment', '88%', '+4% this week', Icons.sentiment_satisfied_alt_rounded, const Color(0xFF10B981), isDark, surfaceColor, borderColor, textPrimary, textSecondary, isSmall),
              _buildKpiCard('Action Items Logged', '9', '2 Pending QA', Icons.task_alt_rounded, const Color(0xFFF59E0B), isDark, surfaceColor, borderColor, textPrimary, textSecondary, isSmall),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color accentColor,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isSmall,
  ) {
    return Container(
      width: isSmall ? 160 : 210,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallList(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary, {
    void Function(CallHistoryItem)? onTapMobile,
  }) {
    final calls = _filteredCalls;

    if (calls.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.call_missed_outgoing_rounded, size: 48, color: textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text('No call records found', style: TextStyle(color: textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: calls.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final call = calls[index];
        final isSelected = _selectedCall?.id == call.id;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedCall = call;
              _isPlaying = false;
            });
            if (onTapMobile != null) {
              onTapMobile(call);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.2 : 0.08)
                  : surfaceColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? const Color(0xFF3B82F6) : borderColor,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getChannelIcon(call.channel, call.direction, call.outcome),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            call.contactName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            call.projectTitle,
                            style: TextStyle(fontSize: 12, color: textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTimeAgo(call.timestamp),
                          style: TextStyle(fontSize: 11, color: textSecondary),
                        ),
                        const SizedBox(height: 4),
                        _buildOutcomeBadge(call.outcome, call.durationFormatted),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  call.summary,
                  style: TextStyle(
                    fontSize: 12,
                    color: textPrimary.withValues(alpha: 0.85),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _getSentimentChip(call.sentiment),
                    const Spacer(),
                    Icon(Icons.person_outline_rounded, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        call.agentName,
                        style: TextStyle(fontSize: 11, color: textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallDetailPane(
    CallHistoryItem call,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      color: surfaceColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Contact Info Bar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  child: Text(
                    call.contactName.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            call.contactName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          _getSentimentChip(call.sentiment),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${call.phoneNumber} • ${call.projectTitle}',
                        style: TextStyle(fontSize: 13, color: textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Conducted by: ${call.agentName}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildOutcomeBadge(call.outcome, call.durationFormatted),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: borderColor),
            const SizedBox(height: 16),

            // Audio Waveform & Player Widget
            if (call.durationSec > 0) ...[
              _buildAudioPlayer(isDark, borderColor, textPrimary, textSecondary),
              const SizedBox(height: 24),
            ],

            // AI Summary Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.15 : 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 18, color: Color(0xFF3B82F6)),
                      const SizedBox(width: 8),
                      Text(
                        'AI Call Synopsis & Executive Summary',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    call.summary,
                    style: TextStyle(fontSize: 13, color: textPrimary, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Key Takeaways & Action Items
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_outline_rounded, size: 16, color: Color(0xFF10B981)),
                            const SizedBox(width: 6),
                            Text(
                              'Key Takeaways',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...call.keyTakeaways.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(item, style: TextStyle(fontSize: 12, color: textSecondary, height: 1.3)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 6),
                            Text(
                              'Action Items Detected',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (call.actionItems.isEmpty)
                          Text('No pending action items from this call.', style: TextStyle(fontSize: 12, color: textSecondary))
                        else
                          ...call.actionItems.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.arrow_right_rounded, size: 18, color: Color(0xFFF59E0B)),
                                    Expanded(
                                      child: Text(item, style: TextStyle(fontSize: 12, color: textSecondary, height: 1.3)),
                                    ),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Transcript Section
            Row(
              children: [
                const Icon(Icons.subtitles_rounded, size: 18, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 8),
                Text(
                  'Full Audio Transcript (${call.transcript.length} turns)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (call.transcript.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('No transcript available for missed or automated SMS log', style: TextStyle(color: textSecondary, fontSize: 12)),
                ),
              )
            else
              ...call.transcript.map((line) => _buildTranscriptBubble(line, isDark, textPrimary, textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer(bool isDark, Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Play/Pause Button
              IconButton.filled(
                onPressed: () {
                  setState(() => _isPlaying = !_isPlaying);
                },
                icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              // Waveform Bars Simulation
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        activeTrackColor: const Color(0xFF3B82F6),
                        inactiveTrackColor: isDark ? Colors.white24 : Colors.grey.shade300,
                        thumbColor: const Color(0xFF3B82F6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                      ),
                      child: Slider(
                        value: _playbackProgress,
                        onChanged: (val) {
                          setState(() => _playbackProgress = val);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('01:15', style: TextStyle(fontSize: 11, color: textSecondary)),
                          Text(_selectedCall?.durationFormatted ?? '00:00', style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Playback Speed Selector
              PopupMenuButton<double>(
                initialValue: _playbackSpeed,
                onSelected: (speed) {
                  setState(() => _playbackSpeed = speed);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    '${_playbackSpeed}x',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 1.0, child: Text('1.0x Normal')),
                  const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                  const PopupMenuItem(value: 1.5, child: Text('1.5x Fast')),
                  const PopupMenuItem(value: 2.0, child: Text('2.0x Turbo')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptBubble(
    TranscriptLine line,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    final isCustomer = line.speaker != 'Homio AI' && line.speaker != 'System' && !line.speaker.contains('Ar.') && !line.speaker.contains('Priya') && !line.speaker.contains('Amit');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isCustomer
                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                : const Color(0xFF3B82F6).withValues(alpha: 0.15),
            child: Text(
              line.speaker.substring(0, 1),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isCustomer ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCustomer
                    ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.2) : const Color(0xFFECFDF5))
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        line.speaker,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isCustomer ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        ),
                      ),
                      Text(
                        line.time,
                        style: TextStyle(fontSize: 10, color: textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    line.text,
                    style: TextStyle(fontSize: 12, color: textPrimary, height: 1.3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMobileDetailSheet(
    BuildContext context,
    CallHistoryItem call,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: _buildCallDetailPane(call, isDark, surfaceColor, borderColor, textPrimary, textSecondary),
            );
          },
        );
      },
    );
  }

  Widget _getChannelIcon(CommunicationChannel channel, CallDirection direction, CallOutcome outcome) {
    IconData icon;
    Color color;

    switch (channel) {
      case CommunicationChannel.aiCall:
        icon = Icons.smart_toy_rounded;
        color = const Color(0xFF8B5CF6);
        break;
      case CommunicationChannel.phoneCall:
        icon = outcome == CallOutcome.missed
            ? Icons.phone_missed_rounded
            : (direction == CallDirection.inbound ? Icons.phone_callback_rounded : Icons.phone_forwarded_rounded);
        color = outcome == CallOutcome.missed ? const Color(0xFFEF4444) : const Color(0xFF3B82F6);
        break;
      case CommunicationChannel.whatsappVoice:
        icon = Icons.mic_rounded;
        color = const Color(0xFF10B981);
        break;
      case CommunicationChannel.whatsappVideo:
        icon = Icons.videocam_rounded;
        color = const Color(0xFF10B981);
        break;
      case CommunicationChannel.sms:
        icon = Icons.sms_rounded;
        color = const Color(0xFF6B7280);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  Widget _buildOutcomeBadge(CallOutcome outcome, String duration) {
    Color bg;
    Color fg;
    String text;

    switch (outcome) {
      case CallOutcome.answered:
        bg = const Color(0xFF10B981).withValues(alpha: 0.12);
        fg = const Color(0xFF10B981);
        text = duration;
        break;
      case CallOutcome.missed:
        bg = const Color(0xFFEF4444).withValues(alpha: 0.12);
        fg = const Color(0xFFEF4444);
        text = 'Missed';
        break;
      case CallOutcome.busy:
        bg = const Color(0xFFF59E0B).withValues(alpha: 0.12);
        fg = const Color(0xFFF59E0B);
        text = 'Busy';
        break;
      case CallOutcome.voicemail:
        bg = const Color(0xFF6B7280).withValues(alpha: 0.12);
        fg = const Color(0xFF6B7280);
        text = 'Voicemail';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  Widget _getSentimentChip(SentimentRating sentiment) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (sentiment) {
      case SentimentRating.positive:
        bg = const Color(0xFF10B981).withValues(alpha: 0.12);
        fg = const Color(0xFF10B981);
        label = 'Positive';
        icon = Icons.sentiment_satisfied_rounded;
        break;
      case SentimentRating.neutral:
        bg = const Color(0xFF3B82F6).withValues(alpha: 0.12);
        fg = const Color(0xFF3B82F6);
        label = 'Neutral';
        icon = Icons.sentiment_neutral_rounded;
        break;
      case SentimentRating.frustrated:
        bg = const Color(0xFFEF4444).withValues(alpha: 0.12);
        fg = const Color(0xFFEF4444);
        label = 'Frustrated';
        icon = Icons.sentiment_dissatisfied_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
