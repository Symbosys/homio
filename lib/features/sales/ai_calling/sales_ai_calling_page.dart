import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sales_models.dart';
import '../models/sales_mock_data.dart';
import '../widgets/sales_header.dart';
import '../widgets/sales_metric_card.dart';

class SalesAiCallingPage extends StatefulWidget {
  const SalesAiCallingPage({super.key});

  @override
  State<SalesAiCallingPage> createState() => _SalesAiCallingPageState();
}

class _SalesAiCallingPageState extends State<SalesAiCallingPage> {
  SalesDateFilter _selectedDateFilter = SalesDateFilter.thisMonth;
  late List<AiCallRecordItem> _callLogs;
  String? _currentlyPlayingCallId;

  @override
  void initState() {
    super.initState();
    _callLogs = List<AiCallRecordItem>.from(SalesMockData.aiCalls);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            SalesHeader(
              title: 'AI Autodialer & Voice Calling Hub',
              subtitle: 'Outbound pre-qualification, speech-to-text transcripts, sentiment tagging & barge-in',
              icon: Icons.phone_in_talk_outlined,
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
                      Icon(Icons.wifi_calling_3_rounded, size: 12, color: Color(0xFF10B981)),
                      SizedBox(width: 5),
                      Text(
                        'SIP Active • AI Speech',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.record_voice_over_outlined, size: 14),
                  label: const Text('Persona', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () => _showPersonaModal(context),
                ),
              ],
              primaryAction: ElevatedButton.icon(
                icon: const Icon(Icons.dialer_sip_rounded, size: 14),
                label: const Text('Start Calling Batch', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                onPressed: () => _showStartBatchModal(context),
              ),
            ),
            const SizedBox(height: 14),

            // Metrics
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isMedium = constraints.maxWidth > 600;
                final double width = isWide
                    ? (constraints.maxWidth - 36) / 4
                    : isMedium
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth;

                return Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      width: width,
                      child: const SalesMetricCard(
                        metric: SalesKpiMetric(
                          id: 'ai_calls_total',
                          title: 'Total AI Autodial Calls',
                          value: '1,842 Calls',
                          changeText: '+240 today',
                          isPositive: true,
                          icon: Icons.phone_forwarded_rounded,
                          color: Color(0xFF2563EB),
                          subtitle: 'Avg pickup: 7.2s',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const SalesMetricCard(
                        metric: SalesKpiMetric(
                          id: 'ai_connect_rate',
                          title: 'Human Connect Rate',
                          value: '68.4%',
                          changeText: '+5.2% vs avg',
                          isPositive: true,
                          icon: Icons.person_search_rounded,
                          color: Color(0xFF10B981),
                          subtitle: '1,260 connected',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const SalesMetricCard(
                        metric: SalesKpiMetric(
                          id: 'ai_hot_qualified',
                          title: 'Hot Leads Auto-Qualified',
                          value: '182 Leads',
                          changeText: 'Score > 80',
                          isPositive: true,
                          icon: Icons.local_fire_department_rounded,
                          color: Color(0xFFEF4444),
                          subtitle: 'Routed to calendar',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: const SalesMetricCard(
                        metric: SalesKpiMetric(
                          id: 'ai_avg_duration',
                          title: 'Avg Qualification Time',
                          value: '3m 42s',
                          changeText: '₹1.80/min',
                          isPositive: true,
                          icon: Icons.timer_outlined,
                          color: Color(0xFF8B5CF6),
                          subtitle: 'EN, HI, KN voice',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Live Dialer Console
            _buildLiveDialerCard(context, isDark),
            const SizedBox(height: 16),

            // Call Recordings Table
            _buildCallRecordingsTable(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveDialerCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Live Outbound Qualification Stream (Agent: Priya)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Elapsed: 03:42', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
              ),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildDialerLeft(context, isDark)),
                    const SizedBox(width: 14),
                    Expanded(flex: 7, child: _buildTranscriptRight(context, isDark)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildDialerLeft(context, isDark),
                    const SizedBox(height: 12),
                    _buildTranscriptRight(context, isDark),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDialerLeft(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF2563EB),
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vikram Malhotra', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  Text(
                    '+91 98112 44921 • DLF Magnolias Penthouse',
                    style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Qualification Checklist:',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          ),
          const SizedBox(height: 6),
          _buildCheckItem('Handover verified (Sep 2026)', true),
          _buildCheckItem('4BHK Penthouse Full Fit-out', true),
          _buildCheckItem('Budget Range: ₹45L - ₹55L confirmed', true),
          _buildCheckItem('Laser Survey Confirmed for Today 2:30 PM', true),
          const Divider(height: 18),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.headset_mic_rounded, size: 12),
                  label: const Text('Barge-In', style: TextStyle(fontSize: 10.5)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Agent audio patched into live call. AI muted.')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.call_end, size: 12),
                label: const Text('End Call', style: TextStyle(fontSize: 10.5)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Call completed. Slot booked.')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool checked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(checked ? Icons.check_circle : Icons.radio_button_unchecked, size: 12, color: const Color(0xFF10B981)),
          const SizedBox(width: 6),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 10.5))),
        ],
      ),
    );
  }

  Widget _buildTranscriptRight(BuildContext context, bool isDark) {
    final transcriptItems = [
      {'speaker': 'Homio AI (Priya)', 'time': '00:04', 'text': "Hello Vikram! Calling from Homio regarding your DLF Magnolias inquiry."},
      {'speaker': 'Vikram Malhotra', 'time': '00:12', 'text': 'Yes, Vikram here. Complete architectural turnkey, around 4,200 sqft.'},
      {'speaker': 'Homio AI (Priya)', 'time': '00:26', 'text': 'Turnkey luxury spec budget is 45 to 55 Lakhs. Does that align?'},
      {'speaker': 'Vikram Malhotra', 'time': '00:35', 'text': 'Yes, within budget. When can someone visit the site?'},
      {'speaker': 'Homio AI (Priya)', 'time': '00:46', 'text': 'I can book Senior Design Lead Aarav for a survey today at 2:30 PM.'},
      {'speaker': 'Vikram Malhotra', 'time': '01:02', 'text': 'Today 2:30 PM works great. Please confirm on WhatsApp.'},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Live Speech-to-Text Transcription', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text('Positive (92%)', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: ListView.builder(
              itemCount: transcriptItems.length,
              itemBuilder: (ctx, idx) {
                final item = transcriptItems[idx];
                final isBot = item['speaker']!.startsWith('Homio AI');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: isBot ? const Color(0xFF2563EB).withValues(alpha: 0.1) : const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          item['time']!,
                          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: isBot ? const Color(0xFF2563EB) : const Color(0xFF059669)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                            children: [
                              TextSpan(
                                text: '${item['speaker']}: ',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(text: item['text']!),
                            ],
                          ),
                        ),
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

  Widget _buildCallRecordingsTable(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Telephony Qualification Logs & Call Recordings', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 1),
                  Text(
                    'Recorded MP3 audios, AI detected intents and auto-scheduled meeting slots',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.file_download_outlined, size: 13),
                label: const Text('Export CSV', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting telephony logs...')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth = math.max(constraints.maxWidth, 840.0);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.8),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(0.9),
                      3: FlexColumnWidth(1.2),
                      4: FlexColumnWidth(1.5),
                      5: FlexColumnWidth(1.0),
                      6: FlexColumnWidth(0.9),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        children: const [
                          _Th('Contact / Client'),
                          _Th('Date & Time'),
                          _Th('Duration'),
                          _Th('Qualification'),
                          _Th('Sentiment'),
                          _Th('Audio'),
                          _Th('Log'),
                        ],
                      ),
                      ..._callLogs.map((call) {
                        final isPlaying = _currentlyPlayingCallId == call.callId;
                        return TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark ? AppColors.darkBorder : AppColors.lightSurfaceSubtle,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(call.clientName, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                                  Text(call.phone, style: TextStyle(fontSize: 9.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                ],
                              ),
                            ),
                            _Td(call.callDate),
                            _Td(call.duration),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: call.statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  call.qualificationStatus,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: call.statusColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                              child: Text(
                                call.sentiment,
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: call.sentimentColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                              child: ElevatedButton.icon(
                                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 12),
                                label: Text(isPlaying ? 'Playing' : 'Listen', style: const TextStyle(fontSize: 9.5)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPlaying ? const Color(0xFF10B981) : const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _currentlyPlayingCallId = isPlaying ? null : call.callId;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                              child: IconButton(
                                icon: const Icon(Icons.description_outlined, size: 14),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Transcript',
                                onPressed: () => _showTranscriptModal(context, call),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showStartBatchModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Start Outbound Calling Batch', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: 'New Meta Inquiries (48 Leads)',
                style: const TextStyle(fontSize: 11.5),
                decoration: const InputDecoration(labelText: 'Target Lead Segment', border: OutlineInputBorder(), isDense: true),
                items: [
                  'New Meta Inquiries (48 Leads)',
                  'Web Enquiries (24 Leads)',
                  'Reactivation Pool (120 Leads)',
                ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: 'Homio Priya (Indian English / Hindi)',
                style: const TextStyle(fontSize: 11.5),
                decoration: const InputDecoration(labelText: 'AI Voice Agent Persona', border: OutlineInputBorder(), isDense: true),
                items: [
                  'Homio Priya (Indian English / Hindi)',
                  'Homio Rohan (Senior Consultant)',
                ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (_) {},
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
                const SnackBar(content: Text('Outbound calling batch triggered.')),
              );
            },
            child: const Text('Launch Batch', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }

  void _showPersonaModal(BuildContext context) {
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
        title: const Text('Configure AI Voice Persona', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: 'Homio Priya - Luxury Consultant',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Persona Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: 'Warm, consultative, knowledgeable about turnkey carpentry and Italian marble.',
                maxLines: 2,
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: modalInputDeco('Tone & Style Instructions'),
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
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI voice persona updated.')));
            },
            child: const Text('Save', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }

  void _showTranscriptModal(BuildContext context, AiCallRecordItem log) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Text('Call Transcript: ${log.clientName}', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 480,
          height: 280,
          child: SingleChildScrollView(
            child: Text(
              log.fullTranscript.isNotEmpty ? log.fullTranscript : 'Transcript processing.',
              style: TextStyle(fontSize: 11, height: 1.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  final String text;
  const _Th(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}

class _Td extends StatelessWidget {
  final String text;
  const _Td(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}
