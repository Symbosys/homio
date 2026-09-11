import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_models.dart';
import '../models/admin_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class MessageTemplatesPage extends StatefulWidget {
  const MessageTemplatesPage({super.key});

  @override
  State<MessageTemplatesPage> createState() => _MessageTemplatesPageState();
}

class _MessageTemplatesPageState extends State<MessageTemplatesPage> {
  // State
  List<MessageTemplate> _templates = [];
  MessageTemplate? _selectedTemplateForEdit;
  bool _isEditorOpen = false;

  // Search & Filter
  String _searchQuery = '';
  TemplateChannel? _selectedChannelFilter;
  TemplateApprovalState? _selectedStatusFilter;
  String? _selectedCategoryFilter;

  // Dynamic Variables Registry
  final List<TemplateVariable> _availableVariables = const [
    TemplateVariable(key: 'Customer Name', label: 'Customer Full Name', category: 'Customer', sampleValue: 'Siddharth Malhotra'),
    TemplateVariable(key: 'Project Name', label: 'Tagged Project / Flat', category: 'Project', sampleValue: 'Penthouse 1402, Worli'),
    TemplateVariable(key: 'Lead Name', label: 'Prospect Name', category: 'Lead', sampleValue: 'Siddharth Malhotra'),
    TemplateVariable(key: 'Meeting Date', label: 'Consultation Date', category: 'Meeting', sampleValue: '15th Sept 2026'),
    TemplateVariable(key: 'Meeting Time', label: 'Consultation Time', category: 'Meeting', sampleValue: '4:30 PM IST'),
    TemplateVariable(key: 'Quotation Number', label: 'BOQ Code', category: 'Quotation', sampleValue: 'HOM-QTE-8924'),
    TemplateVariable(key: 'Quotation Amount', label: 'Total Value (₹)', category: 'Quotation', sampleValue: '₹34,50,000'),
    TemplateVariable(key: 'Payment Amount', label: 'Installment Due (₹)', category: 'Payment', sampleValue: '₹4,20,000'),
    TemplateVariable(key: 'Payment Link', label: 'Secure Razorpay Checkout', category: 'Payment', sampleValue: 'https://pay.homio.in/inv_99812'),
    TemplateVariable(key: 'Approval Link', label: 'Client Sign-off URL', category: 'Approval', sampleValue: 'https://client.homio.in/approvals/881'),
    TemplateVariable(key: 'Employee Name', label: 'Staff / Architect Name', category: 'Staff', sampleValue: 'Ar. Ananya Deshmukh'),
    TemplateVariable(key: 'Company Contact', label: 'Official Care Phone', category: 'Company', sampleValue: '+91 80 4719 2200'),
    TemplateVariable(key: 'Digital Store Link', label: 'Lookbook URL', category: 'Marketing', sampleValue: 'https://homio.in/lookbook-2026'),
    TemplateVariable(key: 'Milestone Name', label: 'Active Site Stage', category: 'Project', sampleValue: 'False Ceiling & Rough-in'),
  ];

  @override
  void initState() {
    super.initState();
    _templates = List.from(AdminMockData.messageTemplates);
  }

  List<MessageTemplate> get _filteredTemplates {
    return _templates.where((tmpl) {
      if (_selectedChannelFilter != null && tmpl.channel != _selectedChannelFilter) {
        return false;
      }
      if (_selectedStatusFilter != null && tmpl.status != _selectedStatusFilter) {
        return false;
      }
      if (_selectedCategoryFilter != null && tmpl.category != _selectedCategoryFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = tmpl.name.toLowerCase().contains(q) ||
            tmpl.code.toLowerCase().contains(q) ||
            tmpl.triggerEvent.toLowerCase().contains(q) ||
            tmpl.messageBody.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                AdminHeader(
                  title: 'Message Templates Hub',
                  description: 'Manage standardized WhatsApp, Email, and SMS communication templates, dynamic variables, and event triggers.',
                  icon: Icons.mark_chat_unread_rounded,
                  breadcrumbs: const ['Homio Administration', 'Platform Configuration', 'Message Templates'],
                  actions: [
                    ElevatedButton.icon(
                      onPressed: () => _openCreateTemplateEditor(),
                      icon: const Icon(Icons.add_comment_rounded, size: 16),
                      label: const Text('Create Template', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Metrics Ribbon
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Total Templates',
                      value: '${_templates.length}',
                      subtitle: '4 Supported Channels',
                      icon: Icons.collections_bookmark_outlined,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'WhatsApp Cloud API',
                      value: '${_templates.where((t) => t.channel == TemplateChannel.whatsApp).length} Live',
                      subtitle: 'Meta pre-approved',
                      icon: Icons.chat_bubble_outline_rounded,
                      color: const Color(0xFF25D366),
                    ),
                    AdminMetricItem(
                      label: 'Active Automations',
                      value: '14 Triggers',
                      subtitle: 'Event driven dispatches',
                      icon: Icons.smart_toy_outlined,
                      color: AppColors.secondary,
                    ),
                    AdminMetricItem(
                      label: 'Published State',
                      value: '100% Operational',
                      subtitle: 'Zero broken variables',
                      icon: Icons.check_circle_outline,
                      color: AppColors.success,
                    ),
                  ],
                ),

                // 3. Search & Channel Filter Bar
                AdminFilterBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: (q) => setState(() => _searchQuery = q),
                  searchHint: 'Search templates by code, name, trigger event, message body...',
                  filterControls: [
                    DropdownButton<TemplateChannel?>(
                      value: _selectedChannelFilter,
                      hint: const Text('Channel', style: TextStyle(fontSize: 12)),
                      underline: const SizedBox(),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Channels', style: TextStyle(fontSize: 12))),
                        for (final ch in TemplateChannel.values)
                          DropdownMenuItem(value: ch, child: Text(ch.label, style: const TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) => setState(() => _selectedChannelFilter = val),
                    ),
                    DropdownButton<TemplateApprovalState?>(
                      value: _selectedStatusFilter,
                      hint: const Text('Status', style: TextStyle(fontSize: 12)),
                      underline: const SizedBox(),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Statuses', style: TextStyle(fontSize: 12))),
                        for (final st in TemplateApprovalState.values)
                          DropdownMenuItem(value: st, child: Text(st.label, style: const TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) => setState(() => _selectedStatusFilter = val),
                    ),
                  ],
                ),

                // 4. Template Cards Grid
                _filteredTemplates.isEmpty
                    ? _buildEmptyState(isDark)
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 440,
                          mainAxisExtent: 250,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _filteredTemplates.length,
                        itemBuilder: (context, index) {
                          final tmpl = _filteredTemplates[index];
                          return _buildTemplateCard(tmpl, isDark);
                        },
                      ),
              ],
            ),
          ),

          // Side-by-Side Template Editor & Customer Preview Modal
          if (_isEditorOpen && _selectedTemplateForEdit != null)
            _buildEditorAndPreviewOverlay(isDark, isMobile),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(MessageTemplate tmpl, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Row: Channel & Approval Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: tmpl.channel.brandColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(tmpl.channel.icon, color: tmpl.channel.brandColor, size: 17),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tmpl.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      Text('${tmpl.code} • Trigger: ${tmpl.triggerEvent}', style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                ),
                AdminStatusBadge(label: tmpl.status.label, color: tmpl.status.color),
              ],
            ),
            const SizedBox(height: 6),

            // Message Snippet Preview
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Text(
                tmpl.messageBody,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.35,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Footer Variables & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${tmpl.usedVariables.length} dynamic vars • ${tmpl.activeAutomationsCount} triggers',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedTemplateForEdit = tmpl;
                      _isEditorOpen = true;
                    });
                  },
                  icon: const Icon(Icons.edit_note_rounded, size: 14),
                  label: const Text('Edit & Preview', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // SIDE-BY-SIDE EDITOR & LIVE CUSTOMER PREVIEW
  // ==========================================================================
  Widget _buildEditorAndPreviewOverlay(bool isDark, bool isMobile) {
    final tmpl = _selectedTemplateForEdit!;
    final nameCtrl = TextEditingController(text: tmpl.name);
    final bodyCtrl = TextEditingController(text: tmpl.messageBody);

    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 1050,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 30)],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                ),
                child: Row(
                  children: [
                    Icon(tmpl.channel.icon, color: tmpl.channel.brandColor, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Template Editor & Live Preview: ${tmpl.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Channel: ${tmpl.channel.label} • Trigger: ${tmpl.triggerEvent}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => setState(() => _isEditorOpen = false),
                    ),
                  ],
                ),
              ),

              // Side by Side Body
              Expanded(
                child: Row(
                  children: [
                    // Left Column: Rich Controlled Editor
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: nameCtrl,
                              decoration: const InputDecoration(labelText: 'Template Name *', border: OutlineInputBorder()),
                            ),
                            const SizedBox(height: 14),

                            // Dynamic Variables Picker Bar
                            Text('Click to Insert Dynamic Variable:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _availableVariables.take(7).map((v) {
                                return ActionChip(
                                  label: Text('{{${v.key}}}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                  onPressed: () {
                                    final currentText = bodyCtrl.text;
                                    final cursor = bodyCtrl.selection.baseOffset;
                                    final insert = '{{${v.key}}}';
                                    if (cursor >= 0) {
                                      final newText = currentText.substring(0, cursor) + insert + currentText.substring(cursor);
                                      bodyCtrl.text = newText;
                                    } else {
                                      bodyCtrl.text = currentText + insert;
                                    }
                                    setState(() {
                                      _selectedTemplateForEdit = tmpl.copyWith(messageBody: bodyCtrl.text);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 14),

                            // Editor Text Area
                            Expanded(
                              child: TextField(
                                controller: bodyCtrl,
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                onChanged: (text) {
                                  setState(() {
                                    _selectedTemplateForEdit = tmpl.copyWith(messageBody: text);
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Message Body *',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const VerticalDivider(width: 1),

                    // Right Column: Live Customer Preview (e.g. WhatsApp balloon or Email container)
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: isDark ? AppColors.darkBackground : const Color(0xFFE5DDD5), // WhatsApp chat wallpaper tone
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Live Customer Preview', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black87)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Sample Interpolated Data', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // WhatsApp Chat Bubble Simulation
                            Expanded(
                              child: Center(
                                child: Container(
                                  constraints: const BoxConstraints(maxWidth: 340),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF005C4B) : const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _interpolateVariables(tmpl.messageBody),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          height: 1.4,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          '11:45 AM • Read ✓✓',
                                          style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.black45),
                                        ),
                                      ),
                                      if (tmpl.buttons.isNotEmpty) ...[
                                        const Divider(height: 16),
                                        for (final b in tmpl.buttons)
                                          Container(
                                            margin: const EdgeInsets.only(top: 4),
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.04),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              b.label,
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() => _isEditorOpen = false),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final idx = _templates.indexWhere((t) => t.id == tmpl.id);
                          if (idx != -1) {
                            _templates[idx] = tmpl.copyWith(
                              name: nameCtrl.text,
                              messageBody: bodyCtrl.text,
                              status: TemplateApprovalState.published,
                              updatedAt: DateTime.now(),
                            );
                          }
                          _isEditorOpen = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Template published and synced with communication triggers.'), backgroundColor: AppColors.success),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('Save & Publish Template'),
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

  String _interpolateVariables(String rawText) {
    var result = rawText;
    for (final v in _availableVariables) {
      result = result.replaceAll('{{${v.key}}}', v.sampleValue);
    }
    return result;
  }

  void _openCreateTemplateEditor() {
    final newTmpl = MessageTemplate(
      id: 'tmpl_${DateTime.now().millisecondsSinceEpoch}',
      code: 'WA-NEW-${_templates.length + 1}',
      name: 'Custom Promotional Notification',
      category: 'Sales & Promotions',
      description: 'Triggered upon ad-hoc broadcast',
      channel: TemplateChannel.whatsApp,
      triggerEvent: 'Stage Changed',
      messageBody: 'Hello {{Customer Name}},\n\nYour project {{Project Name}} has been updated!\n\nBest,\nTeam Homio',
      updatedAt: DateTime.now(),
      updatedBy: 'Vikramaditya Singhania',
    );
    setState(() {
      _selectedTemplateForEdit = newTmpl;
      _templates.insert(0, newTmpl);
      _isEditorOpen = true;
    });
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mark_chat_unread_outlined, size: 54, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text('No templates found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 6),
          Text('Create a new communication template to standardize client messaging.', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        ],
      ),
    );
  }
}
