import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/accounting_mock_data.dart';
import '../models/accounting_models.dart';

class OverduePaymentAlertsPage extends StatefulWidget {
  const OverduePaymentAlertsPage({super.key});

  @override
  State<OverduePaymentAlertsPage> createState() => _OverduePaymentAlertsPageState();
}

class _OverduePaymentAlertsPageState extends State<OverduePaymentAlertsPage> {
  late List<OverdueAlert> _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = List.from(AccountingMockData.overdueAlerts);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final totalOverdue = _alerts.fold<double>(0, (sum, a) => sum + a.dueAmount);
    final haltedCount = _alerts.where((a) => a.siteHaltStatus == SiteHaltStatus.halted).length;
    final criticalCount = _alerts.where((a) => a.overdueDays >= 15).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 28,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Banner
                _buildHeader(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 2. Multi-Stakeholder Escalation Protocol Card
                _buildProtocolBanner(isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Metrics Summary Bar
                _buildMetricsBar(isDark, isMobile, totalOverdue, haltedCount, criticalCount),

                const SizedBox(height: 24),

                // 4. Overdue Accounts & Directives
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delinquent Accounts & Site Halt Directives',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 15 : 17,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _sendAutomatedRemindersAll,
                      icon: const Icon(Icons.send_rounded, size: 14),
                      label: Text('Blast All Client Reminders', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _alerts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildAlertCard(context, _alerts[index], isDark, isMobile);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2E1015), const Color(0xFF1F0B10), const Color(0xFF0F172A)]
              : [const Color(0xFFFFF1F2), const Color(0xFFFFE4E6), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.notification_important_rounded, size: 14, color: Color(0xFFEF4444)),
                const SizedBox(width: 6),
                Text(
                  'AUTOMATED OVERDUE ESCALATION ENGINE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFEF4444),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Multi-Stakeholder Overdue Payment Alerts & Site Work Halts',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Automated 3-tier escalation evaluating invoice due dates: WhatsApp payment links to clients, high-priority push directives to site supervisors to HALT execution, and executive financial delinquency escalations.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolBanner(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '3-Tier Escalation Protocol Matrix:',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildProtocolStep(
                  step: 'Level 1 (Days 1–7)',
                  title: 'Client Payment Link',
                  desc: 'Automated WhatsApp reminder with instant 1-click online payment URL.',
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildProtocolStep(
                  step: 'Level 2 (Days 8–14)',
                  title: 'Site Supervisor Halt',
                  desc: 'Immediate directive sent to site supervisor to freeze next stage work.',
                  color: const Color(0xFFEF4444),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildProtocolStep(
                  step: 'Level 3 (Days 15+)',
                  title: 'Admin Legal Escalation',
                  desc: 'Escalation to Owner & Legal Counsel for formal contract recovery.',
                  color: const Color(0xFF991B1B),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolStep({
    required String step,
    required String title,
    required String desc,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(desc, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildMetricsBar(bool isDark, bool isMobile, double total, int halted, int critical) {
    final items = [
      (label: 'Total Overdue Balance', value: '₹${(total / 100000).toStringAsFixed(2)} L', sub: '${_alerts.length} Flagged Invoices', color: const Color(0xFFEF4444), icon: Icons.money_off_rounded),
      (label: 'Sites Currently Halted', value: '$halted Sites', sub: 'Execution frozen by supervisor', color: const Color(0xFFEF4444), icon: Icons.stop_circle_rounded),
      (label: 'Critical 15+ Days Overdue', value: '$critical Accounts', sub: 'Escalated to Super Admin', color: const Color(0xFFF59E0B), icon: Icons.gavel_rounded),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cardWidth = isWide ? (constraints.maxWidth - 24) / 3 : double.infinity;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 22, color: item.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.sub,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              color: item.color,
                              fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildAlertCard(BuildContext context, OverdueAlert alert, bool isDark, bool isMobile) {
    final isHalted = alert.siteHaltStatus == SiteHaltStatus.halted;

    Color levelColor;
    String levelText;
    switch (alert.escalationLevel) {
      case EscalationLevel.level1ClientReminder:
        levelColor = const Color(0xFFF59E0B);
        levelText = 'LEVEL 1: CLIENT WHATSAPP LINK';
        break;
      case EscalationLevel.level2SupervisorHalt:
        levelColor = const Color(0xFFEF4444);
        levelText = 'LEVEL 2: SITE WORK HALTED';
        break;
      case EscalationLevel.level3AdminEscalation:
        levelColor = const Color(0xFF991B1B);
        levelText = 'LEVEL 3: ADMIN & LEGAL ESCALATION';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isHalted
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isHalted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${alert.overdueDays} DAYS OVERDUE',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFFEF4444)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        alert.projectTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: levelColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  levelText,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: levelColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Details Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client: ${alert.clientName} (${alert.clientPhone})',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Site Supervisor: ${alert.supervisorName}  •  Last Alert Sent: ${_formatDateTime(alert.lastAlertSent)}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${alert.dueAmount.toInt()}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  Text(
                    'Outstanding Balance',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Directive Note
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  isHalted ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
                  size: 15,
                  color: isHalted ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alert.notes,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _toggleSiteHalt(alert),
                icon: Icon(isHalted ? Icons.play_arrow_rounded : Icons.pause_rounded, size: 14),
                label: Text(
                  isHalted ? 'Resume Site Work' : 'Issue Halt Directive',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: isHalted ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isHalted ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => _sendClientReminder(alert),
                icon: const Icon(Icons.send_rounded, size: 13),
                label: Text('Send WhatsApp Link', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleSiteHalt(OverdueAlert alert) {
    setState(() {
      final index = _alerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        final newStatus = alert.siteHaltStatus == SiteHaltStatus.halted ? SiteHaltStatus.active : SiteHaltStatus.halted;
        _alerts[index] = alert.copyWith(
          siteHaltStatus: newStatus,
          notes: newStatus == SiteHaltStatus.halted
              ? 'Site work on ${alert.projectTitle} HALTED by supervisor until invoice is cleared.'
              : 'Site work resumed following client payment commitment.',
        );
      }
    });

    final isNowHalted = alert.siteHaltStatus != SiteHaltStatus.halted;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isNowHalted
            ? 'Push directive dispatched to ${alert.supervisorName}: Site work HALTED!'
            : 'Directive dispatched: Site work resumed on ${alert.projectTitle}.'),
        backgroundColor: isNowHalted ? const Color(0xFFEF4444) : const Color(0xFF10B981),
      ),
    );
  }

  void _sendClientReminder(OverdueAlert alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('High-priority payment reminder & link sent to ${alert.clientName} (${alert.clientPhone}) via WhatsApp!'),
        backgroundColor: const Color(0xFF25D366),
      ),
    );
  }

  void _sendAutomatedRemindersAll() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Automated WhatsApp payment reminders dispatched to all overdue accounts!'),
        backgroundColor: Color(0xFFEF4444),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month} at ${dt.hour}:${dt.minute < 10 ? '0' : ''}${dt.minute}';
  }
}
