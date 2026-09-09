// Homio CRM — Enterprise WhatsApp & SMS Message Templates Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';
import '../widgets/comm_page_header.dart';
import '../widgets/comm_status_badge.dart';
import '../widgets/comm_filter_bar.dart';
import '../widgets/template_preview_card.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  late List<MessageTemplate> _templates;
  MessageTemplate? _selectedTemplate;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _templates = List.from(CommunicationMockData.templates);
    if (_templates.isNotEmpty) {
      _selectedTemplate = _templates.first;
    }
  }

  List<MessageTemplate> get _filteredTemplates {
    return _templates.where((t) {
      final q = _searchQuery.toLowerCase();
      if (q.isNotEmpty &&
          !t.name.toLowerCase().contains(q) &&
          !t.code.toLowerCase().contains(q) &&
          !t.bodyText.toLowerCase().contains(q)) {
        return false;
      }
      if (_selectedCategory != 'All' && t.category.label != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();
  }

  void _showCreateTemplateDialog() {
    final nameCtrl = TextEditingController();
    final bodyCtrl = TextEditingController(
      text: 'Hi {{customer_name}}, here is an update regarding your project {{project_name}}.',
    );
    final footerCtrl = TextEditingController(text: 'Homio Interior Studios');
    TemplateCategory cat = TemplateCategory.leadWelcome;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Create New WhatsApp Message Template', style: TextStyle(fontSize: 16)),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Template Display Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Consultation Followup V3',
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<TemplateCategory>(
                        initialValue: cat,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: TemplateCategory.values.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c.label));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => cat = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text('Body Text (use {{var}} for variables)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: bodyCtrl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Footer Text', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: footerCtrl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;

                    final newTpl = MessageTemplate(
                      id: 'tpl_${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      code: 'homio_${name.toLowerCase().replaceAll(' ', '_')}',
                      category: cat,
                      channel: CommunicationChannel.whatsapp,
                      status: TemplateStatus.pendingApproval,
                      bodyText: bodyCtrl.text.trim(),
                      footerText: footerCtrl.text.trim(),
                      variables: const [
                        TemplateVariable(key: 'customer_name', label: 'Customer Name', defaultValue: 'Client', sourceField: 'customer.name', sampleValue: 'Vikram'),
                        TemplateVariable(key: 'project_name', label: 'Project Name', defaultValue: 'Residence', sourceField: 'project.name', sampleValue: 'Windmills Villa'),
                      ],
                      lastUsedAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      createdBy: 'Current User',
                    );

                    setState(() {
                      _templates.insert(0, newTpl);
                      _selectedTemplate = newTpl;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Template "$name" submitted to Meta for approval.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Submit for Meta Approval'),
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

    final categories = ['All', ...TemplateCategory.values.map((c) => c.label)];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CommPageHeader(
            title: 'Message & Notification Templates',
            subtitle: 'Pre-approved WhatsApp Cloud API HSM templates and SMS notification blueprints with dynamic personalization',
            icon: Icons.dynamic_form_rounded,
            primaryActionLabel: 'Create Template',
            primaryActionIcon: Icons.add,
            onPrimaryAction: _showCreateTemplateDialog,
            onRefresh: () {
              setState(() {
                _templates = List.from(CommunicationMockData.templates);
              });
            },
          ),

          // Filters
          CommFilterBar(
            searchQuery: _searchQuery,
            onSearchChanged: (v) => setState(() => _searchQuery = v),
            searchHint: 'Search templates by name, code, or content keywords...',
            categories: categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
            onResetFilters: () {
              setState(() {
                _searchQuery = '';
                _selectedCategory = 'All';
              });
            },
          ),

          // 2-Column Workspace: Left List + Right Live Preview
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 960;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column: Template Cards Table / List
                    Expanded(
                      flex: 3,
                      child: _buildTemplateList(isDark),
                    ),

                    // Right Column: Live Interactive Preview Card
                    if (isDesktop && _selectedTemplate != null) ...[
                      SizedBox(
                        width: 440,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            border: Border(
                              left: BorderSide(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Live WhatsApp Rendering',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send, size: 16),
                                    tooltip: 'Send Test to My Phone',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Test message dispatched to registered developer phone.')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TemplatePreviewCard(template: _selectedTemplate!),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateList(bool isDark) {
    final filtered = _filteredTemplates;

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Text(
            'No templates match the selected filter criteria.',
            style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      separatorBuilder: (_, i) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final tpl = filtered[idx];
        final isSelected = _selectedTemplate?.id == tpl.id;

        return InkWell(
          onTap: () => setState(() => _selectedTemplate = tpl),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08)
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tpl.channel.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(tpl.channel.icon, color: tpl.channel.color, size: 20),
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
                              tpl.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CommStatusBadge.fromTemplateStatus(tpl.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Category: ${tpl.category.label} • Code: ${tpl.code} • Lang: ${tpl.language.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tpl.renderedSample,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.history, size: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          const SizedBox(width: 4),
                          Text(
                            'Sent ${tpl.usageCount} times • Last used: ${tpl.lastUsedAt.toString().substring(0, 16)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
