import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';
import '../widgets/after_sales_header.dart';
import '../widgets/customer_followup_modal.dart';

class RetentionFollowupsPage extends StatefulWidget {
  const RetentionFollowupsPage({super.key});

  @override
  State<RetentionFollowupsPage> createState() => _RetentionFollowupsPageState();
}

class _RetentionFollowupsPageState extends State<RetentionFollowupsPage> {
  final List<ServiceFollowUp> _followUps = List.from(AfterSalesMockData.retentionFollowUps);

  String _searchQuery = '';
  FollowUpType? _selectedType;
  FollowUpOutcome? _selectedOutcome;
  String _dateFilter = 'This Month';

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final filtered = _followUps.where((f) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = f.customerName.toLowerCase().contains(q) ||
            f.customerPhone.contains(q) ||
            f.projectName.toLowerCase().contains(q) ||
            f.reason.toLowerCase().contains(q) ||
            f.notes.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedType != null && f.followUpType != _selectedType) return false;
      if (_selectedOutcome != null && f.outcome != _selectedOutcome) return false;
      return true;
    }).toList();

    // KPIs
    final totalFollowUps = _followUps.length;
    final dueTodayCount = _followUps.where((f) => f.isDueToday).length;
    final overdueCount = _followUps.where((f) => f.isOverdue).length;
    final highCSATCount = _followUps.where((f) => (f.satisfactionRating ?? 0) >= 4.5).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AfterSalesHeader(
              title: 'Customer Retention, AMC & Proactive Relationship Hub',
              subtitle: 'Post-handover customer journeys, weekly touchpoint schedules, anniversary courtesy calls, and repeat business opportunities.',
              activeTab: 'Retention / Follow-ups',
              selectedDateFilter: _dateFilter,
              onDateFilterChanged: (val) => setState(() => _dateFilter = val),
              trailing: ElevatedButton.icon(
                onPressed: () => _openLogFollowUpModal(context),
                icon: const Icon(Icons.add_call, size: 16),
                label: const Text('Log Customer Follow-up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Scoreboard
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildKpi('Total Relationships', '$totalFollowUps', 'Active client accounts', Icons.people_outline_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Scheduled Today', '$dueTodayCount', 'Touchpoints queued', Icons.calendar_today_rounded, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Overdue Follow-ups', '$overdueCount', 'Missed weekly calls', Icons.warning_amber_rounded, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('High CSAT (>4.5 ★)', '$highCSATCount', 'Referral & AMC ready', Icons.star_rate_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildKpi('Total Relationships', '$totalFollowUps', 'Active client accounts', Icons.people_outline_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Scheduled Today', '$dueTodayCount', 'Touchpoints queued', Icons.calendar_today_rounded, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Overdue Follow-ups', '$overdueCount', 'Missed weekly calls', Icons.warning_amber_rounded, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('High CSAT (>4.5 ★)', '$highCSATCount', 'Referral & AMC ready', Icons.star_rate_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search & Filter Panel
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search follow-ups by customer name, phone, project, notes...',
                              prefixIcon: const Icon(Icons.search, size: 18),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<FollowUpType?>(
                            initialValue: _selectedType,
                            decoration: InputDecoration(
                              labelText: 'Touchpoint Type',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Touchpoint Types')),
                              ...FollowUpType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))),
                            ],
                            onChanged: (val) => setState(() => _selectedType = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<FollowUpOutcome?>(
                            initialValue: _selectedOutcome,
                            decoration: InputDecoration(
                              labelText: 'Outcome',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Outcomes')),
                              ...FollowUpOutcome.values.map((o) => DropdownMenuItem(value: o, child: Text(o.label))),
                            ],
                            onChanged: (val) => setState(() => _selectedOutcome = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Follow-ups List
                  Text('Scheduled & Historical Retention Touchpoints (${filtered.length})', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final f = filtered[index];
                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(f.followUpType.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF8B5CF6))),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: f.outcome.color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(f.outcome.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: f.outcome.color)),
                                    ),
                                  ],
                                ),
                                if (f.satisfactionRating != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                      const SizedBox(width: 4),
                                      Text('${f.satisfactionRating!.toStringAsFixed(1)} / 5.0', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.amber)),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Text(f.reason, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                            const SizedBox(height: 4),
                            Text(f.notes, style: TextStyle(fontSize: 12, height: 1.4, color: textSecondaryColor)),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Text('${f.customerName} (${f.customerPhone})', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary)),
                                const SizedBox(width: 12),
                                Text('• ${f.projectName}', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                                const SizedBox(width: 12),
                                Text('• Channel: ${f.channel}', style: TextStyle(fontSize: 12, color: textMutedColor)),
                                const SizedBox(width: 12),
                                Text('• Handover: ${f.handoverDate.day}/${f.handoverDate.month}/${f.handoverDate.year}', style: TextStyle(fontSize: 12, color: textMutedColor)),
                              ],
                            ),
                            const SizedBox(height: 14),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  f.nextFollowUpDate != null
                                      ? 'Next Action Scheduled: ${f.nextFollowUpDate!.day}/${f.nextFollowUpDate!.month}/${f.nextFollowUpDate!.year}'
                                      : 'No further follow-up required.',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                                ),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Calling ${f.customerName} at ${f.customerPhone}...')),
                                        );
                                      },
                                      icon: const Icon(Icons.phone_outlined, size: 14),
                                      label: const Text('Call'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF10B981),
                                        side: const BorderSide(color: Color(0xFF10B981)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('WhatsApp message opened for ${f.customerName}...')),
                                        );
                                      },
                                      icon: const Icon(Icons.chat_bubble_outline, size: 14),
                                      label: const Text('WhatsApp Greeting'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF25D366),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        elevation: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpi(String label, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: textMuted)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openLogFollowUpModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CustomerFollowupModal(
        onFollowUpLogged: (newFollowUp) {
          setState(() => _followUps.insert(0, newFollowUp));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Customer retention touchpoint logged for ${newFollowUp.customerName}!')),
          );
        },
      ),
    );
  }
}
