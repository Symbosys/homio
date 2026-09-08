import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/operations_mock_data.dart';
import '../models/operations_models.dart';

class SaturdayFeesPage extends StatefulWidget {
  const SaturdayFeesPage({super.key});

  @override
  State<SaturdayFeesPage> createState() => _SaturdayFeesPageState();
}

class _SaturdayFeesPageState extends State<SaturdayFeesPage> {
  late List<SaturdayFeeBatch> _batches;

  @override
  void initState() {
    super.initState();
    _batches = List.from(OperationsMockData.saturdayFees);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final totalScheduled = _batches.fold<double>(0, (sum, b) => sum + b.netPayable);
    final totalDispatched = _batches
        .where((b) => b.status == SaturdayFeeStatus.sent)
        .fold<double>(0, (sum, b) => sum + b.netPayable);
    final pendingCount = _batches.where((b) => b.status == SaturdayFeeStatus.scheduled).length;

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

                // 2. Cron Engine Status Banner
                _buildCronEngineCard(isDark, isMobile),

                const SizedBox(height: 20),

                // 3. Metrics Summary Bar
                _buildMetricsBar(isDark, isMobile, totalScheduled, totalDispatched, pendingCount),

                const SizedBox(height: 24),

                // 4. Batch Table / Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enrolled Projects Weekly Supervision Calculations',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 15 : 17,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: pendingCount == 0 ? null : _dispatchAllBatches,
                      icon: const Icon(Icons.flash_on_rounded, size: 16),
                      label: Text(
                        'Dispatch All ($pendingCount)',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _batches.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return _buildBatchCard(context, _batches[index], isDark, isMobile);
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
              ? [const Color(0xFF1E1435), const Color(0xFF131127), const Color(0xFF0F172A)]
              : [const Color(0xFFFAF5FF), const Color(0xFFF5F3FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.alarm_on_rounded, size: 14, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 6),
                Text(
                  'AUTOMATED WEEKLY SETTLEMENTS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8B5CF6),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Saturday Weekly Fee Auto-Dispatch Engine',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Runs automatically every Saturday at 10:00 AM. Dynamically computes site supervision fees based on weekly execution progress, contract models, and dispatches formal WhatsApp payment links to clients.',
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

  Widget _buildCronEngineCard(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.md,
        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.schedule_rounded, size: 28, color: Color(0xFF3B82F6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Next Automated Run: Saturday, 10:00 AM IST',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'CRON ACTIVE',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Automated billing engine checks milestone progress from site supervisors every Friday midnight, calculates fee schedules, and compiles invoices for dispatch.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsBar(bool isDark, bool isMobile, double scheduled, double dispatched, int pending) {
    final items = [
      (label: 'Total Batch Value', value: '₹${(scheduled / 1000).toInt()} K', sub: '${_batches.length} Enrolled Projects', color: const Color(0xFF6366F1), icon: Icons.account_balance_wallet_rounded),
      (label: 'Dispatched & Sent', value: '₹${(dispatched / 1000).toInt()} K', sub: '${_batches.length - pending} Delivered to WhatsApp', color: const Color(0xFF10B981), icon: Icons.mark_chat_read_rounded),
      (label: 'Queued for Saturday', value: '$pending Projects', sub: 'Ready for 10:00 AM Blast', color: const Color(0xFFF59E0B), icon: Icons.hourglass_top_rounded),
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

  Widget _buildBatchCard(BuildContext context, SaturdayFeeBatch b, bool isDark, bool isMobile) {
    final isSent = b.status == SaturdayFeeStatus.sent;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isSent ? const Color(0xFF10B981).withValues(alpha: 0.4) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        b.invoiceRef ?? b.id,
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF8B5CF6)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        b.projectName,
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isSent ? const Color(0xFF10B981).withValues(alpha: 0.12) : const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSent ? const Color(0xFF10B981).withValues(alpha: 0.4) : const Color(0xFF3B82F6).withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  isSent ? 'DISPATCHED VIA WHATSAPP' : 'SCHEDULED FOR SATURDAY',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: isSent ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Details Grid
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _buildDetailItem('Client', '${b.clientName} (${b.clientPhone})', isDark),
              _buildDetailItem('Supervisor', b.supervisorName, isDark),
              _buildDetailItem('Active Stage', b.currentStage, isDark),
              _buildDetailItem('Billing Model', b.contractModel, isDark),
              _buildDetailItem('Weekly Progress Delta', '+${b.weekProgressPercent}% this week', isDark, highlightColor: const Color(0xFF10B981)),
            ],
          ),
          const SizedBox(height: 14),

          // Fee Breakdown Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Base Weekly: ₹${b.baseWeeklyFee.toInt()}   |   Progress Calc: ₹${b.calculatedFee.toInt()}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                    if (b.adjustment != 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(${b.adjustment > 0 ? '+' : ''}₹${b.adjustment.toInt()} adjustment)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: b.adjustment > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Net Invoice: ',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '₹${b.netPayable.toInt()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
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
                onPressed: () => _showAdjustmentDialog(context, b),
                icon: const Icon(Icons.edit_note_rounded, size: 14),
                label: Text('Adjust Fee', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
              ),
              const SizedBox(width: 8),
              if (!isSent)
                FilledButton.icon(
                  onPressed: () => _dispatchSingleBatch(b),
                  icon: const Icon(Icons.send_rounded, size: 14),
                  label: Text('Dispatch Now', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: () => _dispatchSingleBatch(b),
                  icon: const Icon(Icons.replay_rounded, size: 14),
                  label: Text('Re-send Receipt', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark, {Color? highlightColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: highlightColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }

  void _dispatchSingleBatch(SaturdayFeeBatch b) {
    setState(() {
      final index = _batches.indexWhere((item) => item.id == b.id);
      if (index != -1) {
        _batches[index] = b.copyWith(status: SaturdayFeeStatus.sent);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saturday Fee Invoice for ₹${b.netPayable.toInt()} sent to ${b.clientName} via WhatsApp!'),
        backgroundColor: const Color(0xFF25D366),
      ),
    );
  }

  void _dispatchAllBatches() {
    setState(() {
      _batches = _batches.map((b) => b.copyWith(status: SaturdayFeeStatus.sent)).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All scheduled Saturday fee invoices successfully dispatched via WhatsApp Cloud API!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _showAdjustmentDialog(BuildContext context, SaturdayFeeBatch b) {
    final adjCtrl = TextEditingController(text: b.adjustment.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Adjust Weekly Fee for ${b.projectName}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Base calculated fee: ₹${b.calculatedFee.toInt()}'),
                const SizedBox(height: 12),
                TextField(
                  controller: adjCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Adjustment in ₹ (Positive for additions, Negative for rebates)',
                    hintText: 'e.g. 5000 or -2000',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final adj = double.tryParse(adjCtrl.text) ?? 0.0;
                setState(() {
                  final index = _batches.indexWhere((item) => item.id == b.id);
                  if (index != -1) {
                    _batches[index] = b.copyWith(adjustment: adj);
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fee adjusted! New net payable is ₹${(b.calculatedFee + adj).toInt()}')),
                );
              },
              child: const Text('Save Adjustment'),
            ),
          ],
        );
      },
    );
  }
}
