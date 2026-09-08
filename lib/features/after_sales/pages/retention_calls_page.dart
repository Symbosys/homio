import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';

class RetentionCallsPage extends StatefulWidget {
  const RetentionCallsPage({super.key});

  @override
  State<RetentionCallsPage> createState() => _RetentionCallsPageState();
}

class _RetentionCallsPageState extends State<RetentionCallsPage> {
  final List<RetentionCallRecord> _calls = List.from(AfterSalesMockData.retentionCalls);

  String _searchQuery = '';
  CallStatus? _filterStatus;
  bool _filterReviewsOnly = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final filteredCalls = _calls.where((c) {
      final matchesSearch = c.clientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.projectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.clientPhone.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == null || c.callStatus == _filterStatus;
      final matchesReviews = !_filterReviewsOnly || c.reviewPosted;

      return matchesSearch && matchesStatus && matchesReviews;
    }).toList();

    // CSAT Aggregations
    final completedCalls = _calls.where((c) => c.csatScore != null).toList();
    final avgCsat = completedCalls.isEmpty
        ? 0.0
        : completedCalls.fold<double>(0, (sum, c) => sum + (c.csatScore ?? 0)) / completedCalls.length;
    final avgDesign = completedCalls.isEmpty
        ? 0.0
        : completedCalls.fold<double>(0, (sum, c) => sum + (c.designQualityRating ?? 0)) / completedCalls.length;
    final avgTimeline = completedCalls.isEmpty
        ? 0.0
        : completedCalls.fold<double>(0, (sum, c) => sum + (c.timelineRating ?? 0)) / completedCalls.length;
    final avgBehaviour = completedCalls.isEmpty
        ? 0.0
        : completedCalls.fold<double>(0, (sum, c) => sum + (c.behaviourRating ?? 0)) / completedCalls.length;

    final reviewCount = _calls.where((c) => c.reviewPosted).length;
    final referralCount = _calls.where((c) => c.referralLeadName != null).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, avgCsat, reviewCount, referralCount, width),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: _buildCallsLedger(isDark, filteredCalls),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 4,
                    child: _buildCsatBreakdownPanel(isDark, avgDesign, avgTimeline, avgBehaviour),
                  ),
                ],
              )
            else ...[
              _buildCallsLedger(isDark, filteredCalls),
              const SizedBox(height: 24),
              _buildCsatBreakdownPanel(isDark, avgDesign, avgTimeline, avgBehaviour),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.ring_volume_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Client Retention & CSAT Reviews',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Post-handover customer satisfaction scoring, Google reviews automation & ₹10,000 referral loyalty rewards.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showScheduleCallModal(isDark),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Schedule Follow-Up'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiMetrics(bool isDark, double avgCsat, int reviewCount, int referralCount, double width) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Average CSAT Index',
        value: '${avgCsat.toStringAsFixed(1)} / 10',
        sub: 'Overall client satisfaction',
        icon: Icons.star_rounded,
        color: AppColors.gold,
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Google Reviews Captured',
        value: '$reviewCount 5-Star Reviews',
        sub: 'Dispatched via WhatsApp link',
        icon: Icons.thumb_up_rounded,
        color: const Color(0xFF10B981),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Referral Pipeline',
        value: '$referralCount Active Leads',
        sub: '₹10,000 loyalty vouchers',
        icon: Icons.card_giftcard_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Survey Compliance',
        value: '94.2% Concluded',
        sub: '30-60-90 day schedules',
        icon: Icons.checklist_rounded,
        color: const Color(0xFF8B5CF6),
      ),
    ];

    if (width < Breakpoints.compact) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
    );
  }

  Widget _buildMetricCard({
    required bool isDark,
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallsLedger(bool isDark, List<RetentionCallRecord> calls) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Post-Handover Retention Roster',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Calls'),
                    selected: _filterStatus == null && !_filterReviewsOnly,
                    onSelected: (_) => setState(() {
                      _filterStatus = null;
                      _filterReviewsOnly = false;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Scheduled'),
                    selected: _filterStatus == CallStatus.scheduled,
                    onSelected: (val) => setState(() {
                      _filterStatus = val ? CallStatus.scheduled : null;
                      _filterReviewsOnly = false;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Google Reviews'),
                    selected: _filterReviewsOnly,
                    selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                    onSelected: (val) => setState(() {
                      _filterReviewsOnly = val;
                      _filterStatus = null;
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              hintText: 'Search client name, project, or phone...',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (calls.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.phone_disabled_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No retention call records match the current filter.',
                      style: TextStyle(color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: calls.length,
              separatorBuilder: (_, _) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final call = calls[index];
                return _buildCallRow(isDark, call);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCallRow(bool isDark, RetentionCallRecord call) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                    child: Text(
                      call.clientName.substring(0, 2).toUpperCase(),
                      style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.clientName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                        ),
                      ),
                      Text(
                        '${call.projectName} • ${call.clientPhone}',
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (call.csatScore != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text(
                            '${call.csatScore!.toStringAsFixed(1)} / 10',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.gold),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  _buildCallStatusBadge(call.callStatus),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (call.feedbackNotes != null) ...[
            Text(
              call.feedbackNotes!,
              style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Text(
                'Handover: ${DateFormat('dd MMM yyyy').format(call.handoverDate)} • Scheduled: ${DateFormat('dd MMM yyyy').format(call.scheduledDate)}',
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
              const Spacer(),
              if (call.referralLeadName != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Referral: ${call.referralLeadName!}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (call.reviewPosted)
                    const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                        SizedBox(width: 5),
                        Text('Google 5-Star Review Live', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                      ],
                    )
                  else if (call.isHighSatisfaction)
                    OutlinedButton.icon(
                      onPressed: () => _sendGoogleReviewLink(call),
                      icon: const Icon(Icons.share_rounded, size: 13),
                      label: Text(call.reviewLinkSent ? 'Review Link Sent (Resend)' : 'Send WhatsApp Review Link'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                    ),
                ],
              ),
              Row(
                children: [
                  if (call.callStatus == CallStatus.scheduled)
                    ElevatedButton.icon(
                      onPressed: () => _showConductCallModal(isDark, call),
                      icon: const Icon(Icons.call_rounded, size: 14),
                      label: const Text('Conduct Call & Log CSAT'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.deepNavy,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallStatusBadge(CallStatus status) {
    Color color;
    switch (status) {
      case CallStatus.scheduled:
        color = const Color(0xFF3B82F6);
        break;
      case CallStatus.completed:
        color = const Color(0xFF10B981);
        break;
      case CallStatus.noAnswer:
        color = const Color(0xFFF59E0B);
        break;
      case CallStatus.rescheduled:
        color = const Color(0xFF64748B);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  Widget _buildCsatBreakdownPanel(bool isDark, double design, double timeline, double behaviour) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.insights_rounded, color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'CSAT Index Pillars',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'PRD Section 5.3: Triple-pillar weighted formula driving designer and site engineer quarterly appraisals.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),
          _buildPillarGauge(
            isDark: isDark,
            title: 'Design Quality & Render Fidelity',
            weight: '40% Weight',
            score: design,
            color: const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 16),
          _buildPillarGauge(
            isDark: isDark,
            title: 'Milestone & Handover Timeline',
            weight: '30% Weight',
            score: timeline,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          _buildPillarGauge(
            isDark: isDark,
            title: 'Team Conduct & Professionalism',
            weight: '30% Weight',
            score: behaviour,
            color: AppColors.gold,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.card_giftcard_rounded, size: 16, color: AppColors.gold),
                    SizedBox(width: 8),
                    Text(
                      'Referral Loyalty Incentive',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.gold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Clients recommending friends receive ₹10,000 instant wallet credit or 5% furniture store voucher upon friend\'s booking.',
                  style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarGauge({
    required bool isDark,
    required String title,
    required String weight,
    required double score,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.pureWhite : AppColors.deepNavy)),
            Text(
              '${score.toStringAsFixed(1)}/10 ($weight)',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 10.0,
            minHeight: 6,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  void _sendGoogleReviewLink(RetentionCallRecord call) {
    setState(() {
      final idx = _calls.indexWhere((c) => c.id == call.id);
      if (idx != -1) {
        _calls[idx] = call.copyWith(reviewLinkSent: true);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dispatched 5-Star Google Review invitation via WhatsApp to ${call.clientName} (${call.clientPhone})'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _showConductCallModal(bool isDark, RetentionCallRecord call) {
    double designScore = 9.0;
    double timelineScore = 9.0;
    double behaviourScore = 9.5;
    final notesCtrl = TextEditingController(text: 'Client was thoroughly impressed with interior finishing and snag resolution speed.');
    final referralNameCtrl = TextEditingController();
    final referralPhoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final overallCsat = (designScore * 0.4) + (timelineScore * 0.3) + (behaviourScore * 0.3);

          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Conduct Retention Call: ${call.clientName}',
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
            ),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project: ${call.projectName}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),
                    Text('Design Quality Score: ${designScore.toStringAsFixed(1)}/10', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Slider(
                      value: designScore,
                      min: 1,
                      max: 10,
                      divisions: 18,
                      onChanged: (val) => setDialogState(() => designScore = val),
                    ),
                    Text('Timeline Adherence Score: ${timelineScore.toStringAsFixed(1)}/10', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Slider(
                      value: timelineScore,
                      min: 1,
                      max: 10,
                      divisions: 18,
                      onChanged: (val) => setDialogState(() => timelineScore = val),
                    ),
                    Text('Team Behaviour & Professionalism: ${behaviourScore.toStringAsFixed(1)}/10', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Slider(
                      value: behaviourScore,
                      min: 1,
                      max: 10,
                      divisions: 18,
                      onChanged: (val) => setDialogState(() => behaviourScore = val),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Computed CSAT Index:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(
                            '${overallCsat.toStringAsFixed(2)} / 10',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.gold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Feedback Transcript / Notes *', border: OutlineInputBorder()), maxLines: 2),
                    const SizedBox(height: 14),
                    const Text('REFERRAL ACQUISITION (OPTIONAL)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: referralNameCtrl, decoration: const InputDecoration(labelText: 'Friend / Family Name', border: OutlineInputBorder()))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: referralPhoneCtrl, decoration: const InputDecoration(labelText: 'Friend Phone Number', border: OutlineInputBorder()))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final idx = _calls.indexWhere((c) => c.id == call.id);
                    if (idx != -1) {
                      _calls[idx] = call.copyWith(
                        callStatus: CallStatus.completed,
                        conductedDate: DateTime.now(),
                        csatScore: overallCsat,
                        designQualityRating: designScore,
                        timelineRating: timelineScore,
                        behaviourRating: behaviourScore,
                        feedbackNotes: notesCtrl.text.trim(),
                        referralLeadName: referralNameCtrl.text.trim().isNotEmpty ? referralNameCtrl.text.trim() : null,
                        referralLeadPhone: referralPhoneCtrl.text.trim().isNotEmpty ? referralPhoneCtrl.text.trim() : null,
                        referralRewardStatus: referralNameCtrl.text.trim().isNotEmpty ? ReferralRewardStatus.credited : null,
                      );
                    }
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logged CSAT score of ${overallCsat.toStringAsFixed(1)} for ${call.clientName}'),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
                child: const Text('Save CSAT & Complete Call'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showScheduleCallModal(bool isDark) {
    final clientCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final projCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Schedule Post-Handover Retention Call', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy)),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: clientCtrl, decoration: const InputDecoration(labelText: 'Client Name *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Client Phone *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: projCtrl, decoration: const InputDecoration(labelText: 'Project Name / Unit Code *', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (clientCtrl.text.trim().isEmpty) return;
              final newCall = RetentionCallRecord(
                id: 'RET-${DateTime.now().millisecondsSinceEpoch}',
                clientId: 'CLI-NEW',
                clientName: clientCtrl.text.trim(),
                clientPhone: phoneCtrl.text.trim(),
                projectName: projCtrl.text.trim(),
                handoverDate: DateTime.now().subtract(const Duration(days: 60)),
                scheduledDate: DateTime.now().add(const Duration(days: 1)),
                callStatus: CallStatus.scheduled,
                callerName: 'Priya Service Telecaller',
              );
              setState(() {
                _calls.insert(0, newCall);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Scheduled retention survey for ${newCall.clientName}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
            child: const Text('Schedule Call'),
          ),
        ],
      ),
    );
  }
}
