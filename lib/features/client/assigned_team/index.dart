import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// Screen 1: ASSIGNED TEAM (/client/team)
/// Premium, transparent team dossier for HOMIO customer portal.
/// Gives homeowner complete visibility into who is responsible for their project,
/// their credentials, schedules, active site focus, and direct communication channels.
class ClientAssignedTeamPage extends StatefulWidget {
  const ClientAssignedTeamPage({super.key});

  @override
  State<ClientAssignedTeamPage> createState() => _ClientAssignedTeamPageState();
}

class _ClientAssignedTeamPageState extends State<ClientAssignedTeamPage> {
  TeamDepartment? _selectedDept;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= Breakpoints.medium;
    final isTablet = screenWidth >= 640 && screenWidth < Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.xl : (isTablet ? AppSpacing.lg : AppSpacing.md),
          vertical: isDesktop ? AppSpacing.xl : AppSpacing.md,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. SHARED PROJECT CONTEXT HEADER & SUB-NAVIGATION
                const CustomerProjectContextBar(activeTab: 'team'),
                const SizedBox(height: 16),

                // 2. TEAM OVERVIEW HERO BANNER
                _buildTeamOverviewHero(context, isDark, isDesktop),
                const SizedBox(height: 24),

                // 3. PRIMARY KEY LEADS SPOTLIGHT
                _buildKeyLeadsSection(context, isDark, isDesktop, isTablet),
                const SizedBox(height: 28),

                // 4. DEPARTMENT FILTER CHIPS & SEARCH
                _buildFilterAndSearchRow(context, isDark, isDesktop),
                const SizedBox(height: 18),

                // 5. GROUPED DEPARTMENT DIRECTORY
                _buildDepartmentDirectory(context, isDark, isDesktop, isTablet),
                const SizedBox(height: 28),

                // 6. RECENT TEAM ACTIVITY LOG
                _buildRecentTeamActivity(context, isDark),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 1. TEAM OVERVIEW HERO BANNER
  // ============================================================================
  Widget _buildTeamOverviewHero(BuildContext context, bool isDark, bool isDesktop) {
    final members = ClientDataRepository.teamMembers;
    final onSiteCount = members.where((m) => m.dutyStatus == TeamDutyStatus.onSite).length;
    final inStudioCount = members.where((m) => m.dutyStatus == TeamDutyStatus.inStudio).length;

    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.badge_outlined, size: 16, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PROJECT TEAM',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: const Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your HOMIO Project Team',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isDesktop ? 22 : 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A dedicated squad of architects, project managers, and civil engineers assigned exclusively to your home.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_rounded, color: Color(0xFF10B981), size: 18),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '100% Dedicated Team',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF059669),
                            ),
                          ),
                          Text(
                            'Guaranteed Execution SLA',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 14),

          // Quick Summary Counters
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildSummaryChip(
                Icons.people_alt_rounded,
                '${members.length} Assigned Specialists',
                const Color(0xFF4F46E5),
                isDark,
              ),
              _buildSummaryChip(
                Icons.location_on_rounded,
                '$onSiteCount Active On-Site Today',
                const Color(0xFF10B981),
                isDark,
              ),
              _buildSummaryChip(
                Icons.palette_rounded,
                '$inStudioCount In Design Studio',
                const Color(0xFFF59E0B),
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(IconData icon, String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 2. PRIMARY KEY LEADS SPOTLIGHT
  // ============================================================================
  Widget _buildKeyLeadsSection(BuildContext context, bool isDark, bool isDesktop, bool isTablet) {
    final primaryLeads = ClientDataRepository.teamMembers.where((m) => m.isPrimary).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF4F46E5),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Primary Project Leads',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Direct points of contact for timeline, design & site execution',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Grid for Primary Leads
        LayoutBuilder(
          builder: (context, constraints) {
            final crossCount = isDesktop ? 3 : (isTablet ? 2 : 1);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 310,
              ),
              itemCount: primaryLeads.length,
              itemBuilder: (context, i) {
                return _buildTeamMemberCard(context, primaryLeads[i], isDark, isHighlight: true);
              },
            );
          },
        ),
      ],
    );
  }

  // ============================================================================
  // 3. FILTER & SEARCH
  // ============================================================================
  Widget _buildFilterAndSearchRow(BuildContext context, bool isDark, bool isDesktop) {
    final depts = [
      (null, 'All Specialists (${ClientDataRepository.teamMembers.length})'),
      (TeamDepartment.leadership, 'Leadership'),
      (TeamDepartment.design, 'Design & Architecture'),
      (TeamDepartment.execution, 'Site Execution'),
      (TeamDepartment.support, 'Client Success'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Horizontal Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: depts.map((d) {
              final isSelected = _selectedDept == d.$1;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(d.$2),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() => _selectedDept = val ? d.$1 : null);
                  },
                  selectedColor: const Color(0xFF4F46E5),
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // 4. GROUPED DEPARTMENT DIRECTORY
  // ============================================================================
  Widget _buildDepartmentDirectory(BuildContext context, bool isDark, bool isDesktop, bool isTablet) {
    var allMembers = ClientDataRepository.teamMembers;
    if (_selectedDept != null) {
      allMembers = allMembers.where((m) => m.department == _selectedDept).toList();
    }

    if (allMembers.isEmpty) {
      return CustomerEmptyState(
        icon: Icons.person_off_rounded,
        title: 'No Team Members Found',
        message: 'There are no specialists assigned under this department currently.',
      );
    }

    // Group remaining non-primary or filtered members
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = isDesktop ? 3 : (isTablet ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 310,
          ),
          itemCount: allMembers.length,
          itemBuilder: (context, i) {
            return _buildTeamMemberCard(context, allMembers[i], isDark, isHighlight: false);
          },
        );
      },
    );
  }

  // ============================================================================
  // TEAM MEMBER PROFILE CARD (Clean, Professional, Zero Internal HR data)
  // ============================================================================
  Widget _buildTeamMemberCard(BuildContext context, CustomerTeamMember member, bool isDark, {required bool isHighlight}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isHighlight
              ? member.department.color.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isHighlight ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: member.department.color.withValues(alpha: isHighlight ? 0.08 : 0.02),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar + Name + Duty Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: member.avatarColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: member.avatarColor.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      member.initials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: member.avatarColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        member.role,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: member.department.color,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDutyBadge(member.dutyStatus),
              ],
            ),
            const SizedBox(height: 10),

            // Active Focus Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.sm,
              ),
              child: Row(
                children: [
                  Icon(Icons.gps_fixed_rounded, size: 12, color: member.department.color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Focus: ${member.activeFocus}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Responsibilities Bullet List (Customer-Facing Only)
            Text(
              'Responsible For:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: member.responsibilities.take(2).map((resp) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(Icons.circle, size: 4, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            resp,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              height: 1.3,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 8),

            // Contact Action Buttons: [Message] & [Call] & [Details]
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedAppRadius.sm,
                        side: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () => _openMessageModal(context, member),
                      icon: const Icon(Icons.forum_outlined, size: 13),
                      label: Text(
                        'Message',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        shape: RoundedAppRadius.sm,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () => _openCallModal(context, member),
                      icon: const Icon(Icons.call_rounded, size: 13),
                      label: Text(
                        'Call',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _openResponsibilitySheet(context, member),
                  borderRadius: AppRadius.sm,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.info_outline_rounded, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDutyBadge(TeamDutyStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 10, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 5. RECENT TEAM ACTIVITY LOG
  // ============================================================================
  Widget _buildRecentTeamActivity(BuildContext context, bool isDark) {
    final activities = [
      (
        'Today, 11:00 AM',
        'Priya Mehta (Lead Designer) uploaded Living Room 3D Revision v3',
        'Updated lighter Scandinavian oak finish and cove profile for client review.',
        Icons.view_in_ar_rounded,
        const Color(0xFF8B5CF6),
      ),
      (
        'Today, 10:30 AM',
        'Amit Verma (Site Supervisor) logged Electrical Conduiting progress',
        'Uploaded 3 photos and 1 walkthrough video showing concealed Finolex runs.',
        Icons.electrical_services_rounded,
        const Color(0xFF10B981),
      ),
      (
        'Yesterday, 04:30 PM',
        'Rahul Sharma (PM) scheduled On-Site Joint Inspection for false ceiling',
        'Coordinated with master carpenter and electrical subcontractor.',
        Icons.event_available_rounded,
        const Color(0xFF4F46E5),
      ),
      (
        '08 Sep 2026',
        'Priya Mehta (Lead Designer) certified Master Bedroom Smoked Wardrobe v2',
        'Client digital sign-off received. Sent to factory cut list.',
        Icons.verified_rounded,
        const Color(0xFF06B6D4),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_rounded, size: 16, color: Color(0xFF4F46E5)),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Customer-Visible Team Activity',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'Live Team Log',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...activities.map((act) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: act.$5.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(act.$4, size: 13, color: act.$5),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                act.$2,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Text(
                              act.$1,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          act.$3,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ============================================================================
  // DIALOGS & CONTACT MODALS
  // ============================================================================
  void _openMessageModal(BuildContext context, CustomerTeamMember member) {
    final msgCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Row(
          children: [
            const Icon(Icons.forum_rounded, color: Color(0xFF4F46E5), size: 20),
            const SizedBox(width: 8),
            Text(
              'Message ${member.name}',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Direct channel for ${member.role}',
              style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: msgCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type your question or query here...',
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: AppRadius.md),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedAppRadius.md,
            ),
            onPressed: () {
              if (msgCtrl.text.trim().isEmpty) return;
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF4F46E5),
                  content: Text(
                    'Message sent to ${member.name}! Expected response within 2 hours.',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                  ),
                ),
              );
            },
            child: Text('Send Message', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _openCallModal(BuildContext context, CustomerTeamMember member) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.call_rounded, color: Color(0xFF10B981), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direct Contact: ${member.name}',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      Text(
                        member.role,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: member.department.color, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.md,
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 16, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Office Schedule: ${member.schedule}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFF25D366)),
                      foregroundColor: const Color(0xFF25D366),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening WhatsApp with ${member.name} (${member.whatsappNumber})')),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                    label: Text('WhatsApp', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${member.name} (${member.phoneNumber})...')),
                      );
                    },
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
                    label: Text('Call Now', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openResponsibilitySheet(BuildContext context, CustomerTeamMember member) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${member.name} — Detailed Role Dossier',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                '${member.role} • ${member.qualification}',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: member.department.color, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                'All Customer-Facing Responsibilities:',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...member.responsibilities.map((r) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          r,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
