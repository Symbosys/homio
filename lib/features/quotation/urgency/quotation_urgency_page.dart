import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/empty_state.dart';
import '../widgets/expiry_countdown.dart';
import '../widgets/quotation_header.dart';
import '../widgets/quotation_metric_card.dart';
import '../widgets/whatsapp_urgency_dialog.dart';

/// Screen 5: Quotation Expiry, Reminders & Dynamic Pricing Urgency Hub (PRD Section 32).
class QuotationUrgencyPage extends StatefulWidget {
  const QuotationUrgencyPage({super.key});

  @override
  State<QuotationUrgencyPage> createState() => _QuotationUrgencyPageState();
}

enum UrgencyFilter {
  all('All Active'),
  today('Expiring Today (<24h)'),
  tomorrow('Expiring Tomorrow'),
  thisWeek('Next 7 Days'),
  expired('Expired'),
  dispatched('Reminder Sent');

  final String label;
  const UrgencyFilter(this.label);
}

class _QuotationUrgencyPageState extends State<QuotationUrgencyPage> {
  late List<Quotation> _quotations;
  late List<UrgencyAlertLog> _urgencyLogs;
  UrgencyFilter _selectedFilter = UrgencyFilter.all;
  bool _autoRemindersEnabled = true;
  int _alertHoursBefore = 24;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _quotations = List.from(QuotationMockData.quotations);
      _urgencyLogs = List.from(QuotationMockData.urgencyAlerts);
    });
  }

  List<Quotation> get _filteredQuotations {
    return _quotations.where((q) {
      final now = DateTime.now();
      final diff = q.discountExpiryDate.difference(now);

      switch (_selectedFilter) {
        case UrgencyFilter.all:
          return true;
        case UrgencyFilter.today:
          return !diff.isNegative && diff.inHours <= 24;
        case UrgencyFilter.tomorrow:
          return diff.inHours > 24 && diff.inHours <= 48;
        case UrgencyFilter.thisWeek:
          return !diff.isNegative && diff.inDays <= 7;
        case UrgencyFilter.expired:
          return diff.isNegative || q.status == QuotationStatus.expired;
        case UrgencyFilter.dispatched:
          return _urgencyLogs.any((l) => l.quotationId == q.id && l.isTriggered);
      }
    }).toList();
  }

  void _runExpiryCheck() {
    int triggeredCount = 0;
    for (var q in _quotations) {
      if (!q.isDiscountExpired && q.timeRemaining.inHours <= 24) {
        final existing = _urgencyLogs.any((l) => l.quotationId == q.id);
        if (!existing) {
          _urgencyLogs.insert(
            0,
            UrgencyAlertLog(
              id: 'URG-${DateTime.now().millisecondsSinceEpoch}',
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
              deliveryStatus: ReminderStatus.delivered,
              salesOwner: q.salesOwner,
              whatsappMessagePreview: 'Urgency alert triggered for ${q.clientName}',
            ),
          );
          triggeredCount++;
        }
      }
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cron audit completed: $triggeredCount automated urgency reminders queued.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _openWhatsAppDialog(Quotation q) {
    showDialog(
      context: context,
      builder: (ctx) => WhatsAppUrgencyDialog(
        quotation: q,
        onDispatched: () {
          setState(() {
            _urgencyLogs.insert(
              0,
              UrgencyAlertLog(
                id: 'URG-${DateTime.now().millisecondsSinceEpoch}',
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
                deliveryStatus: ReminderStatus.dispatched,
                salesOwner: q.salesOwner,
                whatsappMessagePreview: 'Manual reminder sent via WhatsApp',
              ),
            );
          });
        },
      ),
    );
  }

  void _openConfigDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          title: Text('Automated Reminder Bot Configuration', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                value: _autoRemindersEnabled,
                title: const Text('Enable Automated WhatsApp Bot', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: const Text('Automatically dispatches Meta-approved template before discount expires.', style: TextStyle(fontSize: 11)),
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  setDlgState(() => _autoRemindersEnabled = val);
                  setState(() => _autoRemindersEnabled = val);
                },
              ),
              const SizedBox(height: 12),
              Text('Trigger Schedule', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                initialValue: _alertHoursBefore,
                decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 12, child: Text('12 Hours before discount expiry')),
                  DropdownMenuItem(value: 24, child: Text('24 Hours before discount expiry (Recommended)')),
                  DropdownMenuItem(value: 48, child: Text('48 Hours before discount expiry')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setDlgState(() => _alertHoursBefore = v);
                    setState(() => _alertHoursBefore = v);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 6 Metrics calculations
    final expiringToday = _quotations.where((q) => !q.isDiscountExpired && q.timeRemaining.inHours <= 24).length;
    final expiringTomorrow = _quotations.where((q) => q.timeRemaining.inHours > 24 && q.timeRemaining.inHours <= 48).length;
    final expiringThisWeek = _quotations.where((q) => !q.isDiscountExpired && q.timeRemaining.inDays <= 7).length;
    final expiredTotal = _quotations.where((q) => q.isDiscountExpired || q.status == QuotationStatus.expired).length;
    final sentCount = _urgencyLogs.where((l) => l.deliveryStatus == ReminderStatus.delivered || l.deliveryStatus == ReminderStatus.read).length;
    final failedCount = _urgencyLogs.where((l) => l.deliveryStatus == ReminderStatus.failed).length;

    final filtered = _filteredQuotations;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Header with Breadcrumbs & Action
            QuotationHeader(
              title: 'Dynamic Pricing, Expiry & WhatsApp Urgency Hub',
              subtitle: 'Automated 24h WhatsApp closing bot, price-lock tracking & discount retention (TC-QUOT-001)',
              icon: Icons.alarm_rounded,
              breadcrumbs: const ['Homio CRM', 'Commercials', 'Expiry & Reminders'],
              onRefresh: _loadData,
              primaryAction: Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _openConfigDialog,
                    icon: const Icon(Icons.settings_suggest_rounded, size: 14),
                    label: const Text('Reminder Settings'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _runExpiryCheck,
                    icon: const Icon(Icons.bolt_rounded, size: 16),
                    label: const Text('Run 24h Expiry Audit'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 6 KPI Cards (PRD Section 32)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 175,
                    child: QuotationMetricCard(
                      title: 'EXPIRING TODAY (<24H)',
                      value: '$expiringToday Quotes',
                      subtitle: 'Urgent closing attention',
                      icon: Icons.warning_amber_rounded,
                      accentColor: const Color(0xFFEA580C),
                      isSelected: _selectedFilter == UrgencyFilter.today,
                      onTap: () => setState(() => _selectedFilter = UrgencyFilter.today),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 175,
                    child: QuotationMetricCard(
                      title: 'EXPIRING TOMORROW',
                      value: '$expiringTomorrow Quotes',
                      subtitle: '24 to 48 hours remaining',
                      icon: Icons.hourglass_bottom_rounded,
                      accentColor: const Color(0xFFF59E0B),
                      isSelected: _selectedFilter == UrgencyFilter.tomorrow,
                      onTap: () => setState(() => _selectedFilter = UrgencyFilter.tomorrow),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 175,
                    child: QuotationMetricCard(
                      title: 'EXPIRING THIS WEEK',
                      value: '$expiringThisWeek Quotes',
                      subtitle: 'Next 7 days validity',
                      icon: Icons.date_range_rounded,
                      accentColor: AppColors.primary,
                      isSelected: _selectedFilter == UrgencyFilter.thisWeek,
                      onTap: () => setState(() => _selectedFilter = UrgencyFilter.thisWeek),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 175,
                    child: QuotationMetricCard(
                      title: 'DISCOUNTS EXPIRED',
                      value: '$expiredTotal Quotes',
                      subtitle: 'Requires re-engagement',
                      icon: Icons.timer_off_rounded,
                      accentColor: AppColors.error,
                      isSelected: _selectedFilter == UrgencyFilter.expired,
                      onTap: () => setState(() => _selectedFilter = UrgencyFilter.expired),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 175,
                    child: QuotationMetricCard(
                      title: 'REMINDERS DELIVERED',
                      value: '$sentCount WhatsApps',
                      subtitle: 'Delivered & read by client',
                      icon: Icons.mark_chat_read_rounded,
                      accentColor: const Color(0xFF25D366),
                      isSelected: _selectedFilter == UrgencyFilter.dispatched,
                      onTap: () => setState(() => _selectedFilter = UrgencyFilter.dispatched),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 175,
                    child: QuotationMetricCard(
                      title: 'REMINDER FAILED',
                      value: '$failedCount Issues',
                      subtitle: 'Phone invalid / blocked',
                      icon: Icons.error_outline_rounded,
                      accentColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Filter Tabs Bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: AppRadius.md,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
              ),
              child: Row(
                children: [
                  Text('Filter by Urgency:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: UrgencyFilter.values.map((f) {
                          final isSel = _selectedFilter == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(f.label, style: GoogleFonts.inter(fontSize: 11, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500)),
                              selected: isSel,
                              onSelected: (_) => setState(() => _selectedFilter = f),
                              selectedColor: AppColors.primary.withValues(alpha: 0.15),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Expiry Table
            if (filtered.isEmpty)
              QuotationEmptyState(
                icon: Icons.check_circle_outline_rounded,
                title: 'No quotations in this urgency window',
                description: 'All discounts are either comfortably valid or already resolved.',
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50),
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 68,
                    columns: const [
                      DataColumn(label: Text('Quotation #')),
                      DataColumn(label: Text('Client Name & Mobile')),
                      DataColumn(label: Text('Project Society')),
                      DataColumn(label: Text('Grand Total (₹)'), numeric: true),
                      DataColumn(label: Text('Discount at Stake (₹)'), numeric: true),
                      DataColumn(label: Text('Expiry Countdown')),
                      DataColumn(label: Text('WhatsApp Bot Status')),
                      DataColumn(label: Text('Commercial Lead')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: filtered.map((q) {
                      final hasDispatched = _urgencyLogs.any((l) => l.quotationId == q.id && l.isTriggered);

                      return DataRow(
                        cells: [
                          DataCell(Text(q.quoteNumber, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(q.clientName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                                Text(q.clientPhone, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                              ],
                            ),
                          ),
                          DataCell(Text(q.projectTitle, style: GoogleFonts.inter(fontSize: 11))),
                          DataCell(Text('₹${q.grandTotal.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700))),
                          DataCell(
                            Text(
                              '-₹${q.discountAmount.toStringAsFixed(0)} (${q.discountPercent.toStringAsFixed(1)}%)',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error),
                            ),
                          ),
                          DataCell(ExpiryCountdown(expiryDate: q.discountExpiryDate, isCompact: true)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: hasDispatched ? const Color(0xFF25D366).withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.15),
                                borderRadius: AppRadius.sm,
                              ),
                              child: Text(
                                hasDispatched ? 'DELIVERED' : 'PENDING SCHEDULE',
                                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: hasDispatched ? const Color(0xFF25D366) : Colors.orange),
                              ),
                            ),
                          ),
                          DataCell(Text(q.salesOwner, style: GoogleFonts.inter(fontSize: 11))),
                          DataCell(
                            FilledButton.icon(
                              onPressed: () => _openWhatsAppDialog(q),
                              icon: const Icon(Icons.flash_on_rounded, size: 14),
                              label: const Text('Trigger WhatsApp Bot'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF25D366),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
