import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// My Projects Workspace for HOMIO Customer Portal.
/// Allows clients to monitor active/upcoming projects, track stage progress,
/// review milestones, check team contacts, and access all execution modules.
class ClientProjectsPage extends StatefulWidget {
  const ClientProjectsPage({super.key});

  @override
  State<ClientProjectsPage> createState() => _ClientProjectsPageState();
}

class _ClientProjectsPageState extends State<ClientProjectsPage> with SingleTickerProviderStateMixin {
  late CustomerProject _activeProject;
  late TabController _tabController;

  final List<String> _tabs = [
    'Overview',
    'Progress & Stages',
    'Milestones',
    'Team & Contacts',
    'Activity Log',
  ];

  @override
  void initState() {
    super.initState();
    _activeProject = ClientDataRepository.activeProject;
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.xl : AppSpacing.md,
          vertical: isDesktop ? AppSpacing.xl : AppSpacing.md,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. TOP HEADER & PROJECT SWITCHER
                _buildHeader(context, isDark, isDesktop),
                const SizedBox(height: 16),

                // 2. PROJECT HERO WORKSPACE CARD
                _buildHeroWorkspaceCard(context, isDark, isDesktop),
                const SizedBox(height: 16),

                // 3. WORKSPACE SUB-NAVIGATION TABS
                _buildTabSelector(isDark),
                const SizedBox(height: 16),

                // 4. TAB VIEW CONTENT
                _buildActiveTabContent(context, isDark, isDesktop),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 1. TOP HEADER
  // ============================================================================
  Widget _buildHeader(BuildContext context, bool isDark, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.home_work_rounded, size: 20, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Projects Workspace',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isDesktop ? 20 : 17,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Real-time execution dashboard, site inspections & milestone sign-offs.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Project Selector Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CustomerProject>(
                value: _activeProject,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: ClientDataRepository.allProjects.map((p) {
                  return DropdownMenuItem<CustomerProject>(
                    value: p,
                    child: Text(
                      p.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _activeProject = val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 2. HERO WORKSPACE CARD
  // ============================================================================
  Widget _buildHeroWorkspaceCard(BuildContext context, bool isDark, bool isDesktop) {
    final proj = _activeProject;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.xl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                proj.id,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF4F46E5),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CustomerStatusBadge(status: proj.status, isSmall: true),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            proj.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isDesktop ? 22 : 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${proj.type} • ${proj.location}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quick Module Short-cuts Row
                    if (isDesktop)
                      Row(
                        children: [
                          _buildShortcutBtn(context, '3D Vault', Icons.view_in_ar_rounded, '/client/designs'),
                          const SizedBox(width: 6),
                          _buildShortcutBtn(context, 'Site Feed', Icons.camera_indoor_rounded, '/client/site-progress'),
                          const SizedBox(width: 6),
                          _buildShortcutBtn(context, 'Approvals', Icons.verified_rounded, '/client/approvals'),
                          const SizedBox(width: 6),
                          _buildShortcutBtn(context, 'Chat', Icons.forum_rounded, '/client/chat'),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress Bar
                CustomerProgressBar(
                  progress: proj.overallProgress,
                  stageLabel: 'Current Stage: ${proj.currentStage}',
                  nextMilestone: proj.nextMilestone,
                ),
              ],
            ),
          ),

          // Mobile Shortcut row if not desktop
          if (!isDesktop) ...[
            const Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildShortcutBtn(context, '3D Designs', Icons.view_in_ar_rounded, '/client/designs'),
                    const SizedBox(width: 8),
                    _buildShortcutBtn(context, 'Site Feed', Icons.camera_indoor_rounded, '/client/site-progress'),
                    const SizedBox(width: 8),
                    _buildShortcutBtn(context, 'Approvals', Icons.verified_rounded, '/client/approvals'),
                    const SizedBox(width: 8),
                    _buildShortcutBtn(context, 'Chat PM', Icons.forum_rounded, '/client/chat'),
                    const SizedBox(width: 8),
                    _buildShortcutBtn(context, 'Invoices', Icons.receipt_rounded, '/client/payments'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShortcutBtn(BuildContext context, String label, IconData icon, String route) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        shape: RoundedAppRadius.md,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () => context.go(route),
      icon: Icon(icon, size: 14),
      label: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600)),
    );
  }

  // ============================================================================
  // 3. WORKSPACE TAB SELECTOR
  // ============================================================================
  Widget _buildTabSelector(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: const Color(0xFF4F46E5),
        indicatorWeight: 3,
        labelColor: const Color(0xFF4F46E5),
        unselectedLabelColor: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
        onTap: (_) => setState(() {}),
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  // ============================================================================
  // 4. TAB VIEW CONTENT
  // ============================================================================
  Widget _buildActiveTabContent(BuildContext context, bool isDark, bool isDesktop) {
    switch (_tabController.index) {
      case 0:
        return _buildOverviewTab(isDark, isDesktop);
      case 1:
        return _buildProgressAndStagesTab(isDark);
      case 2:
        return _buildMilestonesTab(isDark);
      case 3:
        return _buildTeamDossierTab(isDark, isDesktop);
      case 4:
        return _buildActivityTab(isDark);
      default:
        return _buildOverviewTab(isDark, isDesktop);
    }
  }

  // 4.1 Overview Tab
  Widget _buildOverviewTab(bool isDark, bool isDesktop) {
    final proj = _activeProject;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Specifications Card
        CustomerDetailSectionCard(
          title: 'Project Specifications & Address',
          icon: Icons.apartment_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Site Full Address',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
              Text(proj.fullAddress, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 12),
              Wrap(
                spacing: 24,
                runSpacing: 10,
                children: [
                  _buildMeta('Super Built-Up Area', proj.area, isDark),
                  _buildMeta('Carpet Area', proj.carpetArea, isDark),
                  _buildMeta('Rooms Layout', proj.rooms, isDark),
                  _buildMeta('Start Date', proj.startDate, isDark),
                  _buildMeta('Target Completion', proj.expectedCompletion, isDark, isGreen: true),
                ],
              ),
            ],
          ),
        ),

        // Financial Overview Card
        CustomerDetailSectionCard(
          title: 'Contract Commercials & Payments',
          icon: Icons.account_balance_wallet_rounded,
          trailing: TextButton(
            onPressed: () => context.go('/client/payments'),
            child: Text('View Invoices', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildFinBox('TOTAL CONTRACT', '₹18,50,000', const Color(0xFF4F46E5), isDark),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFinBox('PAID MILESTONES', '₹11,00,000', const Color(0xFF10B981), isDark),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFinBox('PENDING BALANCE', '₹7,50,000', const Color(0xFFF59E0B), isDark),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinBox(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.md,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // 4.2 Progress & Stages Tab
  Widget _buildProgressAndStagesTab(bool isDark) {
    final stages = _activeProject.stages;

    return CustomerDetailSectionCard(
      title: 'Project Execution Stage Progression',
      icon: Icons.linear_scale_rounded,
      child: Column(
        children: stages.map((stg) {
          final isCompleted = stg.progress >= 1.0;
          final isCurrent = stg.isCurrent;

          Color stageColor = isCompleted
              ? const Color(0xFF10B981)
              : (isCurrent ? const Color(0xFF3B82F6) : const Color(0xFF64748B));

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isCurrent
                    ? const Color(0xFF3B82F6)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                width: isCurrent ? 1.5 : 1,
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
                        Icon(
                          isCompleted
                              ? Icons.check_circle_rounded
                              : (isCurrent ? Icons.timelapse_rounded : Icons.radio_button_unchecked),
                          size: 18,
                          color: stageColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          stg.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    CustomerStatusBadge(status: stg.status, isSmall: true),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${stg.completedTasks} of ${stg.totalTasks} quality inspection checklist items cleared • ${stg.completedDateOrEta}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: stg.progress,
                    backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(stageColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 4.3 Milestones Tab
  Widget _buildMilestonesTab(bool isDark) {
    final milestones = _activeProject.milestones;

    return CustomerDetailSectionCard(
      title: 'Milestone Deliverables & Sign-Offs',
      icon: Icons.checklist_rounded,
      child: Column(
        children: milestones.map((ms) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: ms.requiresCustomerApproval && ms.status != MilestoneStatus.completed
                    ? const Color(0xFFF59E0B)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ms.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    CustomerStatusBadge(status: ms.status.label, isSmall: true),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ms.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  ),
                ),
                if (ms.dueDate != null || ms.completedDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    ms.completedDate != null ? 'Completed: ${ms.completedDate}' : 'Due Date: ${ms.dueDate}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ms.completedDate != null ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 4.4 Team Dossier Tab
  Widget _buildTeamDossierTab(bool isDark, bool isDesktop) {
    final proj = _activeProject;

    final members = [
      (
        'Project Manager',
        proj.pmName,
        proj.pmPhone,
        Icons.badge_rounded,
        'Full execution coordination, budget integrity & scheduling',
      ),
      (
        'Senior Interior Designer',
        proj.designerName,
        '+91 98222 55667',
        Icons.design_services_rounded,
        '3D photorealistic styling, material palette & mood boards',
      ),
      (
        'Site Execution Supervisor',
        proj.siteLeadName,
        '+91 98333 77889',
        Icons.engineering_rounded,
        'Daily on-site labour supervision, MEP testing & QA inspection',
      ),
    ];

    return CustomerDetailSectionCard(
      title: 'Assigned Project Leadership Team',
      icon: Icons.people_alt_rounded,
      child: Column(
        children: members.map((m) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF4F46E5).withValues(alpha: 0.15),
                  child: Icon(m.$4, size: 20, color: const Color(0xFF4F46E5)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.$2,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        m.$1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4F46E5),
                        ),
                      ),
                      Text(
                        m.$5,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.phone_rounded, color: Color(0xFF10B981), size: 20),
                  tooltip: 'Call ${m.$2}',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dialing ${m.$3}...')),
                    );
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 4.5 Activity Tab
  Widget _buildActivityTab(bool isDark) {
    return CustomerDetailSectionCard(
      title: 'Live Project Inspection & Update Feed',
      icon: Icons.feed_rounded,
      child: CustomerTimelineView(activities: _activeProject.activityLog),
    );
  }

  Widget _buildMeta(String label, String value, bool isDark, {bool isGreen = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isGreen
                ? const Color(0xFF10B981)
                : (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}
