import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/layout/adaptive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/widgets/state_feedback_widgets.dart';
import '../data/sales_repository.dart';
import '../domain/sales_domain_models.dart';
import '../widgets/crm_header.dart';

/// Screen 4: Lead Lists / Funnels
/// Supports Multi-Funnel switcher (Interior Client, Hiring, Vendor), Stage SLAs,
/// Dynamic Form Field Builder, and External Embed Code generator.
class SalesFunnelsPage extends StatefulWidget {
  const SalesFunnelsPage({super.key});

  @override
  State<SalesFunnelsPage> createState() => _SalesFunnelsPageState();
}

class _SalesFunnelsPageState extends State<SalesFunnelsPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  bool _isLoading = true;
  List<FunnelConfig> _funnels = [];
  FunnelConfig? _selectedFunnel;
  String _selectedScope = 'All Organization';

  // Dynamic field add controllers
  final TextEditingController _fieldNameController = TextEditingController();
  String _selectedFieldType = 'Text';
  bool _isRequired = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFunnels();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _fieldNameController.dispose();
    super.dispose();
  }

  Future<void> _loadFunnels({bool preserveScroll = true}) async {
    final double savedOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    setState(() => _isLoading = true);

    final funnels = await SalesRepository.instance.getFunnels();
    if (!mounted) return;

    setState(() {
      _funnels = funnels;
      if (_selectedFunnel == null && funnels.isNotEmpty) {
        _selectedFunnel = funnels.first;
      } else if (_selectedFunnel != null) {
        _selectedFunnel = funnels.firstWhere((f) => f.id == _selectedFunnel!.id, orElse: () => funnels.first);
      }
      _isLoading = false;
    });

    if (preserveScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(savedOffset.clamp(0.0, max));
        }
      });
    }
  }

  void _addNewField() {
    if (_fieldNameController.text.trim().isEmpty || _selectedFunnel == null) return;
    final newField = DynamicFormField(
      id: 'F_${DateTime.now().millisecondsSinceEpoch}',
      label: _fieldNameController.text.trim(),
      type: _selectedFieldType,
      isRequired: _isRequired,
    );

    final updatedFields = List<DynamicFormField>.from(_selectedFunnel!.formFields)..add(newField);
    final updatedFunnel = _selectedFunnel!.copyWith(formFields: updatedFields);

    setState(() {
      _selectedFunnel = updatedFunnel;
      final idx = _funnels.indexWhere((f) => f.id == updatedFunnel.id);
      if (idx != -1) _funnels[idx] = updatedFunnel;
      _fieldNameController.clear();
      _isRequired = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added form field "${newField.name}" to ${_selectedFunnel!.name}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeField(String id) {
    if (_selectedFunnel == null) return;
    final updatedFields = _selectedFunnel!.formFields.where((f) => f.id != id).toList();
    final updatedFunnel = _selectedFunnel!.copyWith(formFields: updatedFields);

    setState(() {
      _selectedFunnel = updatedFunnel;
      final idx = _funnels.indexWhere((f) => f.id == updatedFunnel.id);
      if (idx != -1) _funnels[idx] = updatedFunnel;
    });
  }

  void _copyEmbedCode() {
    if (_selectedFunnel == null) return;
    final code = '<iframe src="https://crm.homio.in/embed/${_selectedFunnel!.embedSlug}" width="100%" height="720" frameborder="0"></iframe>';
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Embed iframe code copied to clipboard!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenType = AdaptiveLayout.getScreenType(context);
    final isDesktop = screenType == ScreenType.desktop || screenType == ScreenType.laptop;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CrmHeader(
            title: 'Lead Lists & Multi-Funnel Architecture',
            subtitle: 'Manage custom pipelines (Clients, Hiring, Vendors), stage SLAs, dynamic form fields, and embeds.',
            scope: _selectedScope,
            onScopeChanged: (val) {
              setState(() => _selectedScope = val);
              _loadFunnels(preserveScroll: true);
            },
            onRefresh: () => _loadFunnels(preserveScroll: true),
            actionButtons: [
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Create Custom Funnel Wizard launched')),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Funnel'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),

          // Main View Body
          Expanded(
            child: _isLoading && _funnels.isEmpty
                ? const DashboardSkeleton(itemCount: 5, height: 80)
                : RefreshIndicator(
                    onRefresh: () => _loadFunnels(preserveScroll: true),
                    child: SingleChildScrollView(
                      key: const PageStorageKey('sales_funnels_page_scroll'),
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Funnel Selector Strip
                          _buildFunnelSelector(isDark),
                          const SizedBox(height: 16),

                          if (_selectedFunnel != null) ...[
                            // Funnel Metadata Card
                            _buildFunnelSummaryCard(_selectedFunnel!, isDark, isDesktop),
                            const SizedBox(height: 16),

                            // Subtabs: 1. Stages & SLA, 2. Dynamic Form Fields, 3. Embed & Share
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              ),
                              child: Column(
                                children: [
                                  TabBar(
                                    controller: _tabController,
                                    labelColor: AppColors.primary,
                                    unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    indicatorColor: AppColors.primary,
                                    tabs: const [
                                      Tab(icon: Icon(Icons.linear_scale_rounded, size: 18), text: 'Stages & SLAs'),
                                      Tab(icon: Icon(Icons.dynamic_form_rounded, size: 18), text: 'Dynamic Form Builder'),
                                      Tab(icon: Icon(Icons.code_rounded, size: 18), text: 'Embed & Share'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 520,
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        _buildStagesTab(_selectedFunnel!, isDark),
                                        _buildFormBuilderTab(_selectedFunnel!, isDark, isDesktop),
                                        _buildEmbedTab(_selectedFunnel!, isDark),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunnelSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_rounded, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          const Text('Active Funnel:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _funnels.map((f) {
                final isSelected = _selectedFunnel?.id == f.id;
                return ChoiceChip(
                  label: Text(f.name),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedFunnel = f);
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : (isDark ? Colors.white : AppColors.darkTextPrimary),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunnelSummaryCard(FunnelConfig f, bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_tree_rounded, size: 28, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(f.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Active Pipeline', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  f.description,
                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${f.stages.length} Stages', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${f.formFields.length} Form Fields', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStagesTab(FunnelConfig f, bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: f.stages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (ctx, idx) {
        final stageName = f.stages[idx];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stageName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(
                      idx == 0
                          ? 'SLA Target: < 4 hours first response'
                          : idx == 1
                              ? 'Qualification SLA: Pin code & budget verification'
                              : 'Auto task generation enabled',
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: true,
                onChanged: (val) {},
                activeThumbColor: AppColors.primary,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 18),
                tooltip: 'Configure Stage SLA & Automations',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Configuring SLA rules for $stageName...')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormBuilderTab(FunnelConfig f, bool isDark, bool isDesktop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Field Form
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _fieldNameController,
                    decoration: const InputDecoration(
                      labelText: 'Field Label',
                      hintText: 'e.g. Floor Plan File',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedFieldType,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 'Text', child: Text('Text Field')),
                        DropdownMenuItem(value: 'Number', child: Text('Number / Budget')),
                        DropdownMenuItem(value: 'Dropdown', child: Text('Dropdown Select')),
                        DropdownMenuItem(value: 'File', child: Text('File / CAD Upload')),
                        DropdownMenuItem(value: 'Date', child: Text('Date Picker')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedFieldType = val);
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _isRequired,
                      onChanged: (val) => setState(() => _isRequired = val ?? false),
                    ),
                    const Text('Required', style: TextStyle(fontSize: 12)),
                  ],
                ),
                FilledButton.icon(
                  onPressed: _addNewField,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Field'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text('Active Fields in Capture Form:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),

          // Fields List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: f.formFields.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (ctx, idx) {
              final field = f.formFields[idx];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.drag_indicator_rounded, size: 18, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Text(field.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          if (field.isRequired) ...[
                            const SizedBox(width: 6),
                            const Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        field.type.toUpperCase(),
                        style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                      onPressed: () => _removeField(field.id),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmbedTab(FunnelConfig f, bool isDark) {
    final embedUrl = 'https://crm.homio.in/embed/${f.embedSlug}';
    final embedIframe = '<iframe src="$embedUrl" width="100%" height="720" frameborder="0"></iframe>';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Embed on Website & Landing Pages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            'Insert this responsive iframe into your WordPress, Next.js, or Webflow landing page to automatically capture leads directly into this funnel with source tracking.',
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),

          // Code Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.black38 : Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    embedIframe,
                    style: const TextStyle(fontFamily: 'monospace', color: Colors.lightGreenAccent, fontSize: 12),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 20),
                  tooltip: 'Copy Embed Code',
                  onPressed: _copyEmbedCode,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Direct Hosted Link
          const Text('Direct Hosted Public Form Link:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Text(embedUrl, style: const TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: embedUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form URL copied!')),
                  );
                },
                icon: const Icon(Icons.link_rounded, size: 16),
                label: const Text('Copy Link'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
