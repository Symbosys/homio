import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/sales_enums.dart';
import '../domain/sales_domain_models.dart';
import '../data/sales_repository.dart';

/// Full 360° CRM Lead Inspection Drawer / Modal
class LeadDetail360Modal extends StatefulWidget {
  final LeadItem? lead;
  final String? leadId;
  final dynamic onLeadUpdated;

  const LeadDetail360Modal({
    super.key,
    this.lead,
    this.leadId,
    this.onLeadUpdated,
  });

  static Future<void> show(BuildContext context, {LeadItem? lead, String? leadId, dynamic onLeadUpdated}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LeadDetail360Modal(lead: lead, leadId: leadId, onLeadUpdated: onLeadUpdated),
    );
  }

  @override
  State<LeadDetail360Modal> createState() => _LeadDetail360ModalState();
}

class _LeadDetail360ModalState extends State<LeadDetail360Modal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LeadItem _currentLead;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentLead = widget.lead ??
        (widget.leadId != null ? SalesRepository.instance.getLeadById(widget.leadId!) : null) ??
        SalesRepository.instance.leads.first;
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateStage(CrmStage newStage) async {
    try {
      final updated = await SalesRepository.instance.updateLeadStage(
        _currentLead.id,
        newStage,
        reason: 'Updated in Lead 360° Drawer',
      );
      setState(() => _currentLead = updated);
      _triggerUpdate(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lead stage updated to ${newStage.label}'),
            backgroundColor: newStage.color,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update stage: $e')),
        );
      }
    }
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final newActivity = LeadActivityItem(
      id: 'ACT-${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      employeeName: 'Current Consultant',
      action: 'Note Added',
      details: text,
      source: 'Manual',
      icon: Icons.note_alt_outlined,
      iconColor: Colors.amber,
    );

    setState(() {
      _currentLead = _currentLead.copyWith(
        activities: [newActivity, ..._currentLead.activities],
      );
      _noteController.clear();
    });

    _triggerUpdate(_currentLead);
  }

  void _triggerUpdate(LeadItem item) {
    if (widget.onLeadUpdated == null) return;
    if (widget.onLeadUpdated is ValueChanged<LeadItem>) {
      (widget.onLeadUpdated as ValueChanged<LeadItem>)(item);
    } else if (widget.onLeadUpdated is VoidCallback) {
      (widget.onLeadUpdated as VoidCallback)();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.of(context).size.height * 0.88;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 1. Profile Header
          _buildProfileHeader(isDark),

          // 2. Stage Switcher Strip
          _buildStageSwitcher(isDark),

          // 3. Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Timeline & Audit'),
                Tab(text: 'Calls'),
                Tab(text: 'WhatsApp'),
                Tab(text: 'Meetings'),
                Tab(text: 'Activity Composer'),
              ],
            ),
          ),

          // 4. Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(isDark),
                _buildTimelineTab(isDark),
                _buildCallsTab(isDark),
                _buildWhatsAppTab(isDark),
                _buildMeetingsTab(isDark),
                _buildActivityComposerTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: AppRadius.md,
            ),
            child: const Icon(Icons.person_rounded, size: 26, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _currentLead.clientName,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _currentLead.stage.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _currentLead.stage.label,
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _currentLead.stage.color),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Score: ${_currentLead.leadScore.toInt()}',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${_currentLead.phone}  •  ${_currentLead.email}  •  ID: ${_currentLead.id}',
                  style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 6,
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dialing ${_currentLead.phone}...')),
                  );
                },
                icon: const Icon(Icons.phone_outlined, size: 16),
                tooltip: 'Direct Call',
              ),
              IconButton.filledTonal(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening WhatsApp for ${_currentLead.clientName}...')),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                tooltip: 'WhatsApp Client',
              ),
              IconButton.filledTonal(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 16),
                tooltip: 'Close Drawer',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageSwitcher(bool isDark) {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: CrmStage.values.map((stage) {
          final isSelected = _currentLead.stage == stage;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(stage.label),
              selected: isSelected,
              onSelected: (_) => _updateStage(stage),
              selectedColor: stage.color,
              backgroundColor: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
              labelStyle: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildInfoCard(
          title: 'Project & Scope Details',
          isDark: isDark,
          children: [
            _infoRow('Property Type', _currentLead.projectType),
            _infoRow('Scope of Work', _currentLead.workType.label),
            _infoRow('Carpet Area', '${_currentLead.areaSqFt.toInt()} sq.ft'),
            _infoRow('Site Address', _currentLead.address),
            _infoRow('City & Pincode', '${_currentLead.city} — ${_currentLead.pincode}'),
          ],
        ),
        const SizedBox(height: 14),
        _buildInfoCard(
          title: 'Commercial & Qualification',
          isDark: isDark,
          children: [
            _infoRow('Estimated Budget', '₹${_currentLead.budgetAmount.toStringAsFixed(1)} Lakhs (${_currentLead.budgetConfidence})'),
            _infoRow('Auto-Qualification', _currentLead.isQualified ? 'Qualified (Serviceable PIN & Budget)' : 'Disqualified'),
            if (_currentLead.qualificationReason != null)
              _infoRow('Qualification Reason', _currentLead.qualificationReason!),
            if (_currentLead.primaryObjection != null)
              _infoRow('Primary Objection', _currentLead.primaryObjection!),
            _infoRow('Lead Source', _currentLead.source.label),
            _infoRow('Assigned Consultant', _currentLead.assignedTo),
            _infoRow('Meeting Preference', _currentLead.meetingPreference.label),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineTab(bool isDark) {
    if (_currentLead.activities.isEmpty) {
      return Center(
        child: Text('No timeline activities yet', style: GoogleFonts.inter(fontSize: 12)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _currentLead.activities.length,
      separatorBuilder: (_, _) => Divider(height: 18, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      itemBuilder: (context, index) {
        final act = _currentLead.activities[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: act.iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(act.icon, size: 16, color: act.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(act.action, style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700)),
                      Text(
                        '${act.timestamp.day}/${act.timestamp.month} ${act.timestamp.hour}:${act.timestamp.minute.toString().padLeft(2, '0')}',
                        style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(act.details, style: GoogleFonts.inter(fontSize: 11.5)),
                  const SizedBox(height: 4),
                  Text(
                    'Logged by: ${act.employeeName}  •  Via ${act.source}',
                    style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCallsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.sm,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Outbound Discovery Call', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                  Text('Duration: 6m 52s', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton.filled(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Playing simulated audio recording...')),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.45,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('03:05 / 06:52', style: GoogleFonts.inter(fontSize: 10.5)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'AI Summary: Client received key possession of DLF Camellias 3850 sq.ft unit. Confirmed ₹65L budget. Eager for immediate laser measurement site visit.',
                style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsAppTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _chatBubble('agent', 'Hello Mr. Sharma, congratulations on receiving possession of Camellias Apt 1402! Here is our luxury interior portfolio.', 'Yesterday 10:15 AM'),
        _chatBubble('client', 'Thank you Ananya! Yes, we would like to book a site measurement visit with your senior architect.', 'Yesterday 10:45 AM'),
        _chatBubble('agent', 'Confirmed! Siddharth Roy will visit today at 3:30 PM with digital laser mapping kit and Italian marble swatches.', 'Today 09:30 AM'),
      ],
    );
  }

  Widget _chatBubble(String sender, String text, String time) {
    final isAgent = sender == 'agent';
    return Align(
      alignment: isAgent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isAgent ? AppColors.primary : const Color(0xFF10B981).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: GoogleFonts.inter(fontSize: 12, color: isAgent ? Colors.white : null)),
            const SizedBox(height: 4),
            Text(time, style: GoogleFonts.inter(fontSize: 9.5, color: isAgent ? Colors.white70 : const Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.sm,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Site Laser Measurement Visit', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Today, 03:30 PM', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Location: Tower C, Apt 1402, DLF Camellias', style: GoogleFonts.inter(fontSize: 11.5)),
              const SizedBox(height: 4),
              Text('Assigned Team: Ananya Verma + Siddharth Roy (Lead Architect)', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityComposerTab(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('Add Consultant Note / Internal Follow-up', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 4,
          style: GoogleFonts.inter(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'e.g. Client requested Italian Statuario marble options for living room and French mouldings for master suite...',
            hintStyle: GoogleFonts.inter(fontSize: 11.5),
            border: OutlineInputBorder(borderRadius: AppRadius.sm),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _addNote,
          icon: const Icon(Icons.add_comment_rounded, size: 16),
          label: Text('Post Note to Timeline', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
