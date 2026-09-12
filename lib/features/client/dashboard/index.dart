import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../shared/client_models.dart';
import '../shared/customer_shared_widgets.dart';

/// Customer Command Center Dashboard for HOMIO.
/// Empowers the client to immediately understand where their project stands,
/// what requires their action, recent activities, upcoming events, and financials.
class ClientDashboardPage extends StatefulWidget {
  const ClientDashboardPage({super.key});

  @override
  State<ClientDashboardPage> createState() => _ClientDashboardPageState();
}

class _ClientDashboardPageState extends State<ClientDashboardPage> {
  late CustomerProject _selectedProject;
  late List<CustomerActionItem> _actionItems;

  @override
  void initState() {
    super.initState();
    _selectedProject = ClientDataRepository.activeProject;
    _actionItems = List.from(ClientDataRepository.actionItems);
  }

  void _switchProject(CustomerProject proj) {
    setState(() {
      _selectedProject = proj;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= Breakpoints.medium;
    final isTablet = screenWidth >= 640 && screenWidth < Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) setState(() {});
        },
        child: SingleChildScrollView(
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
                  // 1. WELCOME & PROJECT SELECTOR
                  _buildWelcomeHeader(context, isDark, isDesktop),
                  const SizedBox(height: 20),

                  // 2. HERO PROJECT STATUS CARD
                  _buildProjectStatusHero(context, isDark, isDesktop),
                  const SizedBox(height: 24),

                  // 3. MAIN DASHBOARD BODY (2-COLUMN ON DESKTOP, 1-COLUMN ON MOBILE)
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (60%): Actions, Recent Activity & Quick Actions
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildActionRequiredSection(context, isDark),
                              const SizedBox(height: 24),
                              _buildQuickActionsGrid(context, isDark, isDesktop),
                              const SizedBox(height: 24),
                              _buildRecentActivitySection(context, isDark),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Right Column (40%): Financials, Quotation Summary & Upcoming
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildFinancialSummaryCard(context, isDark),
                              const SizedBox(height: 20),
                              _buildLatestQuotationCard(context, isDark),
                              const SizedBox(height: 20),
                              _buildUpcomingEventsCard(context, isDark),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    // Mobile/Tablet Single Column Stack
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildActionRequiredSection(context, isDark),
                        const SizedBox(height: 20),
                        _buildQuickActionsGrid(context, isDark, isDesktop),
                        const SizedBox(height: 20),
                        _buildFinancialSummaryCard(context, isDark),
                        const SizedBox(height: 20),
                        _buildLatestQuotationCard(context, isDark),
                        const SizedBox(height: 20),
                        _buildUpcomingEventsCard(context, isDark),
                        const SizedBox(height: 20),
                        _buildRecentActivitySection(context, isDark),
                      ],
                    ),

                  // Safe bottom clearance for mobile bottom navigation bar
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 1. WELCOME & PROJECT SELECTOR
  // ============================================================================
  Widget _buildWelcomeHeader(BuildContext context, bool isDark, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;

          final greetingCol = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Amit',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isDesktop ? 22 : 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s what\'s happening with your HOMIO project today.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isDesktop ? 13.5 : 12.5,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          );

          final projectDropdown = Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CustomerProject>(
                value: _selectedProject,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                items: ClientDataRepository.allProjects.map((p) {
                  return DropdownMenuItem<CustomerProject>(
                    value: p,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_work_rounded, size: 16, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          p.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) _switchProject(val);
                },
              ),
            ),
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                greetingCol,
                const SizedBox(height: 12),
                projectDropdown,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: greetingCol),
              const SizedBox(width: 16),
              projectDropdown,
            ],
          );
        },
      ),
    );
  }

  // ============================================================================
  // 2. HERO PROJECT STATUS CARD
  // ============================================================================
  Widget _buildProjectStatusHero(BuildContext context, bool isDark, bool isDesktop) {
    final proj = _selectedProject;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.xl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Banner with Title, Status & View Project CTA
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
                                'ACTIVE PROJECT',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  color: const Color(0xFF4F46E5),
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
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  proj.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          shape: RoundedAppRadius.md,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        onPressed: () => context.goNamed(RouteNames.clientProjects),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                        label: Text(
                          isDesktop ? 'View Workspace' : 'View',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Overall Progress Section
                CustomerProgressBar(
                  progress: proj.overallProgress,
                  stageLabel: 'Current Stage: ${proj.currentStage}',
                  nextMilestone: proj.nextMilestone,
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // Key Project Meta Grid
          Padding(
            padding: EdgeInsets.all(isDesktop ? AppSpacing.md : 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 640;

                final items = [
                  ('Start Date', proj.startDate, Icons.calendar_today_rounded),
                  ('Expected Handover', proj.expectedCompletion, Icons.event_available_rounded),
                  ('Project Manager', proj.pmName, Icons.person_rounded),
                  ('Last Updated', proj.lastUpdated, Icons.update_rounded),
                ];

                if (isNarrow) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.3,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                          borderRadius: AppRadius.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.$1,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.$2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return Row(
                  children: items.map((item) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                          borderRadius: AppRadius.md,
                        ),
                        child: Row(
                          children: [
                            Icon(item.$3, size: 16, color: const Color(0xFF4F46E5)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.$1,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                                    ),
                                  ),
                                  Text(
                                    item.$2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 3. ACTION REQUIRED SECTION
  // ============================================================================
  Widget _buildActionRequiredSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Action Required',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_actionItems.length}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ),
              ],
            ),
            if (_actionItems.isNotEmpty)
              Text(
                'Requires your review',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (_actionItems.isEmpty)
          CustomerEmptyState(
            icon: Icons.done_all_rounded,
            title: 'You\'re All Caught Up!',
            message: 'There are no pending approvals, payments, or actions requiring your attention right now.',
          )
        else
          ..._actionItems.map((item) {
            return ActionRequiredCard(
              item: item,
              onAction: () {
                context.go(item.routePath);
              },
            );
          }),
      ],
    );
  }

  // ============================================================================
  // 4. QUICK ACTIONS
  // ============================================================================
  Widget _buildQuickActionsGrid(BuildContext context, bool isDark, bool isDesktop) {
    final actions = [
      ('View Project', Icons.home_work_rounded, RouteNames.clientProjectsPath, const Color(0xFF4F46E5)),
      ('View Quotation', Icons.receipt_long_rounded, RouteNames.clientQuotationsPath, const Color(0xFF10B981)),
      ('My Enquiries', Icons.assignment_outlined, RouteNames.clientEnquiriesPath, const Color(0xFF3B82F6)),
      ('Approvals', Icons.verified_rounded, '/client/approvals', const Color(0xFF8B5CF6)),
      ('Chat Team', Icons.forum_rounded, '/client/chat', const Color(0xFF06B6D4)),
      ('Make Payment', Icons.account_balance_wallet_rounded, '/client/payments', const Color(0xFFF59E0B)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 6 : 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isDesktop ? 1.35 : 1.1,
          ),
          itemCount: actions.length,
          itemBuilder: (context, i) {
            final act = actions[i];
            return Material(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              borderRadius: AppRadius.md,
              child: InkWell(
                onTap: () => context.go(act.$3),
                borderRadius: AppRadius.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.md,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: act.$4.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(act.$2, size: 18, color: act.$4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        act.$1,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================================
  // 5. FINANCIAL SUMMARY CARD
  // ============================================================================
  Widget _buildFinancialSummaryCard(BuildContext context, bool isDark) {
    final proj = _selectedProject;
    final totalValStr = '₹${proj.totalValue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final paidValStr = '₹${proj.paidAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final pendingValStr = '₹${proj.pendingAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final paidPercent = proj.totalValue > 0 ? ((proj.paidAmount / proj.totalValue) * 100).toInt() : 0;
    final pendingPercent = 100 - paidPercent;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.account_balance_rounded, size: 16, color: Color(0xFF10B981)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Financial Summary',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: const Color(0xFF4F46E5),
                ),
                onPressed: () => context.go('/client/payments'),
                child: Text('View Billing', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Total Project Value
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PROJECT VALUE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
                Text(
                  totalValStr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Paid vs Pending Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.08),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PAID ($paidPercent%)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF059669),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        paidValStr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
                    borderRadius: AppRadius.md,
                    border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PENDING ($pendingPercent%)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFD97706),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pendingValStr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 6. LATEST QUOTATION CARD
  // ============================================================================
  Widget _buildLatestQuotationCard(BuildContext context, bool isDark) {
    final quote = ClientDataRepository.primaryQuotation;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.receipt_long_rounded, size: 16, color: Color(0xFF3B82F6)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Latest Quotation',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              CustomerStatusBadge(status: quote.status, isSmall: true),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'Quotation #${quote.id}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            quote.projectTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  ),
                  Text(
                    '₹12,80,000',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Validity',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  ),
                  Text(
                    'Valid until ${quote.validUntil}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 40,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedAppRadius.md,
                side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              ),
              onPressed: () => context.goNamed(RouteNames.clientQuotations),
              child: Text(
                'View Detailed Proposal',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 7. UPCOMING EVENTS CARD
  // ============================================================================
  Widget _buildUpcomingEventsCard(BuildContext context, bool isDark) {
    final events = [
      (
        'Tomorrow, 11:00 AM',
        'Design Review Meeting (Online Google Meet)',
        Icons.video_call_rounded,
        const Color(0xFF06B6D4),
      ),
      (
        '20 Sep 2026',
        'Execution Milestone Payment (₹75,000)',
        Icons.payments_rounded,
        const Color(0xFFF59E0B),
      ),
      (
        '22 Sep 2026',
        'False Ceiling & Gypsum Framing Approval',
        Icons.rule_folder_rounded,
        const Color(0xFF8B5CF6),
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
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.calendar_month_rounded, size: 16, color: Color(0xFF8B5CF6)),
              ),
              const SizedBox(width: 8),
              Text(
                'Upcoming Schedule',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...events.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: e.$4.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(e.$3, size: 14, color: e.$4),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.$1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: e.$4,
                          ),
                        ),
                        Text(
                          e.$2,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
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
  // 8. RECENT ACTIVITY TIMELINE
  // ============================================================================
  Widget _buildRecentActivitySection(BuildContext context, bool isDark) {
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.history_rounded, size: 16, color: Color(0xFF4F46E5)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Project Activity',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'Live Updates',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomerTimelineView(activities: _selectedProject.activityLog),
        ],
      ),
    );
  }
}
