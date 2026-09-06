import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_badge.dart';
import 'app_button.dart';
import 'app_card.dart';

/// Comprehensive, full-detail interactive client portal screen content renderer.
/// Renders dedicated, rich feature dashboards for each of the client portal modules
/// with silky smooth entry animations when switching between views.
class ClientScreenContent extends StatelessWidget {
  final String path;
  final String title;
  final String? description;
  final IconData icon;
  final List<String> subFeatures;

  const ClientScreenContent({
    super.key,
    required this.path,
    required this.title,
    this.description,
    required this.icon,
    this.subFeatures = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      key: ValueKey(path),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TOP CLIENT HERO BANNER
          _buildHeroBanner(context, isDark),
          const SizedBox(height: AppSpacing.lg),

          // 2. SUB-FEATURES SUMMARY PILLS (What this screen contains)
          if (subFeatures.isNotEmpty) ...[
            _buildSubFeaturesBar(context, isDark),
            const SizedBox(height: AppSpacing.lg),
          ],

          // 3. DEDICATED FULL-DETAIL SCREEN CONTENT
          _buildModuleContent(context, isDark),
        ],
      ),
    );
  }

  // =========================================================================
  // HERO BANNER & SUB-FEATURES PILLS
  // =========================================================================

  Widget _buildHeroBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF064E3B), const Color(0xFF022C22)]
              : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF34D399), Color(0xFF10B981), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.md,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    const AppBadge(
                      label: 'HOMEOWNER PORTAL',
                      color: Color(0xFF10B981),
                      isPill: true,
                    ),
                    AppBadge(
                      label: path,
                      color: const Color(0xFF0D9488),
                      isPill: true,
                    ),
                    const AppBadge(
                      label: 'LIVE PROJECT: VILLA #402',
                      color: Color(0xFF6366F1),
                      isPill: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : const Color(0xFF064E3B),
                  ),
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF047857),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubFeaturesBar(BuildContext context, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 18, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'FEATURES INCLUDED IN THIS VIEW',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subFeatures.map((feat) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF064E3B).withValues(alpha: 0.4)
                      : const Color(0xFFECFDF5),
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        feat,
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF064E3B),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MODULE ROUTER DISPATCHER
  // =========================================================================

  Widget _buildModuleContent(BuildContext context, bool isDark) {
    if (path.contains('overview')) {
      return _buildOverviewScreen(context, isDark);
    } else if (path.contains('team')) {
      return _buildTeamDossierScreen(context, isDark);
    } else if (path.contains('site-progress') || path.contains('milestones')) {
      return _buildSiteProgressScreen(context, isDark);
    } else if (path.contains('approvals') || path.contains('approval-history')) {
      return _buildApprovalsScreen(context, isDark);
    } else if (path.contains('designs') || path.contains('documents')) {
      return _buildDesignsScreen(context, isDark);
    } else if (path.contains('chat') || path.contains('meetings')) {
      return _buildChatMeetingsScreen(context, isDark);
    } else if (path.contains('payments') || path.contains('cost-summary') || path.contains('invoices')) {
      return _buildPaymentsScreen(context, isDark);
    } else if (path.contains('complaints') || path.contains('warranty')) {
      return _buildComplaintsScreen(context, isDark);
    } else if (path.contains('ratings')) {
      return _buildRatingsScreen(context, isDark);
    } else if (path.contains('ai-suite') || path.contains('ai-') || path.contains('designer-call')) {
      return _buildAiSuiteScreen(context, isDark);
    } else if (path.contains('marketplace') || path.contains('properties') || path.contains('store') || path.contains('decor') || path.contains('labour')) {
      return _buildMarketplaceScreen(context, isDark);
    }

    return _buildOverviewScreen(context, isDark);
  }

  // =========================================================================
  // 1. PROJECT DASHBOARD
  // =========================================================================

  Widget _buildOverviewScreen(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // KPI Metrics Row
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _metricCard(
                  title: 'Overall Progress',
                  value: '72%',
                  subtext: '8 of 12 Milestones Done',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFF10B981),
                  width: isMobile ? double.infinity : (constraints.maxWidth - AppSpacing.md * 3) / 4,
                  isDark: isDark,
                ),
                _metricCard(
                  title: 'Active Stage',
                  value: 'Carpentry',
                  subtext: 'Wardrobes & Modular Polish',
                  icon: Icons.carpenter_rounded,
                  color: const Color(0xFF6366F1),
                  width: isMobile ? double.infinity : (constraints.maxWidth - AppSpacing.md * 3) / 4,
                  isDark: isDark,
                ),
                _metricCard(
                  title: 'Paid vs Total',
                  value: '₹34.92 L',
                  subtext: 'Total: ₹48.50 L (72% Paid)',
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xFFF59E0B),
                  width: isMobile ? double.infinity : (constraints.maxWidth - AppSpacing.md * 3) / 4,
                  isDark: isDark,
                ),
                _metricCard(
                  title: 'Expected Handover',
                  value: 'Nov 15, 2026',
                  subtext: 'On Schedule (71 Days left)',
                  icon: Icons.event_available_rounded,
                  color: const Color(0xFF0EA5E9),
                  width: isMobile ? double.infinity : (constraints.maxWidth - AppSpacing.md * 3) / 4,
                  isDark: isDark,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Active Stage Banner & Live Status
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.bolt_rounded, color: Color(0xFF10B981), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'STAGE 4 (CARPENTRY & MODULAR POLISH)',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const AppBadge(
                    label: 'DAY 18 OF 25',
                    color: Color(0xFF10B981),
                    isPill: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: AppRadius.full,
                child: LinearProgressIndicator(
                  value: 0.72,
                  minHeight: 10,
                  backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Carpentry team is currently installing the master bedroom fluted panelling and soft-close modular drawers. Tile grouting inspection in the guest bath is scheduled for tomorrow at 11:00 AM.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppButton(
                    text: 'View Live Site Photos',
                    prefixIcon: Icons.camera_alt_rounded,
                    onPressed: () {},
                    size: AppButtonSize.small,
                  ),
                  AppButton(
                    text: 'Message Project Manager',
                    prefixIcon: Icons.chat_rounded,
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                    size: AppButtonSize.small,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 2. ASSIGNED TEAM DOSSIER
  // =========================================================================

  Widget _buildTeamDossierScreen(BuildContext context, bool isDark) {
    final teamMembers = [
      {
        'role': 'Project Manager (Lead)',
        'name': 'Vikram Malhotra',
        'exp': '8+ Years Exp • 42 Turnkey Villas Delivered',
        'phone': '+91 98765 43210',
        'email': 'vikram.m@homio.in',
        'status': 'Active On-Site',
        'avatarColor': const Color(0xFF10B981),
      },
      {
        'role': 'Senior Interior Designer',
        'name': 'Pooja Hegde',
        'exp': 'B.Arch • Gold Medalist • Luxury Residential Specialist',
        'phone': '+91 98112 34567',
        'email': 'pooja.h@homio.in',
        'status': 'Studio Available',
        'avatarColor': const Color(0xFF6366F1),
      },
      {
        'role': 'Site Execution Supervisor',
        'name': 'Rajesh Verma',
        'exp': 'Civil Engg • 12+ Years Site Supervision',
        'phone': '+91 98223 78901',
        'email': 'rajesh.v@homio.in',
        'status': 'At Villa 402',
        'avatarColor': const Color(0xFFF59E0B),
      },
      {
        'role': 'Lead Structural & Vastu Expert',
        'name': 'Dr. Arvinder Singh',
        'exp': 'Ph.D. Vastu Shastra & Architectural Alignment',
        'phone': '+91 98334 56789',
        'email': 'arvinder.s@homio.in',
        'status': 'Consulting',
        'avatarColor': const Color(0xFF0EA5E9),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCol = constraints.maxWidth > 700;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: teamMembers.map((m) {
                return SizedBox(
                  width: isTwoCol ? (constraints.maxWidth - AppSpacing.md) / 2 : double.infinity,
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: (m['avatarColor'] as Color).withValues(alpha: 0.2),
                              child: Text(
                                (m['name'] as String).substring(0, 2).toUpperCase(),
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: m['avatarColor'] as Color,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          m['name'] as String,
                                          style: AppTypography.titleMedium.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                      ),
                                      AppBadge(
                                        label: m['status'] as String,
                                        color: const Color(0xFF10B981),
                                        isPill: true,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    m['role'] as String,
                                    style: AppTypography.labelMedium.copyWith(
                                      color: const Color(0xFF10B981),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    m['exp'] as String,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Divider(height: 1),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone_rounded, size: 16, color: Color(0xFF10B981)),
                                const SizedBox(width: 6),
                                Text(
                                  m['phone'] as String,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                AppButton(
                                  text: 'WhatsApp',
                                  prefixIcon: Icons.chat_bubble_outline_rounded,
                                  onPressed: () {},
                                  size: AppButtonSize.small,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Emergency Escalation Card
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.headset_mic_rounded, color: Color(0xFFEF4444), size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dedicated Client Relationship Hotline (24x7)',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'Need urgent management intervention? Call our priority line: 1800-419-HOMIO (Ext 402)',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                text: 'Direct Call',
                prefixIcon: Icons.phone_in_talk_rounded,
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.small,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 3. LIVE SITE PROGRESS
  // =========================================================================

  Widget _buildSiteProgressScreen(BuildContext context, bool isDark) {
    final photoLogs = [
      {'tag': 'LIVING ROOM', 'title': 'False Ceiling Profile LED & Cove Wiring', 'time': 'Today, 11:30 AM', 'sup': 'Rajesh Verma'},
      {'tag': 'MODULAR KITCHEN', 'title': 'Anti-Rust Stainless 304 Hardware Fitting', 'time': 'Yesterday, 04:45 PM', 'sup': 'Rajesh Verma'},
      {'tag': 'MASTER BEDROOM', 'title': 'Veneer Polish First Coat & Fluting Check', 'time': 'Yesterday, 02:15 PM', 'sup': 'Vikram M.'},
      {'tag': 'BALCONY DECK', 'title': 'Waterproofing Level 3 Flood Test Passed', 'time': 'Sep 03, 10:00 AM', 'sup': 'Vikram M.'},
    ];

    final stages = [
      {'num': '1', 'name': 'Civil & Demolition', 'status': '100% Completed', 'done': true},
      {'num': '2', 'name': 'MEP & Electrical Concealing', 'status': '100% Completed', 'done': true},
      {'num': '3', 'name': 'False Ceiling & POP Works', 'status': '100% Completed', 'done': true},
      {'num': '4', 'name': 'Carpentry & Modular Fabrication', 'status': '75% In Progress', 'done': false, 'active': true},
      {'num': '5', 'name': 'Tile Grouting & Marble Polish', 'status': '40% In Progress', 'done': false},
      {'num': '6', 'name': 'Painting & Final Deep Cleaning', 'status': 'Scheduled Oct 20', 'done': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Daily Inspection Photo Grid
        Text(
          'DAILY SITE INSPECTION STREAM (PHOTOS & VIDEOS)',
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCol = constraints.maxWidth > 700;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: photoLogs.map((p) {
                return SizedBox(
                  width: isTwoCol ? (constraints.maxWidth - AppSpacing.md) / 2 : double.infinity,
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFECFDF5),
                            borderRadius: AppRadius.md,
                            border: Border.all(
                              color: isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.camera_indoor_rounded,
                                size: 48,
                                color: const Color(0xFF10B981).withValues(alpha: 0.6),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: AppBadge(
                                  label: p['tag']!,
                                  color: const Color(0xFF10B981),
                                  isPill: true,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: AppRadius.sm,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text('Enlarge', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          p['title']!,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              p['time']!,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            Text(
                              'By: ${p['sup']}',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Stage Milestones Checklist
        Text(
          'STAGE MILESTONES & QUALITY CHECKLIST',
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: stages.map((s) {
              final isDone = s['done'] == true;
              final isActive = s['active'] == true;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isActive
                      ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.4) : const Color(0xFFECFDF5))
                      : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF10B981)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDone
                            ? const Color(0xFF10B981)
                            : (isActive ? const Color(0xFF6366F1) : Colors.grey.withValues(alpha: 0.3)),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          isDone ? Icons.check_rounded : Icons.pending_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stage ${s['num']}: ${s['name']}',
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            s['status'] as String,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDone
                                  ? const Color(0xFF10B981)
                                  : (isActive ? const Color(0xFF6366F1) : Colors.grey),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppBadge(
                      label: isDone ? 'VERIFIED' : (isActive ? 'IN PROGRESS' : 'UPCOMING'),
                      color: isDone
                          ? const Color(0xFF10B981)
                          : (isActive ? const Color(0xFF6366F1) : Colors.grey),
                      isPill: true,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 4. STAGE WORK APPROVALS
  // =========================================================================

  Widget _buildApprovalsScreen(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Urgent Action Card
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: Color(0xFF6366F1), size: 22),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'STAGE 3: FALSE CEILING & ELECTRICAL CONCEALING SIGN-OFF',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const AppBadge(
                    label: 'AWAITING YOUR APPROVAL',
                    color: Color(0xFF6366F1),
                    isPill: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Supervisor Rajesh Verma has completed the 14-point False Ceiling & Conduit wiring audit. All 6 inspection photos have been verified by Lead Architect Pooja Hegde.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _checklistTag('Laser Level Check: PASS', isDark),
                  _checklistTag('Conduit Fire Retardant: PASS', isDark),
                  _checklistTag('Earthing & Voltage Test: PASS', isDark),
                  _checklistTag('6 High-Res Photos Attached', isDark),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  AppButton(
                    text: '1-Click Digital Sign-Off',
                    prefixIcon: Icons.check_circle_rounded,
                    onPressed: () {},
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    text: 'Request Modification',
                    prefixIcon: Icons.edit_note_rounded,
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Approved Stages History
        Text(
          'PREVIOUSLY SIGNED-OFF STAGE CERTIFICATES',
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _auditRow(
                stage: 'Stage 1: Civil & Demolition Clearance',
                cert: 'CERT #HOM-APP-1042',
                date: 'Aug 12, 2026',
                signedBy: 'Sarah Jenkins (Homeowner)',
                isDark: isDark,
              ),
              const Divider(),
              _auditRow(
                stage: 'Stage 2: Plumbing & Wet Area Waterproofing',
                cert: 'CERT #HOM-APP-1098',
                date: 'Aug 24, 2026',
                signedBy: 'Sarah Jenkins (Homeowner)',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _checklistTag(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.15),
        borderRadius: AppRadius.sm,
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF10B981),
        ),
      ),
    );
  }

  Widget _auditRow({
    required String stage,
    required String cert,
    required String date,
    required String signedBy,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '$cert • Signed on $date by $signedBy',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppButton(
            text: 'Download PDF',
            prefixIcon: Icons.download_rounded,
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.small,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 5. 3D DESIGNS & CAD VAULT
  // =========================================================================

  Widget _buildDesignsScreen(BuildContext context, bool isDark) {
    final renders = [
      {'room': 'Living & Dining Room', 'theme': 'Modern Luxury • Italian Marble', 'ver': 'Rev 3 (Approved)'},
      {'room': 'Modular Kitchen', 'theme': 'Matte Charcoal & Champagne Gold Profile', 'ver': 'Rev 2 (Approved)'},
      {'room': 'Master Suite & Walk-in Wardrobe', 'theme': 'Warm Oak Veneer & Fluted Slats', 'ver': 'Rev 3 (Approved)'},
      {'room': 'Balcony Bar Lounge', 'theme': 'Biophilic Garden with Deck Flooring', 'ver': 'Rev 1 (Approved)'},
    ];

    final docs = [
      {'title': 'Complete 2D CAD Working Floor Plan', 'size': '18.4 MB PDF', 'date': 'Aug 05, 2026'},
      {'title': 'Detailed Electrical Conduit & Switch Layout', 'size': '6.2 MB PDF', 'date': 'Aug 10, 2026'},
      {'title': 'Plumbing & Drainage Line Schematic', 'size': '4.8 MB PDF', 'date': 'Aug 14, 2026'},
      {'title': 'Final Approved Itemized BOQ Contract', 'size': '3.1 MB PDF', 'date': 'Jul 28, 2026'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 3D Renders Grid
        Text(
          '3D PHOTOREALISTIC RENDERS & AR PREVIEWS',
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCol = constraints.maxWidth > 700;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: renders.map((r) {
                return SizedBox(
                  width: isTwoCol ? (constraints.maxWidth - AppSpacing.md) / 2 : double.infinity,
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: AppRadius.md,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.view_in_ar_rounded, size: 48, color: Colors.white70),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: AppBadge(
                                  label: r['ver']!,
                                  color: const Color(0xFF10B981),
                                  isPill: true,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: AppRadius.sm,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.open_in_full_rounded, color: Colors.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text('3D Lightbox', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          r['room']!,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          r['theme']!,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
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
        const SizedBox(height: AppSpacing.lg),

        // CAD Blueprint Vault
        Text(
          'APPROVED BLUEPRINTS & LEGAL CONTRACT VAULT',
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: docs.map((d) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            '${d['size']} • Uploaded ${d['date']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      text: 'Download',
                      prefixIcon: Icons.download_rounded,
                      variant: AppButtonVariant.secondary,
                      size: AppButtonSize.small,
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 6. PROJECT CHAT & MEETINGS
  // =========================================================================

  Widget _buildChatMeetingsScreen(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Chat Thread Box
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_rounded, color: Color(0xFF10B981), size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'PROJECT WHATSAPP THREAD: VILLA 402',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const AppBadge(
                    label: '3 NEW MESSAGES',
                    color: Color(0xFF10B981),
                    isPill: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                height: 200,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: AppRadius.md,
                ),
                child: ListView(
                  children: [
                    _chatBubble(
                      sender: 'Vikram Malhotra (PM)',
                      message: 'Good morning Sarah! Tile grouting sample for the master bath has arrived at the site. Ready for your review.',
                      time: '10:15 AM',
                      isMe: false,
                      isDark: isDark,
                    ),
                    _chatBubble(
                      sender: 'You',
                      message: 'Thanks Vikram, looks great! Pooja, did we finalize the fluted profile for the TV unit?',
                      time: '10:30 AM',
                      isMe: true,
                      isDark: isDark,
                    ),
                    _chatBubble(
                      sender: 'Pooja Hegde (Designer)',
                      message: 'Yes! 12mm fluted charcoal oak has been dispatched by the vendor today. You will love the finish.',
                      time: '10:45 AM',
                      isMe: false,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your message to the project team...',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        border: OutlineInputBorder(borderRadius: AppRadius.md),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    text: 'Send',
                    prefixIcon: Icons.send_rounded,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Meeting Scheduler Card
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.video_call_rounded, color: Color(0xFF6366F1), size: 26),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule 1-on-1 Virtual Design Review',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'Book a 30-minute Zoom or Google Meet walkthrough with Pooja Hegde or Vikram Malhotra.',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                text: 'Book Slot',
                prefixIcon: Icons.calendar_month_rounded,
                size: AppButtonSize.small,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chatBubble({
    required String sender,
    required String message,
    required String time,
    required bool isMe,
    required bool isDark,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFF10B981)
              : (isDark ? const Color(0xFF1F2937) : Colors.white),
          borderRadius: AppRadius.md,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                sender,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF10B981),
                ),
              ),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                time,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 10,
                  color: isMe ? Colors.white70 : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 7. BILLING & INVOICES
  // =========================================================================

  Widget _buildPaymentsScreen(BuildContext context, bool isDark) {
    final invoices = [
      {'num': 'INV-2026-0891', 'stage': 'Stage 1: Advance Booking & 2D Approval', 'amt': '₹4,85,000', 'status': 'PAID', 'date': 'Jul 28, 2026'},
      {'num': 'INV-2026-0924', 'stage': 'Stage 2: Civil Demolition & MEP Concealing', 'amt': '₹14,55,000', 'status': 'PAID', 'date': 'Aug 14, 2026'},
      {'num': 'INV-2026-1002', 'stage': 'Stage 3: False Ceiling & POP Completion', 'amt': '₹15,52,000', 'status': 'PAID', 'date': 'Aug 28, 2026'},
      {'num': 'INV-2026-1088', 'stage': 'Stage 4: Carpentry & Wardrobe Fabrication', 'amt': '₹5,00,000', 'status': 'DUE', 'date': 'Due Sept 12, 2026'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Commercial Ledger Banner
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _financeColumn('Total Contract Value', '₹48,50,000', const Color(0xFF10B981), isDark),
              _financeColumn('Total Amount Paid', '₹34,92,000 (72%)', const Color(0xFF6366F1), isDark),
              _financeColumn('Outstanding Balance', '₹13,58,000', const Color(0xFFF59E0B), isDark),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Active Due Invoice Action
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.payment_rounded, color: Color(0xFFF59E0B), size: 24),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Milestone 4 Payment Due: ₹5,00,000',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Invoice #INV-2026-1088 • Due Date: Sept 12, 2026 (UPI, Cards & NetBanking)',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppButton(
                text: 'Pay Now (Instant UPI)',
                prefixIcon: Icons.lock_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Invoices List
        Text(
          'GST TAX INVOICES & PAYMENT RECEIPTS',
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: invoices.map((inv) {
              final isPaid = inv['status'] == 'PAID';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isPaid ? Icons.check_circle_rounded : Icons.pending_rounded,
                          color: isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${inv['num']} • ${inv['stage']}',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              '${inv['amt']} • ${inv['date']}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppBadge(
                      label: inv['status']!,
                      color: isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      isPill: true,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _financeColumn(String title, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          title,
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 8. SNAGS & COMPLAINTS HUB
  // =========================================================================

  Widget _buildComplaintsScreen(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Raise Snag Ticket Card
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.report_problem_rounded, color: Color(0xFFEF4444), size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'RAISE A SNAG / DEFECT TICKET (48-HR RESOLUTION SLA)',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const AppBadge(
                    label: 'ZERO DEFECT GUARANTEE',
                    color: Color(0xFF10B981),
                    isPill: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Notice any scratch, misalignment, or finish defect? Log a ticket with photos and our site team will resolve it within 48 hours.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  AppButton(
                    text: 'Raise New Snag Ticket',
                    prefixIcon: Icons.add_photo_alternate_rounded,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Active Tickets SLA Tracker
        Text(
          'ACTIVE & RESOLVED SNAG TICKETS',
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _snagRow(
                ticket: 'TKT #SNG-408',
                area: 'Guest Bathroom Grouting Check',
                desc: 'Minor pinhole in marble tile silicone bead near shower enclosure',
                sla: 'Technician Assigned (SLA: 18 hrs left)',
                status: 'IN PROGRESS',
                statusColor: const Color(0xFF6366F1),
                isDark: isDark,
              ),
              const Divider(),
              _snagRow(
                ticket: 'TKT #SNG-402',
                area: 'Kitchen Overhead Cabinet Hinge',
                desc: 'Soft-close damper tension calibrated and tightened',
                sla: 'Resolved by Ramesh • Verified by Client',
                status: 'RESOLVED',
                statusColor: const Color(0xFF10B981),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _snagRow({
    required String ticket,
    required String area,
    required String desc,
    required String sla,
    required String status,
    required Color statusColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$ticket • $area',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppBadge(label: status, color: statusColor, isPill: true),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                Text(
                  sla,
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 9. FEEDBACK & 360° RATINGS
  // =========================================================================

  Widget _buildRatingsScreen(BuildContext context, bool isDark) {
    final dimensions = [
      {'dim': 'Design & Architectural Planning', 'score': '5.0', 'stars': 5},
      {'dim': 'Workmanship & Execution Quality', 'score': '4.8', 'stars': 5},
      {'dim': 'Site Supervisor & Labour Behaviour', 'score': '5.0', 'stars': 5},
      {'dim': 'Material Quality & Grade Transparency', 'score': '4.9', 'stars': 5},
      {'dim': 'Communication & Timely Updates', 'score': '5.0', 'stars': 5},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '360° MULTI-DIMENSIONAL PROJECT RATING',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your continuous rating helps us maintain industry-leading quality benchmarks across all trade teams.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...dimensions.map((d) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        d['dim'] as String,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20);
                          }),
                          const SizedBox(width: 8),
                          Text(
                            d['score'] as String,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'Submit Feedback & NPS Score',
                prefixIcon: Icons.rate_review_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 10. CLIENT AI STUDIO (4 Dedicated Tools)
  // =========================================================================

  Widget _buildAiSuiteScreen(BuildContext context, bool isDark) {
    final aiTools = [
      {
        'title': 'AI Room 3D Generator (50/50 Dual View)',
        'desc': 'Upload your raw site photo and generate a photo-styled furnished 3D render in seconds.',
        'icon': Icons.auto_awesome_rounded,
        'badge': 'FREE UNLIMITED',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'AI Vastu Consultant & Zone Analyzer',
        'desc': 'Scan floor plan for Brahmasthan & directional energy scores with Vedic remedies.',
        'icon': Icons.compass_calibration_rounded,
        'badge': 'VASTU 94/100',
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'AI Furniture & Interior Budget Estimator',
        'desc': 'Interactive material calculator comparing Commercial vs HDHMR vs Acrylic finish.',
        'icon': Icons.calculate_rounded,
        'badge': 'INSTANT QUOTE',
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'AI Doubt Solver (Technical Advice)',
        'desc': 'Instant answers to construction & materials questions (Rs. 50/question).',
        'icon': Icons.psychology_rounded,
        'badge': '₹50 / QUESTION',
        'color': const Color(0xFF0EA5E9),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCol = constraints.maxWidth > 700;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: aiTools.map((tool) {
                final toolColor = tool['color'] as Color;
                return SizedBox(
                  width: isTwoCol ? (constraints.maxWidth - AppSpacing.md) / 2 : double.infinity,
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: toolColor.withValues(alpha: 0.15),
                                borderRadius: AppRadius.md,
                              ),
                              child: Icon(tool['icon'] as IconData, color: toolColor, size: 24),
                            ),
                            AppBadge(
                              label: tool['badge'] as String,
                              color: toolColor,
                              isPill: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          tool['title'] as String,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tool['desc'] as String,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppButton(
                          text: 'Launch Tool',
                          prefixIcon: Icons.play_arrow_rounded,
                          size: AppButtonSize.small,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // 11. MARKETPLACE & SERVICES
  // =========================================================================

  Widget _buildMarketplaceScreen(BuildContext context, bool isDark) {
    final services = [
      {
        'title': 'Digital Interior & Vastu Handbooks',
        'desc': 'Download comprehensive styling guides, color palettes & Vastu rules.',
        'icon': Icons.menu_book_rounded,
        'badge': 'FROM ₹299',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Home Decor & Materials',
        'desc': 'Direct manufacturer pricing on designer chandeliers, Italian marble & sofa fabrics.',
        'icon': Icons.shopping_bag_rounded,
        'badge': 'UP TO 40% OFF',
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'Rental & Properties',
        'desc': 'Verified gated community homes & luxury rentals (Unlock contacts for ₹500).',
        'icon': Icons.holiday_village_rounded,
        'badge': '₹500 / UNLOCK',
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Hire On-Demand Vetted Labour',
        'desc': 'Book certified master carpenters, plumbers, electricians & deep cleaning teams.',
        'icon': Icons.engineering_rounded,
        'badge': 'BACKGROUND VERIFIED',
        'color': const Color(0xFF0EA5E9),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCol = constraints.maxWidth > 700;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: services.map((srv) {
                final srvColor = srv['color'] as Color;
                return SizedBox(
                  width: isTwoCol ? (constraints.maxWidth - AppSpacing.md) / 2 : double.infinity,
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: srvColor.withValues(alpha: 0.15),
                                borderRadius: AppRadius.md,
                              ),
                              child: Icon(srv['icon'] as IconData, color: srvColor, size: 24),
                            ),
                            AppBadge(
                              label: srv['badge'] as String,
                              color: srvColor,
                              isPill: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          srv['title'] as String,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          srv['desc'] as String,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppButton(
                          text: 'Explore Catalog',
                          prefixIcon: Icons.arrow_forward_rounded,
                          size: AppButtonSize.small,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required double width,
    required bool isDark,
  }) {
    return SizedBox(
      width: width,
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: AppRadius.md,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    value,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    subtext,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
