import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/quotation_header.dart';
import '../widgets/quotation_metric_card.dart';
import '../widgets/urgency_countdown_badge.dart';
import '../widgets/whatsapp_urgency_dialog.dart';

/// Screen 4: Dynamic Pricing & 24h Expiry Urgency Command Hub (PRD Section 9.4 & TC-QUOT-001).
class QuotationUrgencyPage extends StatefulWidget {
  const QuotationUrgencyPage({super.key});

  @override
  State<QuotationUrgencyPage> createState() => _QuotationUrgencyPageState();
}

class _QuotationUrgencyPageState extends State<QuotationUrgencyPage> {
  late List<Quotation> _quotations;
  late List<UrgencyAlertLog> _urgencyLogs;

  @override
  void initState() {
    super.initState();
    _quotations = List.from(QuotationMockData.quotations);
    _urgencyLogs = List.from(QuotationMockData.urgencyLogs);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Metrics calculations
    final activeCount = _quotations.length;
    final expiringSoonCount = _quotations.where((q) => !q.isDiscountExpired && q.timeRemaining.inHours <= 24).length;
    final totalDiscountAtStake = _quotations.fold(0.0, (sum, q) => sum + q.discountAmount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            QuotationHeader(
              title: 'Dynamic Pricing & 24h Expiry Urgency Hub',
              subtitle: 'Automated WhatsApp urgency reminders, discount expiry tracking & closing bots (TC-QUOT-001)',
              icon: Icons.timer_rounded,
              primaryAction: ElevatedButton.icon(
                onPressed: _triggerBulkAudit,
                icon: const Icon(Icons.bolt_rounded, size: 16),
                label: const Text('Run 24h Expiry Cron Check'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              onRefresh: () {
                setState(() {
                  _quotations = List.from(QuotationMockData.quotations);
                  _urgencyLogs = List.from(QuotationMockData.urgencyLogs);
                });
              },
            ),

            // KPI Metrics Row
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 640;
                final isMedium = constraints.maxWidth < 1024;
                final crossAxisCount = isNarrow ? 2 : (isMedium ? 2 : 4);

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isNarrow ? 1.6 : 2.2,
                  children: [
                    QuotationMetricCard(
                      title: 'ACTIVE DISCOUNT PROPOSALS',
                      value: '$activeCount Quotes',
                      subtitle: 'Under negotiation',
                      icon: Icons.local_offer_rounded,
                      accentColor: AppColors.primary,
                    ),
                    QuotationMetricCard(
                      title: 'EXPIRING IN < 24 HOURS',
                      value: '$expiringSoonCount Proposals',
                      subtitle: 'Urgency WhatsApp triggered',
                      icon: Icons.warning_amber_rounded,
                      accentColor: const Color(0xFFEA580C),
                      changePercent: 'CRITICAL',
                      isPositive: false,
                    ),
                    QuotationMetricCard(
                      title: 'DISCOUNT VALUE AT STAKE',
                      value: '₹${(totalDiscountAtStake / 1000).toStringAsFixed(0)}K',
                      subtitle: 'Early-bird savings incentive',
                      icon: Icons.currency_rupee_rounded,
                      accentColor: AppColors.success,
                    ),
                    QuotationMetricCard(
                      title: 'CLOSING CONVERSION RATE',
                      value: '68.4%',
                      subtitle: 'Within 24h urgency window',
                      icon: Icons.speed_rounded,
                      accentColor: AppColors.secondary,
                      changePercent: '+8.6%',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Active Discount Quotations Table
            Text(
              'Active Discount Proposals & Expiry Timers',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Proposals with submission dates, early bird discounts and countdown timers',
              style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 12),

            if (isMobile)
              _buildMobileQuotationsList(isDark)
            else
              _buildDesktopQuotationsTable(isDark),

            const SizedBox(height: 24),

            // Automated 24h WhatsApp Urgency Logs Section (PRD Scenario 1 / TC-QUOT-001)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.chat_bubble_rounded, size: 14, color: Color(0xFF25D366)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '24-Hour WhatsApp Urgency Automation Log (TC-QUOT-001)',
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pre-approved WhatsApp Cloud API templates dispatched exactly 24h prior to expiry',
                      style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Bot Status: ACTIVE',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF25D366)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildUrgencyLogsCard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopQuotationsTable(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.md,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 16,
            headingRowHeight: 44,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 68,
            headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle),
            headingTextStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            columns: const [
              DataColumn(label: Text('PROPOSAL & CLIENT')),
              DataColumn(label: Text('DEAL VALUE')),
              DataColumn(label: Text('DISCOUNT (INR / %)')),
              DataColumn(label: Text('SUBMISSION DATE')),
              DataColumn(label: Text('COUNTDOWN & EXPIRY')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: _quotations.map((q) {
              final isExpiringSoon = !q.isDiscountExpired && q.timeRemaining.inHours <= 24;
              return DataRow(
                color: isExpiringSoon
                    ? WidgetStateProperty.all(const Color(0xFFEA580C).withValues(alpha: isDark ? 0.1 : 0.05))
                    : null,
                cells: [
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          q.quoteNumber,
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        Text(
                          '${q.clientName} • ${q.clientPhone}',
                          style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text('₹${q.grandTotal.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '-₹${q.discountAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error),
                        ),
                        Text(
                          '${q.discountPercent.toStringAsFixed(0)}% Early Bird',
                          style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      _formatDate(q.submissionDate),
                      style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                  DataCell(
                    UrgencyCountdownBadge(expiryDate: q.discountExpiryDate),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _openWhatsAppNudge(q),
                          icon: const Icon(Icons.chat_bubble_rounded, size: 13),
                          label: const Text('Send Alert'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            visualDensity: VisualDensity.compact,
                            textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => _extendExpiryDialog(q),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            visualDensity: VisualDensity.compact,
                            textStyle: GoogleFonts.inter(fontSize: 11),
                          ),
                          child: const Text('Extend 24h'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileQuotationsList(bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _quotations.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final q = _quotations[idx];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(q.quoteNumber, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  UrgencyCountdownBadge(expiryDate: q.discountExpiryDate, isCompact: true),
                ],
              ),
              const SizedBox(height: 4),
              Text(q.clientName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              Text(q.projectTitle, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: ₹${q.grandTotal.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                  Text(
                    'Discount: -₹${q.discountAmount.toStringAsFixed(0)} (${q.discountPercent.toStringAsFixed(0)}%)',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _extendExpiryDialog(q),
                    style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                    child: const Text('Extend 24h'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _openWhatsAppNudge(q),
                    icon: const Icon(Icons.chat_bubble_rounded, size: 14),
                    label: const Text('WhatsApp Nudge'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUrgencyLogsCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _urgencyLogs.length,
        separatorBuilder: (_, _) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        itemBuilder: (context, idx) {
          final log = _urgencyLogs[idx];
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: log.isTriggered
                        ? const Color(0xFF25D366).withValues(alpha: 0.15)
                        : AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Icon(
                    log.isTriggered ? Icons.mark_chat_read_rounded : Icons.schedule_rounded,
                    size: 16,
                    color: log.isTriggered ? const Color(0xFF25D366) : AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${log.quoteNumber} • ${log.clientName} (${log.clientPhone})',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: log.deliveryStatus == 'READ'
                                  ? AppColors.success.withValues(alpha: 0.15)
                                  : log.deliveryStatus == 'EXPIRED'
                                      ? AppColors.error.withValues(alpha: 0.15)
                                      : AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              log.deliveryStatus,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: log.deliveryStatus == 'READ'
                                    ? AppColors.success
                                    : log.deliveryStatus == 'EXPIRED'
                                        ? AppColors.error
                                        : AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        log.whatsappMessagePreview,
                        style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Discount at risk: ₹${log.discountAmount.toStringAsFixed(0)} • Expiry: ${_formatDate(log.expiryDate)}',
                        style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openWhatsAppNudge(Quotation q) {
    showDialog(
      context: context,
      builder: (ctx) => WhatsAppUrgencyDialog(
        quotation: q,
        onDispatched: () {
          setState(() {
            _urgencyLogs.insert(
              0,
              UrgencyAlertLog(
                id: 'URG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                quotationId: q.id,
                quoteNumber: q.quoteNumber,
                clientName: q.clientName,
                clientPhone: q.clientPhone,
                quotationAmount: q.grandTotal,
                discountAmount: q.discountAmount,
                expiryDate: q.discountExpiryDate,
                scheduledAlertTime: DateTime.now(),
                isTriggered: true,
                triggeredAt: DateTime.now(),
                deliveryStatus: 'DISPATCHED',
                whatsappMessagePreview: 'Urgent notice dispatched to ${q.clientName}: 24h discount expiry reminder.',
              ),
            );
          });
        },
      ),
    );
  }

  void _extendExpiryDialog(Quotation q) {
    final idx = _quotations.indexOf(q);
    if (idx >= 0) {
      setState(() {
        _quotations[idx] = q.copyWith(
          discountExpiryDate: DateTime.now().add(const Duration(days: 1)),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Discount validity for ${q.quoteNumber} extended by 24 hours.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _triggerBulkAudit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Automated 24h Expiry Cron ran: 1 urgent notification scheduled for dispatch.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
