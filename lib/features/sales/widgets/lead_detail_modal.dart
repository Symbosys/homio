import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../dashboard/widgets/compact_data_table.dart';
import '../models/sales_models.dart';

/// Single Lead Focus Card Modal & Detail View
class LeadDetailModal extends StatefulWidget {
  final SalesLeadItem lead;
  final List<SalesFunnelStage> stages;
  final ValueChanged<SalesLeadItem> onLeadUpdated;

  const LeadDetailModal({
    super.key,
    required this.lead,
    required this.stages,
    required this.onLeadUpdated,
  });

  static void show(
    BuildContext context, {
    required SalesLeadItem lead,
    required List<SalesFunnelStage> stages,
    required ValueChanged<SalesLeadItem> onLeadUpdated,
  }) {
    showDialog(
      context: context,
      builder: (context) => LeadDetailModal(
        lead: lead,
        stages: stages,
        onLeadUpdated: onLeadUpdated,
      ),
    );
  }

  @override
  State<LeadDetailModal> createState() => _LeadDetailModalState();
}

class _LeadDetailModalState extends State<LeadDetailModal> {
  late String _currentStageId;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    _currentStageId = widget.lead.stageId;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lead = widget.lead;
    final currentStage = widget.stages.firstWhere(
      (s) => s.id == _currentStageId,
      orElse: () => widget.stages.first,
    );

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 680,
        constraints: const BoxConstraints(maxHeight: 740),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: currentStage.color.withValues(alpha: 0.18),
                    child: Text(
                      lead.clientName.substring(0, 1),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: currentStage.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              lead.clientName,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DashboardBadge(
                              label: lead.id,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${lead.projectType} • Created ${lead.createdDate}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Modal Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stage Switcher & Quick Actions Strip
                    _buildStageAndActionsStrip(lead, currentStage, isDark),
                    const SizedBox(height: 18),

                    // Key Details Grid
                    _buildDetailsGrid(lead, isDark),
                    const SizedBox(height: 18),

                    // Call Audio Player & Recording Card
                    _buildCallAudioCard(lead, isDark),
                    const SizedBox(height: 18),

                    // Activity Timeline
                    _buildActivityTimeline(lead, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageAndActionsStrip(SalesLeadItem lead, SalesFunnelStage currentStage, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Stage Selector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT FUNNEL STAGE',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: currentStage.color.withValues(alpha: 0.5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentStageId,
                      isExpanded: true,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: currentStage.color,
                      ),
                      dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                      items: widget.stages.map((s) {
                        return DropdownMenuItem<String>(
                          value: s.id,
                          child: Text(s.name),
                        );
                      }).toList(),
                      onChanged: (newStageId) {
                        if (newStageId != null) {
                          setState(() => _currentStageId = newStageId);
                          final updated = lead.copyWith(stageId: newStageId);
                          widget.onLeadUpdated(updated);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lead moved to ${widget.stages.firstWhere((s) => s.id == newStageId).name}'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Click-to-call button
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dialing ${lead.phone} via WebRTC Autodialer...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.phone_in_talk, size: 14),
            label: Text('Call Lead', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            ),
          ),
          const SizedBox(width: 8),

          // WhatsApp Cloud API button
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening WhatsApp Cloud API conversation with ${lead.clientName}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.chat, size: 14),
            label: Text('WhatsApp', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(SalesLeadItem lead, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Intake & Architectural Specifications',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.sm,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            children: [
              _detailRow('Site Location', lead.siteAddress, Icons.location_on_outlined, isDark),
              const Divider(height: 14),
              _detailRow('Work Scope', lead.workDescription, Icons.architecture, isDark),
              const Divider(height: 14),
              _detailRow('Budget Estimate', '₹${lead.budgetAmount} Lakhs (Turnkey Handover)', Icons.currency_rupee, isDark, isHighlight: true),
              const Divider(height: 14),
              _detailRow('Meeting Format', lead.meetingPreference, Icons.meeting_room_outlined, isDark),
              const Divider(height: 14),
              _detailRow('Assigned Consultant', lead.assignedConsultant, Icons.person_outline, isDark),
              const Divider(height: 14),
              _detailRow('Next Follow-up', lead.nextFollowupTime, Icons.alarm_on_outlined, isDark, isWarning: lead.isFollowupOverdue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value, IconData icon, bool isDark, {bool isHighlight = false, bool isWarning = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: isHighlight ? const Color(0xFF10B981) : (isWarning ? const Color(0xFFEF4444) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
        const SizedBox(width: 8),
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: (isHighlight || isWarning) ? FontWeight.w700 : FontWeight.w600,
              color: isHighlight
                  ? const Color(0xFF10B981)
                  : (isWarning ? const Color(0xFFEF4444) : (isDark ? Colors.white : AppColors.lightTextPrimary)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCallAudioCard(SalesLeadItem lead, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() => _isPlayingAudio = !_isPlayingAudio);
            },
            icon: Icon(
              _isPlayingAudio ? Icons.pause_circle_filled : Icons.play_circle_fill,
              size: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Call Audio Recording (3m 42s)',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  _isPlayingAudio ? 'Playing automated autodialer session...' : 'Recorded on Sep 6, 2026 • WebRTC Line 1',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading audio recording .mp3'), behavior: SnackBarBehavior.floating),
              );
            },
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            ),
            child: Text('Download', style: GoogleFonts.inter(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline(SalesLeadItem lead, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity History & Touchpoints',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _timelineItem('Meta Lead Ad Submitted', 'Form: Luxury Penthouse Campaign • DLF Phase 5', 'Today, 10:15 AM', Icons.campaign_rounded, const Color(0xFF6366F1), isDark),
        _timelineItem('AI Voice Qualification Call Done', 'Carpet area 4,200 sqft verified. Budget ₹48.5L accepted.', 'Today, 10:20 AM', Icons.phone_in_talk, const Color(0xFF10B981), isDark),
        _timelineItem('WhatsApp Catalog Dispatched', 'Luxury_Penthouse_Portfolio_2026.pdf delivered.', 'Today, 10:22 AM', Icons.chat, const Color(0xFF25D366), isDark),
        _timelineItem('Site Measurement Meeting Scheduled', 'Consultant: Aarav Singhania locked for 02:30 PM.', 'Today, 10:25 AM', Icons.event_available, const Color(0xFF3B82F6), isDark),
      ],
    );
  }

  Widget _timelineItem(String title, String subtitle, String time, IconData icon, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 12, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
