import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/broadcast_models.dart';
import '../models/broadcast_mock_data.dart';

class BroadcastsScheduledPage extends StatefulWidget {
  const BroadcastsScheduledPage({super.key});

  @override
  State<BroadcastsScheduledPage> createState() => _BroadcastsScheduledPageState();
}

class _BroadcastsScheduledPageState extends State<BroadcastsScheduledPage> {
  int _selectedTabIndex = 0; // 0: All, 1: Scheduled Queue, 2: Sent / Completed, 3: Drafts
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  List<BroadcastCampaign> get _allCampaigns => BroadcastMockData.campaigns;

  List<BroadcastCampaign> get _filteredCampaigns {
    return _allCampaigns.where((c) {
      if (_selectedTabIndex == 1 && c.status != CampaignStatus.scheduled) return false;
      if (_selectedTabIndex == 2 && c.status != CampaignStatus.sent && c.status != CampaignStatus.sending) return false;
      if (_selectedTabIndex == 3 && c.status != CampaignStatus.draft && c.status != CampaignStatus.cancelled) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = c.name.toLowerCase().contains(q);
        final matchSegment = c.audienceSegment.toLowerCase().contains(q);
        final matchTemplate = c.templateName.toLowerCase().contains(q);
        if (!matchTitle && !matchSegment && !matchTemplate) return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openNewBroadcastModal([BroadcastCampaign? initial]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _NewBroadcastComposerModal(
        initialCampaign: initial,
        onSuccess: () => setState(() {}),
      ),
    );
  }

  void _rescheduleCampaign(BroadcastCampaign campaign) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: campaign.scheduledAt ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(campaign.scheduledAt ?? now.add(const Duration(hours: 2))),
      );

      if (pickedTime != null) {
        final newSchedule = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          BroadcastMockData.rescheduleCampaign(campaign.id, newSchedule);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF3B82F6),
              content: Text('Campaign rescheduled to ${DateFormat('MMM dd, yyyy • hh:mm a').format(newSchedule)}'),
            ),
          );
        }
      }
    }
  }

  void _cancelCampaign(BroadcastCampaign campaign) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: Color(0xFFEF4444)),
            SizedBox(width: 10),
            Text('Cancel Scheduled Blast', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text('Are you sure you want to cancel the scheduled campaign "${campaign.name}"? It will not be dispatched.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Back')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                BroadcastMockData.cancelScheduled(campaign.id);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Campaign "${campaign.name}" has been cancelled.')),
              );
            },
            child: const Text('Cancel Broadcast'),
          ),
        ],
      ),
    );
  }

  void _deleteCampaign(BroadcastCampaign campaign) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 10),
            Text('Delete Campaign', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text('Permanently delete "${campaign.name}" and its associated metrics?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                BroadcastMockData.deleteCampaign(campaign.id);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Campaign deleted.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textMuted = AppColors.getTextMuted(context);

    final scheduledCount = _allCampaigns.where((c) => c.status == CampaignStatus.scheduled).length;
    final sentCount = _allCampaigns.where((c) => c.status == CampaignStatus.sent).length;
    final totalRecipientsSent = _allCampaigns.where((c) => c.status == CampaignStatus.sent).fold<int>(0, (sum, c) => sum + c.recipientCount);
    final totalDelivered = _allCampaigns.where((c) => c.status == CampaignStatus.sent).fold<int>(0, (sum, c) => sum + c.deliveredCount);
    final totalRead = _allCampaigns.where((c) => c.status == CampaignStatus.sent).fold<int>(0, (sum, c) => sum + c.readCount);

    final avgDeliveryRate = totalRecipientsSent > 0 ? (totalDelivered / totalRecipientsSent * 100).toStringAsFixed(1) : '98.6';
    final avgReadRate = totalDelivered > 0 ? (totalRead / totalDelivered * 100).toStringAsFixed(1) : '89.2';

    final campaigns = _filteredCampaigns;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.campaign_rounded, color: Color(0xFF25D366), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Broadcasts & Scheduled Queue Hub',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Meta Cloud API Verified',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Consolidated bulk message blast manager with instant dispatch, scheduled calendar queues, and live delivery analytics.',
                              style: TextStyle(fontSize: 13, color: textMuted),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _openNewBroadcastModal(),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('New Broadcast / Scheduled Blast', style: TextStyle(fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Metrics Cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 700;
                      return isMobile
                          ? Column(
                              children: [
                                _buildMetricCard('Scheduled in Queue', '$scheduledCount Campaigns', 'Next run in 18 hrs', Icons.schedule_send_rounded, const Color(0xFF3B82F6)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Delivered Campaigns', '$sentCount Sent', '$totalRecipientsSent Total Messages', Icons.done_all_rounded, const Color(0xFF10B981)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Avg Delivery Rate', '$avgDeliveryRate%', 'Meta Verified Webhooks', Icons.verified_rounded, const Color(0xFFF59E0B)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Avg Read Rate', '$avgReadRate%', 'Customer Engagement', Icons.visibility_rounded, const Color(0xFF8B5CF6)),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: _buildMetricCard('Scheduled in Queue', '$scheduledCount Campaigns', 'Next run in 18 hrs', Icons.schedule_send_rounded, const Color(0xFF3B82F6))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Delivered Campaigns', '$sentCount Sent', '$totalRecipientsSent Total Messages', Icons.done_all_rounded, const Color(0xFF10B981))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Avg Delivery Rate', '$avgDeliveryRate%', 'Meta Verified Webhooks', Icons.verified_rounded, const Color(0xFFF59E0B))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Avg Read Rate', '$avgReadRate%', 'Customer Engagement', Icons.visibility_rounded, const Color(0xFF8B5CF6))),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Search & Segment Toolbar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Search Input
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: TextStyle(fontSize: 13, color: textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Search broadcasts by campaign name, target audience, or template...',
                            hintStyle: TextStyle(fontSize: 13, color: textMuted),
                            prefixIcon: Icon(Icons.search_rounded, size: 20, color: textMuted),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Segment Filter
                      SegmentedButton<int>(
                        segments: [
                          ButtonSegment<int>(
                            value: 0,
                            label: Text('All (${_allCampaigns.length})'),
                            icon: const Icon(Icons.list_alt_rounded, size: 16),
                          ),
                          ButtonSegment<int>(
                            value: 1,
                            label: Text('Scheduled Queue ($scheduledCount)'),
                            icon: const Icon(Icons.schedule_rounded, size: 16),
                          ),
                          ButtonSegment<int>(
                            value: 2,
                            label: Text('Sent / Delivered ($sentCount)'),
                            icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                          ),
                          const ButtonSegment<int>(
                            value: 3,
                            label: Text('Drafts'),
                            icon: Icon(Icons.edit_note_rounded, size: 16),
                          ),
                        ],
                        selected: {_selectedTabIndex},
                        onSelectionChanged: (set) => setState(() => _selectedTabIndex = set.first),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // List View
          campaigns.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.campaign_outlined, size: 54, color: textMuted),
                        const SizedBox(height: 14),
                        Text('No broadcast campaigns found.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
                        const SizedBox(height: 6),
                        Text('Create your first bulk blast or schedule an automated customer message.', style: TextStyle(fontSize: 13, color: textMuted)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _openNewBroadcastModal(),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Create New Campaign'),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final c = campaigns[index];
                        return _buildCampaignCard(context, c, isDark, surfaceColor, borderColor, textPrimary, textMuted);
                      },
                      childCount: campaigns.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(
    BuildContext context,
    BroadcastCampaign c,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    final isScheduled = c.status == CampaignStatus.scheduled;
    final isSent = c.status == CampaignStatus.sent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isScheduled ? const Color(0xFF3B82F6).withValues(alpha: 0.5) : borderColor,
          width: isScheduled ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row (Title + Status Badge + Action Menu)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.channel.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(c.channel.icon, color: c.channel.color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: c.status.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: c.status.color.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(c.status.icon, size: 13, color: c.status.color),
                                const SizedBox(width: 5),
                                Text(
                                  c.status.label.toUpperCase(),
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: c.status.color),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Audience: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textMuted)),
                          Text(c.audienceSegment, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                          const SizedBox(width: 12),
                          Text('• Template: ', style: TextStyle(fontSize: 12, color: textMuted)),
                          Text(c.templateName, style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 14),

            // Message Snippet Preview Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor.withValues(alpha: 0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote_rounded, size: 18, color: Color(0xFF25D366)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      c.messageBody,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.5, color: textPrimary, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Metrics Strip / Scheduled Timing + Actions
            Row(
              children: [
                if (isScheduled) ...[
                  Icon(Icons.access_time_filled_rounded, size: 16, color: const Color(0xFF3B82F6)),
                  const SizedBox(width: 6),
                  Text(
                    'Scheduled for: ${c.scheduledAt != null ? DateFormat('EEEE, MMM dd, yyyy • hh:mm a').format(c.scheduledAt!) : 'Pending'}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF3B82F6)),
                  ),
                ] else if (isSent) ...[
                  Expanded(
                    child: Row(
                      children: [
                        _buildStatChip('Recipients', '${c.recipientCount}', const Color(0xFF64748B)),
                        const SizedBox(width: 10),
                        _buildStatChip('Delivered', '${c.deliveredCount} (${c.deliveryRate.toStringAsFixed(0)}%)', const Color(0xFF10B981)),
                        const SizedBox(width: 10),
                        _buildStatChip('Read', '${c.readCount} (${c.readRate.toStringAsFixed(0)}%)', const Color(0xFF3B82F6)),
                        const SizedBox(width: 10),
                        _buildStatChip('Replies', '${c.repliedCount}', const Color(0xFF8B5CF6)),
                      ],
                    ),
                  ),
                ] else ...[
                  Text(
                    'Status: ${c.status.label}',
                    style: TextStyle(fontSize: 12.5, color: textMuted),
                  ),
                ],

                const Spacer(),

                // Actions
                if (isScheduled) ...[
                  OutlinedButton.icon(
                    onPressed: () => _rescheduleCampaign(c),
                    icon: const Icon(Icons.edit_calendar_rounded, size: 15),
                    label: const Text('Reschedule', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _cancelCampaign(c),
                    icon: const Icon(Icons.cancel_outlined, size: 15),
                    label: const Text('Cancel Blast', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
                      foregroundColor: const Color(0xFFEF4444),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ] else ...[
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, size: 18, color: textMuted),
                    tooltip: 'Campaign Actions',
                    onSelected: (val) {
                      if (val == 'duplicate') _openNewBroadcastModal(c);
                      if (val == 'delete') _deleteCampaign(c);
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.copy_rounded, size: 16, color: Color(0xFF3B82F6)),
                            SizedBox(width: 8),
                            Text('Clone Campaign', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                            SizedBox(width: 8),
                            Text('Delete Campaign', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, IconData icon, Color color) {
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextMuted(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
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
                Text(title, style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewBroadcastComposerModal extends StatefulWidget {
  final BroadcastCampaign? initialCampaign;
  final VoidCallback onSuccess;

  const _NewBroadcastComposerModal({
    this.initialCampaign,
    required this.onSuccess,
  });

  @override
  State<_NewBroadcastComposerModal> createState() => _NewBroadcastComposerModalState();
}

class _NewBroadcastComposerModalState extends State<_NewBroadcastComposerModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late String _selectedAudience;
  late WhatsAppTemplateOption _selectedTemplate;
  bool _isScheduled = false;
  DateTime _scheduledDateTime = DateTime.now().add(const Duration(hours: 4));

  @override
  void initState() {
    super.initState();
    final init = widget.initialCampaign;
    _nameCtrl = TextEditingController(text: init != null ? '${init.name} (Copy)' : '');
    _selectedAudience = init?.audienceSegment ?? BroadcastMockData.audienceSegments.first;
    _selectedTemplate = BroadcastMockData.templates.firstWhere(
      (t) => t.name == init?.templateName,
      orElse: () => BroadcastMockData.templates.first,
    );
    _isScheduled = init?.status == CampaignStatus.scheduled;
    if (init?.scheduledAt != null) {
      _scheduledDateTime = init!.scheduledAt!;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final recipients = int.tryParse(RegExp(r'\d+').firstMatch(_selectedAudience)?.group(0) ?? '100') ?? 100;

    final newCampaign = BroadcastCampaign(
      id: 'BC-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: _nameCtrl.text.trim(),
      templateName: _selectedTemplate.name,
      messageBody: _selectedTemplate.bodyText,
      audienceSegment: _selectedAudience,
      recipientCount: recipients,
      status: _isScheduled ? CampaignStatus.scheduled : CampaignStatus.sent,
      scheduledAt: _isScheduled ? _scheduledDateTime : null,
      sentAt: _isScheduled ? null : DateTime.now(),
      deliveredCount: _isScheduled ? 0 : (recipients * 0.98).toInt(),
      readCount: _isScheduled ? 0 : (recipients * 0.88).toInt(),
      repliedCount: _isScheduled ? 0 : (recipients * 0.22).toInt(),
      tags: [_selectedTemplate.category, _isScheduled ? 'Scheduled Queue' : 'Direct Blast'],
    );

    BroadcastMockData.addCampaign(newCampaign);
    widget.onSuccess();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        content: Text(
          _isScheduled
              ? 'Campaign "${newCampaign.name}" scheduled for ${DateFormat('MMM dd • hh:mm a').format(_scheduledDateTime)}'
              : 'Broadcast "${newCampaign.name}" dispatched to $recipients recipients via WhatsApp Cloud API!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textMuted = AppColors.getTextMuted(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 720,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.90),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.send_rounded, color: Color(0xFF25D366), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create WhatsApp Broadcast / Scheduled Blast',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Choose audience lists, official Meta template, and dispatch timing (Send Now vs Schedule).',
                          style: TextStyle(fontSize: 12, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: textMuted),
                  ),
                ],
              ),
            ),

            // Body Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campaign Title
                      Text('1. Campaign Title & Objective *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameCtrl,
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          hintText: 'e.g. Diwali Festive Turnkey Interior Offer 2026',
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Campaign title is required' : null,
                      ),
                      const SizedBox(height: 18),

                      // Audience Selector
                      Text('2. Target Audience Segment *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedAudience,
                        dropdownColor: surfaceColor,
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        ),
                        items: BroadcastMockData.audienceSegments.map((seg) {
                          return DropdownMenuItem(value: seg, child: Text(seg));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedAudience = val ?? _selectedAudience),
                      ),
                      const SizedBox(height: 18),

                      // WhatsApp Template Selector
                      Text('3. Meta Verified Template *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<WhatsAppTemplateOption>(
                        initialValue: _selectedTemplate,
                        dropdownColor: surfaceColor,
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        ),
                        items: BroadcastMockData.templates.map((tpl) {
                          return DropdownMenuItem(
                            value: tpl,
                            child: Row(
                              children: [
                                const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
                                const SizedBox(width: 8),
                                Text('${tpl.name} (${tpl.category})'),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedTemplate = val ?? _selectedTemplate),
                      ),
                      const SizedBox(height: 14),

                      // Live WhatsApp Bubble Preview
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEAE2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFDAD3C8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.chat_bubble_rounded, size: 14, color: Color(0xFF075E54)),
                                SizedBox(width: 6),
                                Text(
                                  'Live WhatsApp Message Preview (Recipient View)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF075E54)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedTemplate.bodyText,
                                    style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                                  ),
                                  const SizedBox(height: 8),
                                  const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('12:45 PM', style: TextStyle(fontSize: 10, color: Colors.black45)),
                                        SizedBox(width: 4),
                                        Icon(Icons.done_all, size: 14, color: Color(0xFF34B7F1)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Timing Switch: Send Now vs Schedule for Later
                      Text('4. Dispatch Timing *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => setState(() => _isScheduled = false),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: !_isScheduled ? const Color(0xFFF59E0B).withValues(alpha: 0.1) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: !_isScheduled ? const Color(0xFFF59E0B) : borderColor.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      !_isScheduled ? Icons.radio_button_checked : Icons.radio_button_off,
                                      color: !_isScheduled ? const Color(0xFFF59E0B) : textMuted,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Send Immediately (Real-Time Blast)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                          SizedBox(height: 2),
                                          Text('Dispatches message to Meta Cloud API queue instantaneously.', style: TextStyle(fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.flash_on_rounded, color: Color(0xFFF59E0B), size: 20),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () => setState(() => _isScheduled = true),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isScheduled ? const Color(0xFF3B82F6).withValues(alpha: 0.1) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _isScheduled ? const Color(0xFF3B82F6) : borderColor.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _isScheduled ? Icons.radio_button_checked : Icons.radio_button_off,
                                      color: _isScheduled ? const Color(0xFF3B82F6) : textMuted,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Schedule for Later (Queue to Calendar)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                          SizedBox(height: 2),
                                          Text('Holds campaign in queue and triggers automatically at the set date/time.', style: TextStyle(fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.schedule_send_rounded, color: Color(0xFF3B82F6), size: 20),
                                  ],
                                ),
                              ),
                            ),
                            if (_isScheduled) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.event_available_rounded, color: Color(0xFF3B82F6), size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        DateFormat('EEEE, MMM dd, yyyy • hh:mm a').format(_scheduledDateTime),
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF3B82F6)),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        final now = DateTime.now();
                                        final d = await showDatePicker(
                                          context: context,
                                          initialDate: _scheduledDateTime,
                                          firstDate: now,
                                          lastDate: now.add(const Duration(days: 365)),
                                        );
                                        if (d == null || !context.mounted) return;

                                        final t = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(_scheduledDateTime),
                                        );
                                        if (t == null || !context.mounted) return;

                                        setState(() {
                                          _scheduledDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                                        });
                                      },
                                      icon: const Icon(Icons.edit_calendar, size: 14),
                                      label: const Text('Change Date/Time', style: TextStyle(fontSize: 11)),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: Icon(_isScheduled ? Icons.schedule_send_rounded : Icons.send_rounded, size: 16),
                    label: Text(
                      _isScheduled ? 'Schedule Blast' : 'Send Immediate Broadcast',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isScheduled ? const Color(0xFF3B82F6) : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 0,
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
