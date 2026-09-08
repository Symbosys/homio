import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../data/sales_repository.dart';
import '../domain/sales_domain_models.dart';
import '../domain/sales_enums.dart';
import '../widgets/crm_header.dart';
import '../widgets/lead_detail_360_modal.dart';

/// Screen 7: Meetings & Sales Calendar
/// Supports Site Surveys, Experience Center Consultations, Virtual 3D Demos,
/// Two-way Google Calendar sync simulation, and Client Self-Booking Links.
class SalesCalendarPage extends StatefulWidget {
  const SalesCalendarPage({super.key});

  @override
  State<SalesCalendarPage> createState() => _SalesCalendarPageState();
}

class _SalesCalendarPageState extends State<SalesCalendarPage> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isActionLoading = false;
  String _selectedScope = 'All Organization';
  String _viewMode = 'Agenda'; // Agenda, Day, Week
  MeetingPreferenceType? _selectedType;

  List<MeetingRecord> _meetings = [];

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMeetings({bool preserveScroll = true}) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isLoading = true);

    final results = await SalesRepository.instance.getMeetings(type: _selectedType);

    if (!mounted) return;
    setState(() {
      _meetings = results;
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

  Future<void> _toggleMeetingCompleted(MeetingRecord m) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isActionLoading = true);

    await SalesRepository.instance.toggleMeetingCompleted(m.id);
    await _loadMeetings(preserveScroll: false);
    if (!mounted) return;
    setState(() => _isActionLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Meeting for ${m.clientName} marked as ${m.isCompleted ? "Scheduled" : "Completed"}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openBookingModal() {
    final clientNameCtrl = TextEditingController();
    final locationCtrl = TextEditingController(text: 'HOMIO Experience Center, MG Road');
    final agendaCtrl = TextEditingController(text: 'Material selection & 3D walkthrough');
    MeetingPreferenceType type = MeetingPreferenceType.officeVisit;
    DateTime date = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              SizedBox(width: 10),
              Text('Schedule Client Consultation / Survey'),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: clientNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Client Name *',
                      hintText: 'e.g. Rohan Mehra',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<MeetingPreferenceType>(
                    initialValue: type,
                    decoration: const InputDecoration(
                      labelText: 'Meeting Type',
                      border: OutlineInputBorder(),
                    ),
                    items: MeetingPreferenceType.values.map((t) {
                      return DropdownMenuItem(value: t, child: Text(t.displayName));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDlgState(() {
                          type = val;
                          if (val == MeetingPreferenceType.siteVisit) {
                            locationCtrl.text = 'Client Residence Site Address';
                          } else if (val == MeetingPreferenceType.online) {
                            locationCtrl.text = 'Google Meet / Zoom';
                          } else {
                            locationCtrl.text = 'HOMIO Experience Center, MG Road';
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: locationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Location / Link',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: agendaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Agenda / Objectives',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                if (clientNameCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                final newM = MeetingRecord(
                  id: 'MTG-${DateTime.now().millisecondsSinceEpoch}',
                  leadId: 'HOM-LD-1024',
                  clientName: clientNameCtrl.text.trim(),
                  meetingType: type,
                  date: date,
                  startTime: 'Tomorrow, 04:00 PM',
                  endTime: '05:30 PM',
                  location: locationCtrl.text.trim(),
                  assignedRep: 'Ananya Verma',
                  agenda: agendaCtrl.text.trim(),
                  isCompleted: false,
                );
                await SalesRepository.instance.createMeeting(newM);
                _loadMeetings(preserveScroll: true);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Meeting scheduled for ${newM.clientName}!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Schedule Meeting'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareSelfBookingLink() {
    const link = 'https://meet.homio.in/book/ananya-verma-turnkey';
    Clipboard.setData(const ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Client self-booking calendar link copied to clipboard!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CrmHeader(
            title: 'Sales Meetings & Site Consultations',
            subtitle: 'Schedule laser surveys, experience center consultations, and virtual 3D walkthroughs.',
            scope: _selectedScope,
            onScopeChanged: (val) {
              setState(() => _selectedScope = val);
              _loadMeetings(preserveScroll: true);
            },
            onRefresh: () => _loadMeetings(preserveScroll: true),
            actionButtons: [
              OutlinedButton.icon(
                onPressed: _shareSelfBookingLink,
                icon: const Icon(Icons.share_rounded, size: 16),
                label: const Text('Share Booking Link'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : AppColors.darkTextPrimary,
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _openBookingModal,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Schedule Meeting'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),

          DashboardInlineLoadingIndicator(isLoading: _isActionLoading),

          // Main View Body
          Expanded(
            child: _isLoading && _meetings.isEmpty
                ? const DashboardSkeleton(itemCount: 6, height: 75)
                : RefreshIndicator(
                    onRefresh: () => _loadMeetings(preserveScroll: true),
                    child: SingleChildScrollView(
                      key: const PageStorageKey('sales_calendar_page_scroll'),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Control / View filter bar
                          _buildFilterBar(isDark),
                          const SizedBox(height: 16),

                          // Meetings List / Agenda
                          _buildMeetingsAgenda(isDark),
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

  Widget _buildFilterBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Agenda', label: Text('Agenda', style: TextStyle(fontSize: 12))),
                  ButtonSegment(value: 'Day', label: Text('Day', style: TextStyle(fontSize: 12))),
                  ButtonSegment(value: 'Week', label: Text('Week', style: TextStyle(fontSize: 12))),
                ],
                selected: {_viewMode},
                onSelectionChanged: (set) => setState(() => _viewMode = set.first),
                style: SegmentedButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<MeetingPreferenceType?>(
                    value: _selectedType,
                    isDense: true,
                    hint: const Text('All Meeting Types', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Types', style: TextStyle(fontSize: 12))),
                      ...MeetingPreferenceType.values.map(
                        (t) => DropdownMenuItem(value: t, child: Text(t.displayName, style: const TextStyle(fontSize: 12))),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedType = val);
                      _loadMeetings(preserveScroll: true);
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              const Text('Google Calendar Synced', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingsAgenda(bool isDark) {
    if (_meetings.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: const Column(
          children: [
            Icon(Icons.event_available_rounded, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text('No meetings scheduled for this period', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _meetings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final m = _meetings[idx];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox completed
              Checkbox(
                value: m.isCompleted,
                onChanged: (val) => _toggleMeetingCompleted(m),
                activeColor: AppColors.success,
              ),
              const SizedBox(width: 8),

              // Time badge
              Container(
                width: 120,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.startTime,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'to ${m.endTime}',
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Meeting Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          m.clientName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: m.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: m.meetingType.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            m.meetingType.displayName,
                            style: TextStyle(color: m.meetingType.color, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.agenda,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            m.location,
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.person_outline_rounded, size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Host: ${m.assignedRep}',
                          style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              IconButton(
                icon: const Icon(Icons.person_pin_rounded, size: 20, color: AppColors.primary),
                tooltip: 'Open Lead Profile',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (c) => LeadDetail360Modal(leadId: m.leadId),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
