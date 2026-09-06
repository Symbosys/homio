import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/sales_models.dart';
import '../models/sales_mock_data.dart';
import '../widgets/sales_header.dart';

class SalesCalendarPage extends StatefulWidget {
  const SalesCalendarPage({super.key});

  @override
  State<SalesCalendarPage> createState() => _SalesCalendarPageState();
}

class _SalesCalendarPageState extends State<SalesCalendarPage> {
  SalesDateFilter _selectedDateFilter = SalesDateFilter.thisWeek;
  String _currentView = 'Week';
  late List<MeetingScheduleSlot> _meetings;
  MeetingScheduleSlot? _selectedMeeting;

  final List<String> _viewModes = ['Month', 'Week', 'Day', 'List'];

  @override
  void initState() {
    super.initState();
    _meetings = List<MeetingScheduleSlot>.from(SalesMockData.meetingSlots);
    if (_meetings.isNotEmpty) {
      _selectedMeeting = _meetings.first;
    }
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
              title: 'Sales Calendar & Site Appointments',
              subtitle: 'Appointment coordination for laser surveys, studio consultations and virtual walkthroughs',
              icon: Icons.calendar_month_outlined,
              activeFilter: _selectedDateFilter,
              onFilterChanged: (filter) => setState(() => _selectedDateFilter = filter),
              additionalFilters: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorderStrong),
                  ),
                  child: Row(
                    children: _viewModes.map((m) {
                      final isSel = _currentView == m;
                      return InkWell(
                        onTap: () => setState(() => _currentView = m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF2563EB) : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            m,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: isSel ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.sync_rounded, size: 14),
                  label: const Text('Google Sync', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Two-way Google Calendar synchronization active.')),
                    );
                  },
                ),
              ],
              primaryAction: ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Book Slot', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                onPressed: () => _showBookSlotModal(context),
              ),
            ),
            const SizedBox(height: 12),

            // SLA Reminder Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_outlined, size: 16, color: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Multi-Touch SLAs: 24h WhatsApp link + morning-of GPS pin + 1h SMS alert reduce no-shows by 84%.',
                      style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('No-Show: 4.8%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Main Content: Calendar Grid + Dossier
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 950;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildCalendarView(context, isDark)),
                      const SizedBox(width: 14),
                      Expanded(flex: 5, child: _buildMeetingDetailPanel(context, isDark)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildCalendarView(context, isDark),
                      const SizedBox(height: 14),
                      _buildMeetingDetailPanel(context, isDark),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarView(BuildContext context, bool isDark) {
    final days = ['Mon, 8 Sep', 'Tue, 9 Sep', 'Wed, 10 Sep', 'Thu, 11 Sep', 'Fri, 12 Sep', 'Sat, 13 Sep', 'Sun, 14 Sep'];

    return Container(
      padding: const EdgeInsets.all(14),
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
              Text(
                'September 2026 (Week 37)',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: days.map((day) {
              final isToday = day.startsWith('Fri');
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isToday ? const Color(0xFF2563EB).withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                      color: isToday ? const Color(0xFF2563EB) : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const Divider(height: 16),

          ..._meetings.map((meeting) {
            final isSelected = _selectedMeeting?.id == meeting.id;

            return InkWell(
              onTap: () => setState(() => _selectedMeeting = meeting),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? meeting.formatColor.withValues(alpha: 0.12)
                      : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? meeting.formatColor : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3.5,
                      height: 30,
                      decoration: BoxDecoration(color: meeting.formatColor, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                meeting.clientName,
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: meeting.formatColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  meeting.meetingFormat,
                                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: meeting.formatColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${meeting.timeRange} • ${meeting.locationOrLink}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMeetingDetailPanel(BuildContext context, bool isDark) {
    final meeting = _selectedMeeting;
    if (meeting == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: Text('Select an appointment', style: TextStyle(fontSize: 11))),
      );
    }

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
              Text(
                'Appointment Dossier',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: meeting.statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(meeting.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: meeting.statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(meeting.clientName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text('Format: ${meeting.meetingFormat}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          _buildDetailRow('Time', '${meeting.date} (${meeting.timeRange})', isDark),
          _buildDetailRow('Venue', meeting.locationOrLink, isDark),
          _buildDetailRow('Closer', meeting.assignedDesigner, isDark),
          const Divider(height: 16),

          const Text('Automated SLA Follow-up Engine', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _buildReminderStep('T-24h: WhatsApp Slot Link', 'Confirmed by Client', meeting.reminder24hSent),
          _buildReminderStep('T-4h: Maps GPS Pin & Card', 'Dispatched to Phone', meeting.reminderMorningSent),
          _buildReminderStep('T-1h: SMS Gate-pass Arrival', 'Scheduled 1h prior', meeting.reminder1hSent),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, size: 12),
                  label: const Text('Mark Done', style: TextStyle(fontSize: 10.5)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Appointment marked completed.')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.edit_calendar_outlined, size: 12),
                label: const Text('Reschedule', style: TextStyle(fontSize: 10.5)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontSize: 10.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderStep(String title, String subtitle, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(isDone ? Icons.check_circle : Icons.schedule, size: 13, color: isDone ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookSlotModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

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

        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          title: const Text('Book Appointment Slot', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  decoration: modalInputDeco('Client Name *'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: 'Physical Site Laser Survey',
                  style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                  decoration: modalInputDeco('Appointment Type'),
                  items: [
                    'Physical Site Laser Survey',
                    'Experience Center Consultation',
                    'Virtual 3D Walkthrough (Google Meet)',
                  ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (_) {},
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  decoration: modalInputDeco('Site Address / Maps URL'),
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
                const SnackBar(content: Text('Appointment booked & invite dispatched.')),
              );
            },
            child: const Text('Confirm', style: TextStyle(fontSize: 11.5)),
          ),
        ],
      );
    },
  );
}
}
