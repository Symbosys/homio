import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/meeting_models.dart';

class MeetingSchedulingPage extends StatefulWidget {
  const MeetingSchedulingPage({super.key});

  @override
  State<MeetingSchedulingPage> createState() => _MeetingSchedulingPageState();
}

class _MeetingSchedulingPageState extends State<MeetingSchedulingPage> {
  String _selectedTab = 'Upcoming';
  String _selectedTypeFilter = 'All Types';
  String _searchQuery = '';

  List<ScheduledMeeting> get _filteredMeetings {
    return MeetingMockData.meetings.where((m) {
      final matchesSearch = m.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.clientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.projectTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.locationOrLink.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedTab == 'Upcoming' && m.status != MeetingStatus.upcoming) return false;
      if (_selectedTab == 'Completed' && m.status != MeetingStatus.completed) return false;

      if (_selectedTypeFilter != 'All Types' && m.typeLabel != _selectedTypeFilter) {
        return false;
      }

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
      body: Column(
        children: [
          _buildHeader(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
          _buildKpiMetrics(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
          _buildTabsAndFilters(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
          Expanded(
            child: _filteredMeetings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_rounded, size: 48, color: textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text('No meetings scheduled in this view', style: TextStyle(color: textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = _filteredMeetings[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 860),
                          child: _buildMeetingCard(meeting, isDark, surfaceColor, borderColor, textPrimary, textSecondary),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF6366F1), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Meeting & Site Visit Scheduling',
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
                        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${MeetingMockData.meetings.where((m) => m.status == MeetingStatus.upcoming).length} upcoming',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'On-site inspections, 3D video reviews, and showroom material walkthroughs with WhatsApp sync',
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showBookMeetingModal(context, isDark, surfaceColor, borderColor, textPrimary, textSecondary),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Schedule Meeting'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              _buildKpiCard('Upcoming Today', '3', '1 Site, 2 Video', Icons.today_rounded, const Color(0xFF6366F1), isDark, surfaceColor, borderColor, textPrimary, textSecondary, isSmall),
              _buildKpiCard('Completed This Month', '18', '94% On-time', Icons.task_alt_rounded, const Color(0xFF10B981), isDark, surfaceColor, borderColor, textPrimary, textSecondary, isSmall),
              _buildKpiCard('Showroom Appointments', '5', 'Batch Selections', Icons.storefront_rounded, const Color(0xFFF59E0B), isDark, surfaceColor, borderColor, textPrimary, textSecondary, isSmall),
              _buildKpiCard('WhatsApp Reminders', '100%', '0 No-shows', Icons.check_circle_outline_rounded, const Color(0xFF3B82F6), isDark, surfaceColor, borderColor, textPrimary, textSecondary, isSmall),
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

  Widget _buildTabsAndFilters(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Tabs: Upcoming vs Completed vs All
              Row(
                children: ['Upcoming', 'Completed', 'All'].map((tab) {
                  final isSelected = _selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedTab = tab),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : textSecondary,
                      ),
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(width: 14),
              SizedBox(
                width: 220,
                height: 36,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(fontSize: 13, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search client, venue...',
                    hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                    prefixIcon: Icon(Icons.search, size: 18, color: textSecondary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTypeFilter,
                    dropdownColor: surfaceColor,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                    items: const [
                      DropdownMenuItem(value: 'All Types', child: Text('All Types')),
                      DropdownMenuItem(value: 'Site Inspection', child: Text('Site Inspection')),
                      DropdownMenuItem(value: '3D Design Review (Video)', child: Text('3D Design Review')),
                      DropdownMenuItem(value: 'Showroom / Material Selection', child: Text('Showroom Visit')),
                      DropdownMenuItem(value: 'Milestone Signoff', child: Text('Milestone Signoff')),
                      DropdownMenuItem(value: 'Snag Walkthrough & Handover', child: Text('Snag Walkthrough')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedTypeFilter = val);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMeetingCard(
    ScheduledMeeting meeting,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Type Pill & Date Time Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                _buildTypeBadge(meeting.type),
                const SizedBox(width: 10),
                Icon(Icons.access_time_rounded, size: 15, color: textSecondary),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(meeting.dateTime, meeting.durationMinutes),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                ),
                const Spacer(),
                _buildStatusBadge(meeting.status),
              ],
            ),
          ),

          // Main Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meeting.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(meeting.isOnline ? Icons.videocam_rounded : Icons.place_rounded, size: 15, color: const Color(0xFF6366F1)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        meeting.locationOrLink,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: meeting.isOnline ? const Color(0xFF6366F1) : textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                      child: Text(
                        meeting.clientName.substring(0, 1),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${meeting.clientName} (${meeting.clientPhone})',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    const SizedBox(width: 10),
                    Text('• ${meeting.projectTitle}', style: TextStyle(fontSize: 12, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                // Agenda box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notes_rounded, size: 14, color: textSecondary),
                          const SizedBox(width: 6),
                          Text('Meeting Agenda', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(meeting.agenda, style: TextStyle(fontSize: 12, color: textPrimary, height: 1.3)),
                    ],
                  ),
                ),

                // Outcome notes (if completed)
                if (meeting.outcomeNotes != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                            SizedBox(width: 6),
                            Text('Meeting Minutes & Outcomes', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(meeting.outcomeNotes!, style: TextStyle(fontSize: 12, color: textPrimary, height: 1.3)),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                // Attendees Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Assigned Team:', style: TextStyle(fontSize: 11, color: textSecondary)),
                    ...meeting.assignedStaff.map((staff) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.badge_outlined, size: 12, color: textSecondary),
                            const SizedBox(width: 4),
                            Text(staff, style: TextStyle(fontSize: 11, color: textPrimary)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Action Toolbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // WhatsApp Invite / Reminder Generator
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      meeting.whatsappReminderSent = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('WhatsApp reminder & calendar invite delivered to ${meeting.clientName}!'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded, size: 14, color: Color(0xFF10B981)),
                  label: Text(
                    meeting.whatsappReminderSent ? 'Resend WA Invite' : 'Send WA Invite',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF10B981)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF10B981)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(width: 10),
                // Log Outcomes
                TextButton.icon(
                  onPressed: () => _showLogOutcomeModal(meeting, isDark, surfaceColor, borderColor, textPrimary, textSecondary),
                  icon: const Icon(Icons.edit_note_rounded, size: 16),
                  label: const Text('Log Notes & Tasks', style: TextStyle(fontSize: 12)),
                ),
                const Spacer(),
                if (meeting.status == MeetingStatus.upcoming)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        meeting.status = MeetingStatus.completed;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Marked meeting as completed!'),
                          backgroundColor: Color(0xFF3B82F6),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Mark Done', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(MeetingType type) {
    Color color;
    IconData icon;
    String label;

    switch (type) {
      case MeetingType.siteInspection:
        color = const Color(0xFF3B82F6);
        icon = Icons.engineering_rounded;
        label = 'Site Inspection';
        break;
      case MeetingType.designReviewVideo:
        color = const Color(0xFF8B5CF6);
        icon = Icons.videocam_rounded;
        label = '3D Design Review (Video)';
        break;
      case MeetingType.showroomVisit:
        color = const Color(0xFFF59E0B);
        icon = Icons.storefront_rounded;
        label = 'Showroom Selection';
        break;
      case MeetingType.milestoneSignoff:
        color = const Color(0xFF10B981);
        icon = Icons.verified_rounded;
        label = 'Milestone Signoff';
        break;
      case MeetingType.snagWalkthrough:
        color = const Color(0xFFEC4899);
        icon = Icons.checklist_rounded;
        label = 'Snag Walkthrough';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(MeetingStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case MeetingStatus.upcoming:
        bg = const Color(0xFF6366F1).withValues(alpha: 0.12);
        fg = const Color(0xFF6366F1);
        label = 'Upcoming';
        break;
      case MeetingStatus.completed:
        bg = const Color(0xFF10B981).withValues(alpha: 0.12);
        fg = const Color(0xFF10B981);
        label = 'Completed';
        break;
      case MeetingStatus.cancelled:
        bg = const Color(0xFFEF4444).withValues(alpha: 0.12);
        fg = const Color(0xFFEF4444);
        label = 'Cancelled';
        break;
      case MeetingStatus.rescheduled:
        bg = const Color(0xFFF59E0B).withValues(alpha: 0.12);
        fg = const Color(0xFFF59E0B);
        label = 'Rescheduled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  void _showBookMeetingModal(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    final titleCtrl = TextEditingController();
    final venueCtrl = TextEditingController(text: 'Plot 42, Palm Meadows, Whitefield');
    final agendaCtrl = TextEditingController();
    MeetingType type = MeetingType.siteInspection;
    DateTime date = DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Schedule Meeting / Site Walkthrough',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'Meeting Title',
                        hintText: 'e.g. Electrical Layout & Switchboard Review',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<MeetingType>(
                      initialValue: type,
                      decoration: InputDecoration(
                        labelText: 'Meeting Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: const [
                        DropdownMenuItem(value: MeetingType.siteInspection, child: Text('Site Inspection')),
                        DropdownMenuItem(value: MeetingType.designReviewVideo, child: Text('3D Design Review (Video)')),
                        DropdownMenuItem(value: MeetingType.showroomVisit, child: Text('Showroom / Material Selection')),
                        DropdownMenuItem(value: MeetingType.milestoneSignoff, child: Text('Milestone Signoff')),
                        DropdownMenuItem(value: MeetingType.snagWalkthrough, child: Text('Snag Walkthrough')),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => type = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: venueCtrl,
                      decoration: InputDecoration(
                        labelText: 'Site Address or Google Meet Link',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: agendaCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Key Agenda / Items to Check',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty) return;
                          setState(() {
                            MeetingMockData.meetings.insert(
                              0,
                              ScheduledMeeting(
                                id: 'mtg_${DateTime.now().millisecondsSinceEpoch}',
                                title: titleCtrl.text.trim(),
                                projectTitle: 'Villa #42 - Palm Meadows',
                                clientName: 'Vikram Malhotra',
                                clientPhone: '+91 98201 44521',
                                type: type,
                                dateTime: date,
                                durationMinutes: 60,
                                locationOrLink: venueCtrl.text.trim(),
                                isOnline: type == MeetingType.designReviewVideo,
                                status: MeetingStatus.upcoming,
                                assignedStaff: ['Ar. Rohan Sen', 'Kishore Kumar'],
                                agenda: agendaCtrl.text.trim(),
                                actionItems: [],
                                whatsappReminderSent: true,
                              ),
                            );
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Meeting scheduled & WhatsApp calendar invite dispatched!'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Confirm Schedule'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLogOutcomeModal(
    ScheduledMeeting meeting,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    final notesCtrl = TextEditingController(text: meeting.outcomeNotes ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Notes for ${meeting.title}', style: const TextStyle(fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: notesCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Discussion Notes & Agreed Tasks',
                  hintText: 'e.g. Client approved track light placements. 2 additional sockets in living room confirmed.',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  meeting.outcomeNotes = notesCtrl.text.trim();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meeting notes recorded!'),
                    backgroundColor: Color(0xFF3B82F6),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Notes'),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(DateTime dt, int durationMin) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = _getMonthName(dt.month);
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';

    return '$day $month • $hour:$min $ampm ($durationMin mins)';
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
