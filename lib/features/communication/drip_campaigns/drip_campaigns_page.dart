import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/drip_models.dart';

class DripCampaignsPage extends StatefulWidget {
  const DripCampaignsPage({super.key});

  @override
  State<DripCampaignsPage> createState() => _DripCampaignsPageState();
}

class _DripCampaignsPageState extends State<DripCampaignsPage> {
  int _selectedTabIndex = 0; // 0: All, 1: Active, 2: Paused
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  List<DripCampaign> get _allCampaigns => DripMockData.campaigns;

  List<DripCampaign> get _filteredCampaigns {
    return _allCampaigns.where((c) {
      if (_selectedTabIndex == 1 && !c.isActive) return false;
      if (_selectedTabIndex == 2 && c.isActive) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = c.name.toLowerCase().contains(q);
        final matchTrigger = c.triggerEvent.toLowerCase().contains(q);
        if (!matchName && !matchTrigger) return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openCreateDripModal([DripCampaign? initial]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateDripCampaignModal(
        initialCampaign: initial,
        onSuccess: () => setState(() {}),
      ),
    );
  }

  void _deleteCampaign(DripCampaign c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 10),
            Text('Delete Drip Sequence', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text('Are you sure you want to delete "${c.name}"? Active enrolled contacts will stop receiving steps.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                DripMockData.deleteCampaign(c.id);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Drip journey "${c.name}" deleted.')),
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

    final campaigns = _filteredCampaigns;
    final activeCount = _allCampaigns.where((c) => c.isActive).length;
    final totalEnrolled = _allCampaigns.fold<int>(0, (sum, c) => sum + c.totalEnrolled);
    final avgConversion = _allCampaigns.isNotEmpty
        ? (_allCampaigns.fold<double>(0.0, (sum, c) => sum + c.conversionRate) / _allCampaigns.length).toStringAsFixed(1)
        : '0.0';

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
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_mode_rounded, color: Color(0xFF8B5CF6), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Drip Campaigns & Automated Sequences',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Multi-Step Automated Funnel',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF8B5CF6)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Automate WhatsApp lead nurturing, quotation follow-up nudges, and post-handover warranty reviews based on pipeline triggers.',
                              style: TextStyle(fontSize: 13, color: textMuted),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _openCreateDripModal(),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Create Drip Funnel', style: TextStyle(fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
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
                                _buildMetricCard('Active Sequences', '$activeCount Running', '24/7 Automated', Icons.bolt_rounded, const Color(0xFF8B5CF6)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Total Enrolled Leads', '$totalEnrolled Contacts', 'Nurtured across funnels', Icons.groups_rounded, const Color(0xFF3B82F6)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Avg Meeting Conversion', '$avgConversion%', 'Leads converted to consults', Icons.trending_up_rounded, const Color(0xFF10B981)),
                                const SizedBox(height: 10),
                                _buildMetricCard('WhatsApp Delivery Health', '99.2%', 'Meta Tier 1 Verified', Icons.health_and_safety_rounded, const Color(0xFFF59E0B)),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: _buildMetricCard('Active Sequences', '$activeCount Running', '24/7 Automated', Icons.bolt_rounded, const Color(0xFF8B5CF6))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Total Enrolled Leads', '$totalEnrolled Contacts', 'Nurtured across funnels', Icons.groups_rounded, const Color(0xFF3B82F6))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Avg Meeting Conversion', '$avgConversion%', 'Leads converted to consults', Icons.trending_up_rounded, const Color(0xFF10B981))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('WhatsApp Delivery Health', '99.2%', 'Meta Tier 1 Verified', Icons.health_and_safety_rounded, const Color(0xFFF59E0B))),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Filters & Segmented Switch
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: TextStyle(fontSize: 13, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search drip funnels by campaign name or trigger criteria...',
                        hintStyle: TextStyle(fontSize: 13, color: textMuted),
                        prefixIcon: Icon(Icons.search_rounded, size: 20, color: textMuted),
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  SegmentedButton<int>(
                    segments: [
                      ButtonSegment<int>(
                        value: 0,
                        label: Text('All (${_allCampaigns.length})'),
                        icon: const Icon(Icons.hub_rounded, size: 16),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text('Active ($activeCount)'),
                        icon: const Icon(Icons.play_arrow_rounded, size: 16),
                      ),
                      ButtonSegment<int>(
                        value: 2,
                        label: Text('Paused (${_allCampaigns.length - activeCount})'),
                        icon: const Icon(Icons.pause_rounded, size: 16),
                      ),
                    ],
                    selected: {_selectedTabIndex},
                    onSelectionChanged: (set) => setState(() => _selectedTabIndex = set.first),
                  ),
                ],
              ),
            ),
          ),

          // Drip Campaigns List
          campaigns.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_mode_rounded, size: 54, color: textMuted),
                        const SizedBox(height: 14),
                        Text('No drip campaigns found.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _openCreateDripModal(),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Create First Drip Journey'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
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
                        return _buildDripCard(context, c, isDark, surfaceColor, borderColor, textPrimary, textMuted);
                      },
                      childCount: campaigns.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildDripCard(
    BuildContext context,
    DripCampaign c,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: c.isActive ? const Color(0xFF8B5CF6).withValues(alpha: 0.5) : borderColor,
          width: c.isActive ? 1.5 : 1.0,
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
            // Top Row (Title + Trigger + Switch)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (c.isActive ? const Color(0xFF8B5CF6) : const Color(0xFF64748B)).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    c.isActive ? Icons.bolt_rounded : Icons.pause_circle_outline_rounded,
                    color: c.isActive ? const Color(0xFF8B5CF6) : const Color(0xFF64748B),
                    size: 22,
                  ),
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
                          Switch(
                            value: c.isActive,
                            activeThumbColor: const Color(0xFF8B5CF6),
                            activeTrackColor: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                            onChanged: (val) {
                              setState(() {
                                DripMockData.toggleStatus(c.id, val);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.flash_on_rounded, size: 11, color: Color(0xFF3B82F6)),
                                const SizedBox(width: 4),
                                Text(c.triggerEvent, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF3B82F6))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('${c.steps.length} Automated Sequence Steps', style: TextStyle(fontSize: 12, color: textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Text(c.description, style: TextStyle(fontSize: 12.5, color: textMuted)),
            const SizedBox(height: 16),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 16),

            // Step Timeline Cards Horizontal
            Text('SEQUENCE TIMELINE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: textMuted)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(c.steps.length, (sIdx) {
                  final step = c.steps[sIdx];
                  final isLast = sIdx == c.steps.length - 1;

                  return Row(
                    children: [
                      Container(
                        width: 240,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('Step ${step.stepIndex}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF8B5CF6))),
                                ),
                                Text(step.delayLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textMuted)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              step.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              step.messagePreview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, color: textMuted, height: 1.3),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('CTA: ${step.actionCta}', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded, size: 16, color: textMuted),
                        ),
                      ],
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 12),

            // Performance Bar & Actions
            Row(
              children: [
                _buildStatChip('Enrolled', '${c.totalEnrolled}', const Color(0xFF3B82F6)),
                const SizedBox(width: 8),
                _buildStatChip('Active Queue', '${c.activeCount}', const Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                _buildStatChip('Completed', '${c.completedCount}', const Color(0xFF10B981)),
                const SizedBox(width: 8),
                _buildStatChip('Consultation Conversion', '${c.conversionRate}%', const Color(0xFF8B5CF6)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  tooltip: 'Clone Journey',
                  onPressed: () => _openCreateDripModal(c),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                  tooltip: 'Delete Drip',
                  onPressed: () => _deleteCampaign(c),
                ),
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

class _CreateDripCampaignModal extends StatefulWidget {
  final DripCampaign? initialCampaign;
  final VoidCallback onSuccess;

  const _CreateDripCampaignModal({
    this.initialCampaign,
    required this.onSuccess,
  });

  @override
  State<_CreateDripCampaignModal> createState() => _CreateDripCampaignModalState();
}

class _CreateDripCampaignModalState extends State<_CreateDripCampaignModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  String _selectedTrigger = 'Lead Stage Changed -> "Qualified Prospect"';

  final List<String> _triggers = [
    'Lead Stage Changed -> "Qualified Prospect"',
    'Quotation Status -> "Sent to Client"',
    'Project Milestone -> "Final Handover Completed"',
    'Site Visit Booking Confirmed',
    '3D VR Walkthrough Link Clicked',
  ];

  @override
  void initState() {
    super.initState();
    final init = widget.initialCampaign;
    _nameCtrl = TextEditingController(text: init != null ? '${init.name} (Copy)' : '');
    _descCtrl = TextEditingController(text: init?.description ?? 'Automated nurture sequence to accelerate client conversion.');
    if (init != null) {
      _selectedTrigger = init.triggerEvent;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newCampaign = DripCampaign(
      id: 'DRIP-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: _nameCtrl.text.trim(),
      triggerEvent: _selectedTrigger,
      description: _descCtrl.text.trim(),
      isActive: true,
      totalEnrolled: 0,
      completedCount: 0,
      activeCount: 0,
      conversionRate: 0.0,
      dateCreated: DateTime.now(),
      steps: [
        const DripStep(
          id: 'step-1',
          stepIndex: 1,
          dayDelay: 0,
          hourDelay: 1,
          title: 'Immediate Onboarding & Lookbook Digest',
          templateName: 'intro_welcome_v1',
          messagePreview: 'Namaste {{1}}! Welcome to Homio. Review our design lookbook.',
          actionCta: 'View Lookbook',
        ),
        const DripStep(
          id: 'step-2',
          stepIndex: 2,
          dayDelay: 3,
          title: '3D Virtual Walkthrough Invitation',
          templateName: 'vr_tour_nudge',
          messagePreview: 'Experience our photo-realistic 3D villa twin.',
          actionCta: 'Launch 3D Tour',
        ),
        const DripStep(
          id: 'step-3',
          stepIndex: 3,
          dayDelay: 7,
          title: 'Architect Consultation Booking',
          templateName: 'book_consult_followup',
          messagePreview: 'Book your complimentary on-site measurement session.',
          actionCta: 'Book Architect Slot',
        ),
      ],
    );

    DripMockData.addCampaign(newCampaign);
    widget.onSuccess();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        content: Text('Drip Funnel "${newCampaign.name}" activated!'),
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
        width: 700,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
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
            // Modal Header
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
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_mode_rounded, color: Color(0xFF8B5CF6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create Automated Drip Journey', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
                        const SizedBox(height: 2),
                        Text('Set up pipeline triggers, delay offsets, and step progression rules.', style: TextStyle(fontSize: 12, color: textMuted)),
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

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Drip Sequence Name *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameCtrl,
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          hintText: 'e.g. Luxury Villa Pre-Possession Nurture Journey',
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Sequence name is required' : null,
                      ),
                      const SizedBox(height: 16),

                      Text('Pipeline Trigger Event *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedTrigger,
                        dropdownColor: surfaceColor,
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        ),
                        items: _triggers.map((trg) {
                          return DropdownMenuItem(value: trg, child: Text(trg));
                        }).toList(),
                        onChanged: (v) => setState(() => _selectedTrigger = v ?? _selectedTrigger),
                      ),
                      const SizedBox(height: 16),

                      Text('Sequence Description *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Describe the objective of this automated WhatsApp drip...',
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
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
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: const Text('Deploy & Activate Sequence', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
