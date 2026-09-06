import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_badge.dart';

class DashboardMockup extends StatelessWidget {
  const DashboardMockup({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;

    final windowBg = isDark ? const Color(0xFF111827) : Colors.white;
    final surfaceBg = isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1080),
        decoration: BoxDecoration(
          color: windowBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.6)
                  : AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Window Title Bar
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  border: Border(bottom: BorderSide(color: borderColor, width: 1)),
                ),
                child: Row(
                  children: [
                    // macOS dots
                    Row(
                      children: [
                        _WindowDot(color: const Color(0xFFEF4444)),
                        const SizedBox(width: 6),
                        _WindowDot(color: const Color(0xFFF59E0B)),
                        const SizedBox(width: 6),
                        _WindowDot(color: const Color(0xFF10B981)),
                      ],
                    ),
                    const Spacer(),
                    // Simulated URL/Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_rounded, size: 11, color: isDark ? Colors.white54 : Colors.black45),
                          const SizedBox(width: 6),
                          Text(
                            'app.homioworkspace.com/dashboard',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.more_horiz_rounded, size: 18, color: isDark ? Colors.white38 : Colors.black38),
                  ],
                ),
              ),

              // Main Dashboard Body
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Mini Sidebar (hidden on compact mobile)
                    if (!isCompact)
                      Container(
                        width: 180,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFAFAFA),
                          border: Border(right: BorderSide(color: borderColor, width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SidebarItem(icon: Icons.dashboard_rounded, label: 'Overview', isActive: true),
                            _SidebarItem(icon: Icons.filter_alt_rounded, label: 'Leads & CRM'),
                            _SidebarItem(icon: Icons.business_center_rounded, label: 'Projects'),
                            _SidebarItem(icon: Icons.chat_rounded, label: 'WhatsApp', badge: '12'),
                            _SidebarItem(icon: Icons.payments_rounded, label: 'Finance'),
                            _SidebarItem(icon: Icons.auto_awesome_rounded, label: 'AI Suite'),
                            const Spacer(),
                            _SidebarItem(icon: Icons.settings_rounded, label: 'Settings'),
                          ],
                        ),
                      ),

                    // Right Main Canvas
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(isCompact ? 14.0 : 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row inside dashboard
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Executive Workspace',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: isCompact ? 15 : 18,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Live performance across 24 projects & 342 active leads',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                const AppBadge(label: 'LIVE SYNC', icon: Icons.fiber_manual_record, color: AppColors.success),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // KPI Grid
                            _buildKpiRow(context, isDark, surfaceBg, borderColor),
                            const SizedBox(height: 16),

                            // Interactive Project & Funnel Activity
                            _buildActivitySection(context, isDark, surfaceBg, borderColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiRow(BuildContext context, bool isDark, Color bg, Color border) {
    final isCompact = context.isCompact;

    final kpis = [
      {'title': 'Active Funnel Leads', 'val': '342', 'change': '+18.4%', 'pos': true, 'icon': Icons.groups_rounded, 'col': AppColors.primary},
      {'title': 'On-Track Milestones', 'val': '94.2%', 'change': '+4.1%', 'pos': true, 'icon': Icons.task_alt_rounded, 'col': AppColors.success},
      {'title': 'Collected Revenue', 'val': '\$128.4K', 'change': '+22.8%', 'pos': true, 'icon': Icons.account_balance_wallet_rounded, 'col': Color(0xFFF59E0B)},
      {'title': 'Automated Drips Sent', 'val': '1,840', 'change': '99.2% read', 'pos': true, 'icon': Icons.send_rounded, 'col': Color(0xFF06B6D4)},
    ];

    if (isCompact) {
      return Column(
        children: kpis.take(2).map((k) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _KpiCard(data: k, isDark: isDark, bg: bg, border: border),
        )).toList(),
      );
    }

    return Row(
      children: kpis.map((k) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _KpiCard(data: k, isDark: isDark, bg: bg, border: border),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivitySection(BuildContext context, bool isDark, Color bg, Color border) {
    final isCompact = context.isCompact;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Site Execution & Milestones',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                'View All (24)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Project rows
          _ProjectRow(
            code: 'PRJ-409',
            name: 'Villa Rivera Penthouse',
            client: 'David Vance',
            stage: 'False Ceiling & Electrical',
            progress: 0.78,
            statusColor: AppColors.success,
            isCompact: isCompact,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _ProjectRow(
            code: 'PRJ-412',
            name: 'Oakridge Commercial Suite',
            client: 'Nexus Global',
            stage: 'Flooring & Wet Works',
            progress: 0.45,
            statusColor: AppColors.warning,
            isCompact: isCompact,
            isDark: isDark,
          ),

          const SizedBox(height: 14),
          // Live Automation Notification Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D2818) : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'WhatsApp Automation: Site inspection report auto-dispatched to client David Vance with 12 geo-tagged photos.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? AppColors.primaryMutedDark : AppColors.primaryMuted)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive
                ? (isDark ? AppColors.primaryLight : AppColors.primary)
                : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? (isDark ? AppColors.primaryLight : AppColors.primary)
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? AppColors.primaryLight : AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.data,
    required this.isDark,
    required this.bg,
    required this.border,
  });

  final Map<String, dynamic> data;
  final bool isDark;
  final Color bg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    final col = data['col'] as Color;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data['title'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(data['icon'] as IconData, size: 14, color: col),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  data['val'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  data['change'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({
    required this.code,
    required this.name,
    required this.client,
    required this.stage,
    required this.progress,
    required this.statusColor,
    required this.isCompact,
    required this.isDark,
  });

  final String code;
  final String name;
  final String client;
  final String stage;
  final double progress;
  final Color statusColor;
  final bool isCompact;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              code,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$client • $stage',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: mutedColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!isCompact) ...[
            const SizedBox(width: 14),
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark ? Colors.white12 : Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
