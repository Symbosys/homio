// Homio CRM — Enterprise Drip Campaigns & Visual Automation Builder

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';
import '../widgets/comm_page_header.dart';
import '../widgets/comm_kpi_card.dart';
import '../widgets/comm_status_badge.dart';
import '../widgets/drip_workflow_canvas.dart';

class DripCampaignsPage extends StatefulWidget {
  const DripCampaignsPage({super.key});

  @override
  State<DripCampaignsPage> createState() => _DripCampaignsPageState();
}

class _DripCampaignsPageState extends State<DripCampaignsPage> {
  late List<DripCampaign> _campaigns;
  DripCampaign? _selectedCampaign;
  DripNode? _selectedNode;

  @override
  void initState() {
    super.initState();
    _campaigns = List.from(CommunicationMockData.dripCampaigns);
    if (_campaigns.isNotEmpty) {
      _selectedCampaign = _campaigns.first;
    }
  }

  void _showCreateCampaignDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    DripTriggerType trigger = DripTriggerType.leadCreated;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Create Automated Drip Journey', style: TextStyle(fontSize: 16)),
              content: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Campaign Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: 'e.g. 14-Day Luxury Villa Consultation Nurture',
                        filled: true,
                        fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Enrollment Trigger Event', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<DripTriggerType>(
                      initialValue: trigger,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: DripTriggerType.values.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t.label));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => trigger = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text('Campaign Objective & Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Brief summary of the automation goal...',
                        filled: true,
                        fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;

                    final newCamp = DripCampaign(
                      id: 'drip_${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      description: descCtrl.text.trim().isEmpty ? 'Automated nurture flow.' : descCtrl.text.trim(),
                      triggerType: trigger,
                      status: DripCampaignStatus.active,
                      targetAudienceDesc: 'All contacts meeting trigger criteria',
                      enrolledCount: 0,
                      activeCount: 0,
                      completedCount: 0,
                      failedCount: 0,
                      conversionRate: 0.0,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      nodes: [
                        const DripNode(
                          id: 'node_init',
                          type: DripNodeType.sendWhatsApp,
                          title: 'Welcome Message',
                          description: 'Initial WhatsApp outreach upon trigger.',
                          posX: 80,
                          posY: 100,
                          nextNodeIds: ['node_wait'],
                        ),
                        const DripNode(
                          id: 'node_wait',
                          type: DripNodeType.waitDuration,
                          title: 'Wait 2 Days',
                          description: 'Give time for customer review.',
                          posX: 340,
                          posY: 100,
                          nextNodeIds: ['node_end'],
                        ),
                        const DripNode(
                          id: 'node_end',
                          type: DripNodeType.endWorkflow,
                          title: 'End Journey',
                          description: 'Concluded.',
                          posX: 600,
                          posY: 100,
                        ),
                      ],
                    );

                    setState(() {
                      _campaigns.insert(0, newCamp);
                      _selectedCampaign = newCamp;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Campaign "$name" created.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Create Campaign'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final camp = _selectedCampaign;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CommPageHeader(
            title: 'Drip Campaigns & Visual Automation',
            subtitle: 'Automated omnichannel customer journeys from first inquiry to post-handover after-sales care',
            icon: Icons.water_drop_rounded,
            primaryActionLabel: 'New Campaign',
            primaryActionIcon: Icons.add_chart_outlined,
            onPrimaryAction: _showCreateCampaignDialog,
            onRefresh: () {
              setState(() {
                _campaigns = List.from(CommunicationMockData.dripCampaigns);
              });
            },
          ),

          // Main Layout
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Top KPI Metrics
                Row(
                  children: [
                    Expanded(
                      child: CommKpiCard(
                        title: 'Active Campaigns',
                        value: '${_campaigns.where((c) => c.status == DripCampaignStatus.active).length}',
                        subtitle: 'Running live',
                        icon: Icons.play_circle_outline,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Total Enrolled Contacts',
                        value: '842',
                        subtitle: 'Across all journeys',
                        icon: Icons.people_outline,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Avg. Journey Conversion',
                        value: '44.8%',
                        subtitle: 'Inquiry → Consultation / Booking',
                        icon: Icons.trending_up,
                        color: const Color(0xFF6366F1),
                        trendText: '+6.2% lift',
                        isTrendPositive: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Automation Errors',
                        value: '0',
                        subtitle: 'All webhook queues healthy',
                        icon: Icons.verified_user_outlined,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Campaign Selector Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _campaigns.map((c) {
                      final isSelected = camp?.id == c.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () => setState(() {
                            _selectedCampaign = c;
                            _selectedNode = null;
                          }),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1)
                                  : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_tree_outlined,
                                  size: 16,
                                  color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  c.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CommStatusBadge.fromDripStatus(c.status),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Selected Campaign Summary Card
                if (camp != null) ...[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(camp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(
                                  'Trigger: ${camp.triggerType.label} • Target: ${camp.targetAudienceDesc}',
                                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildMetricPill('Enrolled: ${camp.enrolledCount}', AppColors.primary, isDark),
                                const SizedBox(width: 8),
                                _buildMetricPill('Active: ${camp.activeCount}', const Color(0xFFF59E0B), isDark),
                                const SizedBox(width: 8),
                                _buildMetricPill('Completed: ${camp.completedCount}', const Color(0xFF10B981), isDark),
                                const SizedBox(width: 8),
                                _buildMetricPill('Conversion: ${(camp.conversionRate * 100).toStringAsFixed(1)}%', const Color(0xFF6366F1), isDark),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          camp.description,
                          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Visual Workflow Canvas
                  SizedBox(
                    height: 380,
                    child: DripWorkflowCanvas(
                      nodes: camp.nodes,
                      triggerType: camp.triggerType,
                      onNodeSelected: (node) {
                        setState(() => _selectedNode = node);
                      },
                      onAddNode: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening node palette (Action, Timing, Condition)...')),
                        );
                      },
                    ),
                  ),

                  // Selected Node Inspector Panel
                  if (_selectedNode != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_selectedNode!.type.icon, size: 18, color: _selectedNode!.type.color),
                              const SizedBox(width: 8),
                              Text(
                                'Step Inspector: ${_selectedNode!.title} (${_selectedNode!.type.label})',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () => setState(() => _selectedNode = null),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedNode!.description,
                            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                          if (_selectedNode!.config.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Configuration: ${_selectedNode!.config}',
                              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
