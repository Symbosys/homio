import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'client_models.dart';

// ============================================================================
// 1. SEMANTIC STATUS BADGE
// ============================================================================

class CustomerStatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const CustomerStatusBadge({
    super.key,
    required this.status,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    final lower = status.toLowerCase();

    if (lower.contains('complete') || lower.contains('accepted') || lower.contains('paid') || lower.contains('booked')) {
      bg = const Color(0xFF10B981).withValues(alpha: 0.12);
      fg = const Color(0xFF059669);
      icon = Icons.check_circle_rounded;
    } else if (lower.contains('in progress') || lower.contains('execution') || lower.contains('qualified') || lower.contains('active')) {
      bg = const Color(0xFF3B82F6).withValues(alpha: 0.12);
      fg = const Color(0xFF2563EB);
      icon = Icons.timelapse_rounded;
    } else if (lower.contains('awaiting') || lower.contains('approval') || lower.contains('pending') || lower.contains('due')) {
      bg = const Color(0xFFF59E0B).withValues(alpha: 0.12);
      fg = const Color(0xFFD97706);
      icon = Icons.pending_actions_rounded;
    } else if (lower.contains('delayed') || lower.contains('rejected') || lower.contains('expired')) {
      bg = const Color(0xFFEF4444).withValues(alpha: 0.12);
      fg = const Color(0xFFDC2626);
      icon = Icons.warning_amber_rounded;
    } else {
      bg = const Color(0xFF64748B).withValues(alpha: 0.12);
      fg = const Color(0xFF475569);
      icon = Icons.radio_button_unchecked_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.fullVal),
        border: Border.all(color: fg.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmall ? 11 : 13, color: fg),
          const SizedBox(width: 5),
          Text(
            status,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isSmall ? 10.5 : 12,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. ACTION REQUIRED CARD
// ============================================================================

class ActionRequiredCard extends StatelessWidget {
  final CustomerActionItem item;
  final VoidCallback onAction;

  const ActionRequiredCard({
    super.key,
    required this.item,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color accentColor;
    IconData icon;
    switch (item.type) {
      case ActionItemType.approval:
        accentColor = const Color(0xFF8B5CF6);
        icon = Icons.verified_rounded;
        break;
      case ActionItemType.payment:
        accentColor = const Color(0xFFF59E0B);
        icon = Icons.account_balance_wallet_rounded;
        break;
      case ActionItemType.quotation:
        accentColor = const Color(0xFF10B981);
        icon = Icons.receipt_long_rounded;
        break;
      case ActionItemType.meeting:
        accentColor = const Color(0xFF06B6D4);
        icon = Icons.video_call_rounded;
        break;
      case ActionItemType.material:
        accentColor = const Color(0xFFEC4899);
        icon = Icons.palette_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B).withValues(alpha: 0.2) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
          top: BorderSide(color: accentColor.withValues(alpha: 0.35), width: 1.2),
          right: BorderSide(color: accentColor.withValues(alpha: 0.35), width: 1.2),
          bottom: BorderSide(color: accentColor.withValues(alpha: 0.35), width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Category Badge + Deadline
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 12, color: accentColor),
                      const SizedBox(width: 4),
                      Text(
                        item.title.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (item.deadline != null) ...[
                  Icon(Icons.schedule_rounded, size: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Text(
                    item.deadline!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              item.subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              item.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                height: 1.4,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 12),

            // Footer Row: Associated Project & CTA
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.apartment_rounded, size: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                          const SizedBox(width: 4),
                          Text(
                            item.projectName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedAppRadius.md,
                            elevation: 0,
                          ),
                          onPressed: onAction,
                          child: Text(
                            item.actionLabel,
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Icon(Icons.apartment_rounded, size: 13, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.projectName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          shape: RoundedAppRadius.md,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          elevation: 0,
                        ),
                        onPressed: onAction,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.actionLabel,
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 3. PROGRESS BAR & STAGE STEPPER
// ============================================================================

class CustomerProgressBar extends StatelessWidget {
  final double progress;
  final String stageLabel;
  final String? nextMilestone;
  final Color? color;

  const CustomerProgressBar({
    super.key,
    required this.progress,
    required this.stageLabel,
    this.nextMilestone,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = color ?? const Color(0xFF10B981);
    final percentInt = (progress * 100).toInt();

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
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  stageLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Text(
              '$percentInt%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: activeColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.fullVal),
          child: Container(
            height: 8,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      activeColor,
                      activeColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (nextMilestone != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'Next: ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              Expanded(
                child: Text(
                  nextMilestone!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ============================================================================
// 4. VERTICAL ACTIVITY TIMELINE
// ============================================================================

class CustomerTimelineView extends StatelessWidget {
  final List<CustomerActivityItem> activities;
  final bool compact;

  const CustomerTimelineView({
    super.key,
    required this.activities,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        alignment: Alignment.center,
        child: Text(
          'No recent activity recorded.',
          style: GoogleFonts.plusJakartaSans(
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            fontSize: 13,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final act = activities[index];
        final isLast = index == activities.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Node & Connecting Line
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: act.iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: act.iconColor.withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: Icon(act.icon, size: 15, color: act.iconColor),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: compact ? 36 : 48,
                    color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Right Content Area
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : (compact ? 12 : 18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            act.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          act.timestamp,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      act.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                    ),
                    if (act.hasAttachments) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.attach_file_rounded, size: 12, color: Color(0xFF6366F1)),
                            const SizedBox(width: 4),
                            Text(
                              '${act.attachmentCount} photos attached',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// 5. CUSTOMER EMPTY STATE
// ============================================================================

class CustomerEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const CustomerEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: isDark ? AppColors.darkSubtext : const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                color: isDark ? AppColors.darkSubtext : const Color(0xFF64748B),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedAppRadius.md,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 0,
                  ),
                  onPressed: onAction,
                  child: Text(
                    actionLabel!,
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 6. CUSTOMER DETAIL SECTION CARD
// ============================================================================

class CustomerDetailSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const CustomerDetailSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 7. MORE BOTTOM SHEET (MOBILE 5TH TAB)
// ============================================================================

class CustomerMoreBottomSheet extends StatelessWidget {
  const CustomerMoreBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CustomerMoreBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final modules = [
      (
        'Assigned Team',
        'Direct contact with your PM & Senior Designer',
        Icons.badge_rounded,
        '/client/team',
        const Color(0xFF6366F1),
      ),
      (
        'Live Site Progress',
        'Daily photo feeds & supervisor checklists',
        Icons.camera_indoor_rounded,
        '/client/site-progress',
        const Color(0xFF10B981),
      ),
      (
        'Stage Work Approvals',
        'Digital sign-offs & milestone certificates',
        Icons.verified_rounded,
        '/client/approvals',
        const Color(0xFF8B5CF6),
      ),
      (
        '3D Designs & CAD Vault',
        'Photorealistic renders & revision requests',
        Icons.view_in_ar_rounded,
        '/client/designs',
        const Color(0xFFEC4899),
      ),
      (
        'Project Chat & Meetings',
        'Team conversation & review scheduler',
        Icons.forum_rounded,
        '/client/chat',
        const Color(0xFF06B6D4),
      ),
      (
        'Billing & Invoices',
        'Payment links, GST invoices & ledger',
        Icons.account_balance_wallet_rounded,
        '/client/payments',
        const Color(0xFFF59E0B),
      ),
      (
        'Snags & 10-Yr Warranty',
        'Defect tickets & warranty certificates',
        Icons.support_agent_rounded,
        '/client/complaints',
        const Color(0xFFEF4444),
      ),
      (
        'Feedback & 360° Ratings',
        'Rate design, workmanship & materials',
        Icons.star_rate_rounded,
        '/client/ratings',
        const Color(0xFFEAB308),
      ),
      (
        'Client AI Studio',
        'Instant 3D room generator & Vastu score',
        Icons.auto_awesome_rounded,
        '/client/ai-suite',
        const Color(0xFF6366F1),
      ),
      (
        'Marketplace & Stores',
        'Curated home decor & vetted labour hire',
        Icons.storefront_rounded,
        '/client/marketplace',
        const Color(0xFF0D9488),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xlVal)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'More Services & Tools',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Grid of modules
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.2,
                ),
                itemCount: modules.length,
                itemBuilder: (context, idx) {
                  final item = modules[idx];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.go(item.$4);
                    },
                    borderRadius: AppRadius.md,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.md,
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: item.$5.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(item.$3, size: 16, color: item.$5),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.$1,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 8. QUOTATION ACCEPTANCE MODAL
// ============================================================================

class QuotationAcceptanceModal extends StatefulWidget {
  final CustomerQuotation quotation;
  final VoidCallback onAccepted;

  const QuotationAcceptanceModal({
    super.key,
    required this.quotation,
    required this.onAccepted,
  });

  static Future<void> show(BuildContext context, {required CustomerQuotation quotation, required VoidCallback onAccepted}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuotationAcceptanceModal(
        quotation: quotation,
        onAccepted: onAccepted,
      ),
    );
  }

  @override
  State<QuotationAcceptanceModal> createState() => _QuotationAcceptanceModalState();
}

class _QuotationAcceptanceModalState extends State<QuotationAcceptanceModal> {
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xlVal)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Accept Official Quotation',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Quotation #${widget.quotation.id}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Summary Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Project Value',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
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
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Booking Advance (10%)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                        ),
                      ),
                      Text(
                        '₹1,28,000',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Validity',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                        ),
                      ),
                      Text(
                        'Valid until 30 Sep 2026',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Terms checkbox
            InkWell(
              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
              borderRadius: BorderRadius.circular(6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    activeColor: const Color(0xFF10B981),
                    onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'I confirm that I have reviewed the scope, BOQ specifications, payment schedule, and agree to the applicable terms & conditions.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedAppRadius.md,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedAppRadius.md,
                        elevation: 0,
                      ),
                      onPressed: !_agreedToTerms || _isSubmitting
                          ? null
                          : () async {
                              final nav = Navigator.of(context);
                              setState(() => _isSubmitting = true);
                              await Future.delayed(const Duration(milliseconds: 600));
                              if (!mounted) return;
                              nav.pop();
                              widget.onAccepted();
                            },
                      child: _isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              'Accept & Proceed',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13.5),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 9. REQUEST CHANGES MODAL
// ============================================================================

class RequestChangesModal extends StatefulWidget {
  final CustomerQuotation quotation;
  final VoidCallback onSubmit;

  const RequestChangesModal({
    super.key,
    required this.quotation,
    required this.onSubmit,
  });

  static Future<void> show(BuildContext context, {required CustomerQuotation quotation, required VoidCallback onSubmit}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: RequestChangesModal(
          quotation: quotation,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  @override
  State<RequestChangesModal> createState() => _RequestChangesModalState();
}

class _RequestChangesModalState extends State<RequestChangesModal> {
  String _selectedReason = 'Budget / Cost Adjustment';
  final TextEditingController _commentCtrl = TextEditingController();
  String _callbackPreference = 'Morning (10 AM – 1 PM)';
  bool _isSubmitting = false;

  final List<String> _reasons = [
    'Budget / Cost Adjustment',
    'Design / Layout Revision',
    'Material / Brand Specification Change',
    'Room / Scope Addition or Removal',
    'Timeline / Handover Date Query',
    'Other Clarification',
  ];

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xlVal)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Request Changes or Clarification',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Let our design and estimation team know what modifications you would like.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 16),

              // Reason Dropdown
              Text(
                'Primary Reason',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedReason,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: _reasons
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedReason = val);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: AppRadius.md),
                ),
              ),
              const SizedBox(height: 14),

              // Comment field
              Text(
                'Details & Requested Changes',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _commentCtrl,
                maxLines: 3,
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g., Can we compare the cost if we switch to Matte Acrylic in the kitchen?',
                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: AppRadius.md),
                ),
              ),
              const SizedBox(height: 14),

              // Callback time
              Text(
                'Preferred Callback Window',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['Morning (10 AM – 1 PM)', 'Afternoon (2 PM – 5 PM)', 'Evening (6 PM – 8 PM)']
                    .map((time) => ChoiceChip(
                          label: Text(time, style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                          selected: _callbackPreference == time,
                          selectedColor: const Color(0xFF4F46E5).withValues(alpha: 0.15),
                          onSelected: (sel) {
                            if (sel) setState(() => _callbackPreference = time);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Submit Button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedAppRadius.md,
                        minimumSize: const Size.fromHeight(44),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        shape: RoundedAppRadius.md,
                        minimumSize: const Size.fromHeight(44),
                        elevation: 0,
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              final nav = Navigator.of(context);
                              setState(() => _isSubmitting = true);
                              await Future.delayed(const Duration(milliseconds: 600));
                              if (!mounted) return;
                              nav.pop();
                              widget.onSubmit();
                            },
                      child: _isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Submit Request', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 10. SHARED PROJECT CONTEXT HEADER & SUB-NAVIGATION
// ============================================================================

class CustomerProjectContextBar extends StatelessWidget {
  final String activeTab; // 'overview', 'team', 'progress', 'stages', 'approvals', 'designs'
  final CustomerProject? project;

  const CustomerProjectContextBar({
    super.key,
    required this.activeTab,
    this.project,
  });

  @override
  Widget build(BuildContext context) {
    final proj = project ?? ClientDataRepository.activeProject;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 640;

    final tabs = [
      ('overview', 'Overview', Icons.dashboard_outlined, '/client/projects'),
      ('team', 'Assigned Team', Icons.badge_outlined, '/client/team'),
      ('progress', 'Live Progress', Icons.trending_up_rounded, '/client/site-progress'),
      ('approvals', 'Stages & Approvals', Icons.rule_folder_outlined, '/client/approvals'),
      ('designs', 'Designs & CAD', Icons.view_in_ar_rounded, '/client/designs'),
      ('materials', 'Materials', Icons.inventory_2_outlined, '/client/materials'),
      ('payments', 'Payments & Billing', Icons.receipt_long_outlined, '/client/payments'),
      ('chat', 'Chat & Meetings', Icons.chat_bubble_outline_rounded, '/client/chat'),
      ('support', 'Support & Complaints', Icons.support_agent_rounded, '/client/complaints'),
    ];

    if (isMobile) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Compact Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.go('/client/projects'),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proj.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              proj.id,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${(proj.overallProgress * 100).toInt()}% Done',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomerStatusBadge(status: proj.status, isSmall: true),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Horizontal Scrollable Chip Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: tabs.map((tab) {
                  final isSelected = activeTab == tab.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () {
                        if (!isSelected) context.go(tab.$4);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4F46E5)
                              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tab.$3,
                              size: 13,
                              color: isSelected ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              tab.$2,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    // Desktop Layout
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Project Meta Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Project Avatar
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                    borderRadius: AppRadius.md,
                  ),
                  child: const Icon(Icons.home_work_rounded, color: Color(0xFF4F46E5), size: 24),
                ),
                const SizedBox(width: 14),

                // Project Title & Meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            proj.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              proj.id,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomerStatusBadge(status: proj.status, isSmall: true),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                          const SizedBox(width: 4),
                          Text(
                            proj.fullAddress,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Progress Indicator
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Overall Progress: ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                          ),
                        ),
                        Text(
                          '${(proj.overallProgress * 100).toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: proj.overallProgress,
                          minHeight: 6,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),

          // Sub-Navigation Tabs Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: tabs.map((tab) {
                final isSelected = activeTab == tab.$1;
                return InkWell(
                  onTap: () {
                    if (!isSelected) context.go(tab.$4);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          tab.$3,
                          size: 15,
                          color: isSelected ? const Color(0xFF4F46E5) : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tab.$2,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 11. FULLSCREEN IMAGE VIEWER MODAL
// ============================================================================

class FullscreenImageViewerModal extends StatelessWidget {
  final String title;
  final String caption;
  final String zone;
  final String uploader;
  final String timestamp;
  final Color? placeholderGradientStart;
  final Color? placeholderGradientEnd;

  const FullscreenImageViewerModal({
    super.key,
    required this.title,
    required this.caption,
    required this.zone,
    required this.uploader,
    required this.timestamp,
    this.placeholderGradientStart,
    this.placeholderGradientEnd,
  });

  static void show(BuildContext context, {
    required String title,
    required String caption,
    required String zone,
    required String uploader,
    required String timestamp,
    Color? placeholderGradientStart,
    Color? placeholderGradientEnd,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (ctx) => FullscreenImageViewerModal(
        title: title,
        caption: caption,
        zone: zone,
        uploader: uploader,
        timestamp: timestamp,
        placeholderGradientStart: placeholderGradientStart,
        placeholderGradientEnd: placeholderGradientEnd,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860, maxHeight: 720),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0B0F19),
              borderRadius: AppRadius.lg,
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          zone.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF60A5FA),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF1E293B), height: 1),

                // Image Canvas
                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 3.5,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.md,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              placeholderGradientStart ?? const Color(0xFF1E293B),
                              placeholderGradientEnd ?? const Color(0xFF334155),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_indoor_rounded, size: 64, color: Colors.white38),
                              const SizedBox(height: 12),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Pinch or double tap to zoom (Simulated 4K Site Photo)',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white38,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Metadata Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF111827),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caption,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: const Color(0xFFCBD5E1),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploaded by $uploader • $timestamp',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF64748B)),
                          ),
                          Text(
                            'Internal QA Certified',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 12. VIDEO PLAYER PREVIEW MODAL
// ============================================================================

class VideoPlayerPreviewModal extends StatefulWidget {
  final String title;
  final String duration;
  final String zone;
  final String uploader;
  final String caption;

  const VideoPlayerPreviewModal({
    super.key,
    required this.title,
    required this.duration,
    required this.zone,
    required this.uploader,
    required this.caption,
  });

  static void show(BuildContext context, {
    required String title,
    required String duration,
    required String zone,
    required String uploader,
    required String caption,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (ctx) => VideoPlayerPreviewModal(
        title: title,
        duration: duration,
        zone: zone,
        uploader: uploader,
        caption: caption,
      ),
    );
  }

  @override
  State<VideoPlayerPreviewModal> createState() => _VideoPlayerPreviewModalState();
}

class _VideoPlayerPreviewModalState extends State<VideoPlayerPreviewModal> {
  bool _isPlaying = true;
  double _progress = 0.35;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780, maxHeight: 580),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: AppRadius.lg,
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.videocam_rounded, color: Color(0xFFEF4444), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF1E293B), height: 1),

                // Video Screen Canvas
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isPlaying ? Icons.play_circle_fill_rounded : Icons.pause_circle_filled_rounded,
                                size: 68,
                                color: const Color(0xFF4F46E5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'HOMIO Verified Site Recording',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.zone} • Duration ${widget.duration}',
                                style: GoogleFonts.plusJakartaSans(color: Colors.white38, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                iconSize: 20,
                                icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white),
                                onPressed: () => setState(() => _isPlaying = !_isPlaying),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                    trackHeight: 3,
                                  ),
                                  child: Slider(
                                    value: _progress,
                                    activeColor: const Color(0xFF4F46E5),
                                    inactiveColor: Colors.white24,
                                    onChanged: (val) => setState(() => _progress = val),
                                  ),
                                ),
                              ),
                              Text(
                                '0:12 / ${widget.duration}',
                                style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Video Caption
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF111827),
                  child: Text(
                    widget.caption,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: const Color(0xFFCBD5E1)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 13. FULLSCREEN DESIGN APPROVAL REVIEW MODAL
// ============================================================================

class DesignApprovalReviewModal extends StatefulWidget {
  final CustomerApprovalItem approval;
  final VoidCallback onApproved;
  final VoidCallback onChangesRequested;

  const DesignApprovalReviewModal({
    super.key,
    required this.approval,
    required this.onApproved,
    required this.onChangesRequested,
  });

  static void show(BuildContext context, {
    required CustomerApprovalItem approval,
    required VoidCallback onApproved,
    required VoidCallback onChangesRequested,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => DesignApprovalReviewModal(
        approval: approval,
        onApproved: onApproved,
        onChangesRequested: onChangesRequested,
      ),
    );
  }

  @override
  State<DesignApprovalReviewModal> createState() => _DesignApprovalReviewModalState();
}

class _DesignApprovalReviewModalState extends State<DesignApprovalReviewModal> {
  void _confirmApproval() {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Row(
            children: [
              const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 22),
              const SizedBox(width: 8),
              Text(
                'Confirm Approval',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are approving:',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.approval.title} (${widget.approval.version})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: AppRadius.md,
                ),
                child: Text(
                  'Once confirmed, this design version is locked and certified for procurement & site fabrication.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF059669)),
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
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedAppRadius.md,
              ),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
                if (widget.approval.linkedDesignId != null) {
                  ClientDataRepository.approveDesign(widget.approval.linkedDesignId!);
                } else {
                  ClientDataRepository.approveStageWork(widget.approval.id);
                }
                widget.onApproved();
                Navigator.of(context).pop(); // Close review modal
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF10B981),
                    content: Text(
                      'Success! "${widget.approval.title}" has been approved.',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              },
              child: Text('Confirm Sign-Off', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  void _openRequestChangesForm() {
    final reasonCtrl = TextEditingController();
    final commentsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: Color(0xFFF59E0B), size: 22),
              const SizedBox(width: 8),
              Text(
                'Request Revision',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason for Change (Required)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: reasonCtrl,
                  decoration: InputDecoration(
                    hintText: 'e.g., Wood finish preference, cove lighting height',
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: AppRadius.md),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Specific Details & Comments (Required)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: commentsCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe exactly what you would like modified...',
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: AppRadius.md),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                shape: RoundedAppRadius.md,
              ),
              onPressed: () {
                if (reasonCtrl.text.trim().isEmpty || commentsCtrl.text.trim().isEmpty) return;
                Navigator.of(ctx).pop();
                if (widget.approval.linkedDesignId != null) {
                  ClientDataRepository.requestDesignChanges(
                    widget.approval.linkedDesignId!,
                    reasonCtrl.text.trim(),
                    commentsCtrl.text.trim(),
                  );
                } else {
                  ClientDataRepository.requestStageChanges(
                    widget.approval.id,
                    reasonCtrl.text.trim(),
                    commentsCtrl.text.trim(),
                  );
                }
                widget.onChangesRequested();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFFF59E0B),
                    content: Text(
                      'Revision request submitted. Your team will update this within 24 hours.',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              },
              child: Text('Submit Revision', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      insetPadding: EdgeInsets.all(isDesktop ? 24 : 12),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 840),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.approval.version,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.approval.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Submitted by ${widget.approval.submittedBy} • ${widget.approval.submissionDate}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomerStatusBadge(status: widget.approval.status, isSmall: true),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Visual Preview Canvas
                    Container(
                      height: isDesktop ? 300 : 200,
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.lg,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E1B4B), Color(0xFF4338CA)],
                        ),
                        border: Border.all(color: const Color(0xFF3730A3)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.view_in_ar_rounded, size: 54, color: Colors.white60),
                            const SizedBox(height: 10),
                            Text(
                              widget.approval.previewTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Interactive 3D / High-Resolution Certified Drawing',
                              style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Specifications Section
                    Text(
                      'Technical Specifications & Finishes',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.md,
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.approval.specifications.map((spec) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    spec,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Engineering & QA Note
                    Text(
                      'Supervisor & QA Verification Note',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
                        borderRadius: AppRadius.md,
                        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        widget.approval.engineeringNote,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          height: 1.4,
                          color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Revision Timeline
                    Text(
                      'Revision History',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...widget.approval.revisionHistory.map((rev) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                rev.version,
                                style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700),
                              ),
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
                                        rev.title,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      Text(
                                        rev.date,
                                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    rev.notes,
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
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Sticky Bottom Action Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: widget.approval.isApproved
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: AppRadius.md,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Design Approved & Locked for Site Execution',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFF59E0B),
                                side: const BorderSide(color: Color(0xFFF59E0B)),
                                shape: RoundedAppRadius.md,
                              ),
                              onPressed: _openRequestChangesForm,
                              icon: const Icon(Icons.edit_note_rounded, size: 16),
                              label: Text(
                                'Request Changes',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                shape: RoundedAppRadius.md,
                              ),
                              onPressed: _confirmApproval,
                              icon: const Icon(Icons.verified_rounded, size: 16),
                              label: Text(
                                'Approve Design',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                          ),
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

// ============================================================================
// 14. CUSTOMER PAYMENT CHECKOUT MODAL
// ============================================================================

class CustomerPaymentCheckoutModal extends StatefulWidget {
  final CustomerPaymentTranche tranche;
  final VoidCallback onPaid;

  const CustomerPaymentCheckoutModal({
    super.key,
    required this.tranche,
    required this.onPaid,
  });

  static void show(BuildContext context, {
    required CustomerPaymentTranche tranche,
    required VoidCallback onPaid,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CustomerPaymentCheckoutModal(
        tranche: tranche,
        onPaid: onPaid,
      ),
    );
  }

  @override
  State<CustomerPaymentCheckoutModal> createState() => _CustomerPaymentCheckoutModalState();
}

class _CustomerPaymentCheckoutModalState extends State<CustomerPaymentCheckoutModal> {
  String _selectedMethod = 'UPI';
  bool _isProcessing = false;
  bool _isSuccess = false;
  String? _transactionId;

  void _handlePay() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final txn = 'HOM-TXN-${DateTime.now().millisecondsSinceEpoch}';
    ClientDataRepository.payTranche(widget.tranche.id, _selectedMethod);
    setState(() {
      _isProcessing = false;
      _isSuccess = true;
      _transactionId = txn;
    });
    widget.onPaid();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      insetPadding: EdgeInsets.all(isDesktop ? 24 : 14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: _isSuccess
              ? _buildSuccessView(context, isDark)
              : _isProcessing
                  ? _buildProcessingView(context, isDark)
                  : _buildReviewView(context, isDark),
        ),
      ),
    );
  }

  Widget _buildReviewView(BuildContext context, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOMIO Secure Payment Gateway',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '256-Bit Bank-Grade Encryption • Instant Receipt',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),

        // Tranche Details Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.tranche.stageTitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.tranche.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Base Taxable Value', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                  Text('₹${widget.tranche.amount.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('GST (18% Input Credit)', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted)),
                  Text('₹${widget.tranche.gstAmount.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payable',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '₹${widget.tranche.totalAmount.toInt()}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Choose Payment Method
        Text(
          'Choose Payment Mode',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),

        ...[
          ('UPI', 'Google Pay, PhonePe, Paytm, BHIM', Icons.qr_code_2_rounded),
          ('Card', 'Credit / Debit Card (Visa, Master, RuPay)', Icons.credit_card_rounded),
          ('Net Banking', 'HDFC, ICICI, SBI, Axis, Kotak', Icons.account_balance_rounded),
          ('NEFT / RTGS', 'Direct Virtual Account Transfer', Icons.swap_horiz_rounded),
        ].map((m) {
          final isSel = _selectedMethod == m.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: InkWell(
              onTap: () => setState(() => _selectedMethod = m.$1),
              borderRadius: AppRadius.md,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSel
                      ? const Color(0xFF6366F1).withValues(alpha: 0.1)
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isSel ? const Color(0xFF6366F1) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    width: isSel ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(m.$3, size: 20, color: isSel ? const Color(0xFF6366F1) : const Color(0xFF64748B)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.$1,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                              color: isSel ? const Color(0xFF6366F1) : (isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                          ),
                          Text(m.$2, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSel ? const Color(0xFF6366F1) : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: isSel
                          ? Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF6366F1),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 18),

        // Pay CTA Button
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedAppRadius.md,
              elevation: 0,
            ),
            onPressed: _handlePay,
            icon: const Icon(Icons.lock_outline_rounded, size: 18),
            label: Text(
              'Pay ₹${widget.tranche.totalAmount.toInt()} via $_selectedMethod',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingView(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Processing Secure Payment...',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Communicating with bank payment gateway. Please do not close this window.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 38),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Payment Successful!',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${widget.tranche.totalAmount.toInt()} has been credited to your project ledger.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transaction Ref', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF64748B))),
                  Text(_transactionId ?? 'HOM-TXN-2026', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Mode', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF64748B))),
                  Text(_selectedMethod, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Project', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF64748B))),
                  Text('3BHK Residence (#HOM-0084)', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        SizedBox(
          height: 44,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedAppRadius.md,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Done • Return to Payments',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 15. CUSTOMER INVOICE VIEWER MODAL
// ============================================================================

class CustomerInvoiceViewerModal extends StatelessWidget {
  final CustomerInvoice invoice;

  const CustomerInvoiceViewerModal({super.key, required this.invoice});

  static void show(BuildContext context, {required CustomerInvoice invoice}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CustomerInvoiceViewerModal(invoice: invoice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 700;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      insetPadding: EdgeInsets.all(isDesktop ? 24 : 12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 860),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Modal Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF6366F1), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Official Tax Invoice • ${invoice.invoiceNumber}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  CustomerStatusBadge(status: invoice.isPaid ? 'Paid' : 'Payment Due', isSmall: true),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable Invoice Sheet
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.lg,
                    border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Letterhead
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'HOMIO INTERIORS & ARCHITECTURE PVT LTD',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF6366F1),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'GSTIN: 20AAACH1234F1Z5 • PAN: AAACH1234F\nHOMIO Tech Park, Saraidhela Main Road, Dhanbad, Jharkhand - 826004\nEmail: accounts@homio.in • Phone: +91 98765 43210',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, height: 1.4, color: const Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'TAX INVOICE',
                                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                              Text('Invoice No: ${invoice.invoiceNumber}', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                              Text('Date: ${invoice.issueDate}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF64748B))),
                              Text('Due Date: ${invoice.dueDate}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFFDC2626))),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Billed to
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('BILLED TO (HOMEOWNER):', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, color: const Color(0xFF64748B))),
                                const SizedBox(height: 4),
                                Text('Amit Kumar', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                                Text('Flat 402, Tower B, Royal Palms, Saraidhela\nDhanbad, Jharkhand - 826004\nPhone: +91 98765 43210', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, height: 1.4, color: const Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('PROJECT REFERENCE:', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, color: const Color(0xFF64748B))),
                                const SizedBox(height: 4),
                                Text('3BHK Residence (#HOM-PROJ-2026-0084)', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                                Text(invoice.stageName, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF64748B))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Items Table
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                              child: Row(
                                children: [
                                  SizedBox(width: 30, child: Text('#', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700))),
                                  Expanded(child: Text('Description', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700))),
                                  SizedBox(width: 40, child: Text('Qty', textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700))),
                                  SizedBox(width: 80, child: Text('Rate', textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700))),
                                  SizedBox(width: 80, child: Text('Amount', textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700))),
                                ],
                              ),
                            ),
                            ...invoice.lineItems.map((item) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 30, child: Text('${item.itemNo}', style: GoogleFonts.plusJakartaSans(fontSize: 11))),
                                    Expanded(
                                      child: Text(
                                        item.description,
                                        style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(width: 40, child: Text('${item.quantity.toInt()}', textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 11))),
                                    SizedBox(width: 80, child: Text('₹${item.rate.toInt()}', textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 11))),
                                    SizedBox(width: 80, child: Text('₹${item.amount.toInt()}', textAlign: TextAlign.right, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700))),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Totals Summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 240,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Taxable Subtotal:', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF64748B))),
                                    Text('₹${invoice.taxableAmount.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('CGST (9%):', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF64748B))),
                                    Text('₹${(invoice.gstAmount / 2).toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SGST (9%):', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF64748B))),
                                    Text('₹${(invoice.gstAmount / 2).toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Divider(height: 1),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Amount:', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800)),
                                    Text('₹${invoice.totalAmount.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF10B981))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),

            // Modal Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(shape: RoundedAppRadius.md),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: Text('Close', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      shape: RoundedAppRadius.md,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF10B981),
                          content: Text('Downloading "${invoice.pdfFileName}"...', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: Text('Download Tax Invoice (PDF)', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
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

// ============================================================================
// 16. CUSTOMER MATERIAL DETAIL MODAL
// ============================================================================

class CustomerMaterialDetailModal extends StatelessWidget {
  final CustomerMaterialItem material;
  final VoidCallback onApproved;
  final VoidCallback onChangesRequested;

  const CustomerMaterialDetailModal({
    super.key,
    required this.material,
    required this.onApproved,
    required this.onChangesRequested,
  });

  static void show(BuildContext context, {
    required CustomerMaterialItem material,
    required VoidCallback onApproved,
    required VoidCallback onChangesRequested,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CustomerMaterialDetailModal(
        material: material,
        onApproved: onApproved,
        onChangesRequested: onChangesRequested,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 640;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      insetPadding: EdgeInsets.all(isDesktop ? 24 : 14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Modal Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      material.category,
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF6366F1)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      material.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ),
                  CustomerStatusBadge(status: material.status, isSmall: true),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable Dossier Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Visual Preview Canvas
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.lg,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [material.imageGradientStart, material.imageGradientEnd],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inventory_2_rounded, size: 48, color: Colors.white60),
                            const SizedBox(height: 8),
                            Text(
                              material.brand,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Verified Authentic Procurement Batch',
                              style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Specifications Matrix
                    Text('Item Specifications & Grade', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.md,
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          _specRow('Brand / Manufacturer', material.brand),
                          _specRow('Technical Grade', material.specification),
                          _specRow('Finish / Texture', material.finish),
                          _specRow('Allocated Room / Area', material.projectArea),
                          _specRow('Project Stage', material.stage),
                          _specRow('Contract Quantity', '${material.quantity.toInt()} ${material.unit}'),
                          if (material.vendorName != null) _specRow('Authorized Depot', material.vendorName!),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Order & Delivery Timeline
                    Text('Procurement & Site Logistics Tracker', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),

                    ...material.orderTimeline.map((step) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              step.isCompleted ? Icons.check_circle_rounded : (step.isCurrent ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded),
                              size: 16,
                              color: step.isCompleted ? const Color(0xFF10B981) : (step.isCurrent ? const Color(0xFF6366F1) : const Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                step.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: step.isCurrent ? FontWeight.w700 : FontWeight.w500,
                                  color: step.isCompleted || step.isCurrent
                                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            if (step.timestamp != null)
                              Text(step.timestamp!, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: const Color(0xFF64748B))),
                          ],
                        ),
                      );
                    }),

                    if (material.notes != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                          borderRadius: AppRadius.md,
                          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.25)),
                        ),
                        child: Text(
                          'Note: ${material.notes!}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFFB45309)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // Modal Footer Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: material.isApprovalRequired
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFF59E0B),
                              side: const BorderSide(color: Color(0xFFF59E0B)),
                              shape: RoundedAppRadius.md,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              ClientDataRepository.requestMaterialChange(material.id, 'Client Preference Adjustment', 'Homeowner requested alternate specification.');
                              onChangesRequested();
                            },
                            child: Text('Request Change', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              shape: RoundedAppRadius.md,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              ClientDataRepository.approveMaterial(material.id);
                              onApproved();
                            },
                            icon: const Icon(Icons.verified_rounded, size: 16),
                            label: Text('Approve Material', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                        shape: RoundedAppRadius.md,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close Dossier', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF64748B))),
          ),
          Expanded(
            child: Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 17. CUSTOMER BOOK MEETING MODAL
// ============================================================================

class CustomerBookMeetingModal extends StatefulWidget {
  final VoidCallback onBooked;

  const CustomerBookMeetingModal({super.key, required this.onBooked});

  static void show(BuildContext context, {required VoidCallback onBooked}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CustomerBookMeetingModal(onBooked: onBooked),
    );
  }

  @override
  State<CustomerBookMeetingModal> createState() => _CustomerBookMeetingModalState();
}

class _CustomerBookMeetingModalState extends State<CustomerBookMeetingModal> {
  CustomerMeetingType _selectedType = CustomerMeetingType.online;
  String _selectedDate = '18 Sep 2026';
  String _selectedTime = '11:00 AM';
  String _selectedAttendee = 'Priya Mehta (Senior Designer)';
  final _purposeCtrl = TextEditingController(text: 'Design & False Ceiling Review');
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _purposeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_purposeCtrl.text.trim().isEmpty) return;

    ClientDataRepository.bookMeeting(
      title: _purposeCtrl.text.trim(),
      type: _selectedType,
      date: _selectedDate,
      timeSlot: _selectedTime,
      purpose: _purposeCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
      attendeeName: _selectedAttendee.split(' (').first,
      attendeeRole: _selectedAttendee.contains('(') ? _selectedAttendee.split('(').last.replaceAll(')', '') : 'Team Lead',
    );

    widget.onBooked();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        content: Text(
          'Meeting scheduled for $_selectedDate at $_selectedTime!',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      insetPadding: EdgeInsets.all(isDesktop ? 24 : 14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calendar_today_rounded, color: Color(0xFF6366F1), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Schedule Project Meeting',
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Purpose
              Text('Meeting Purpose (Required)', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextField(
                controller: _purposeCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. 3D Lighting Review, Site CPVC inspection',
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: AppRadius.md),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),

              const SizedBox(height: 14),

              // Meeting Type Selector
              Text('Meeting Format', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Row(
                children: CustomerMeetingType.values.map((type) {
                  final isSel = _selectedType == type;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => setState(() => _selectedType = type),
                        borderRadius: AppRadius.md,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? type.color : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                            borderRadius: AppRadius.md,
                            border: Border.all(
                              color: isSel ? type.color : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(type.icon, size: 18, color: isSel ? Colors.white : type.color),
                              const SizedBox(height: 4),
                              Text(
                                type.label,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSel ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Attendee
              Text('Meeting With', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAttendee,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    items: [
                      'Priya Mehta (Senior Designer)',
                      'Rahul Sharma (Project Manager)',
                      'Amit Verma (Site Supervisor)',
                      'Amitabh Sen (Procurement Lead)',
                    ].map((a) => DropdownMenuItem(value: a, child: Text(a, style: GoogleFonts.plusJakartaSans(fontSize: 12)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedAttendee = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Available Slots
              Text('Available Date & Time Slots', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ('18 Sep', '11:00 AM'),
                  ('18 Sep', '03:30 PM'),
                  ('19 Sep', '10:00 AM'),
                  ('20 Sep', '02:00 PM'),
                  ('22 Sep', '04:30 PM'),
                ].map((slot) {
                  final isSel = _selectedDate.contains(slot.$1) && _selectedTime == slot.$2;
                  return ChoiceChip(
                    label: Text('${slot.$1} • ${slot.$2}'),
                    selected: isSel,
                    onSelected: (val) {
                      setState(() {
                        _selectedDate = '${slot.$1} 2026';
                        _selectedTime = slot.$2;
                      });
                    },
                    selectedColor: const Color(0xFF6366F1),
                    labelStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      color: isSel ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Notes
              Text('Discussion Notes (Optional)', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Any specific questions or items you wish to discuss...',
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: AppRadius.md),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm CTA
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedAppRadius.md,
                  ),
                  onPressed: _submit,
                  child: Text('Confirm & Schedule Meeting', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


