import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/template_models.dart';

class MessageTemplatesPage extends StatefulWidget {
  const MessageTemplatesPage({super.key});

  @override
  State<MessageTemplatesPage> createState() => _MessageTemplatesPageState();
}

class _MessageTemplatesPageState extends State<MessageTemplatesPage> {
  TemplateCategory? _selectedCategory;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  List<MetaMessageTemplate> get _allTemplates => TemplateMockData.templates;

  List<MetaMessageTemplate> get _filteredTemplates {
    return _allTemplates.where((t) {
      if (_selectedCategory != null && t.category != _selectedCategory) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = t.name.toLowerCase().contains(q);
        final matchBody = t.bodyText.toLowerCase().contains(q);
        if (!matchName && !matchBody) return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openCreateTemplateModal([MetaMessageTemplate? initial]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateMetaTemplateModal(
        initialTemplate: initial,
        onSuccess: () => setState(() {}),
      ),
    );
  }

  void _deleteTemplate(MetaMessageTemplate t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 10),
            Text('Delete Meta Template', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text('Are you sure you want to remove "${t.name}" from your approved templates?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                TemplateMockData.deleteTemplate(t.id);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Template "${t.name}" deleted.')),
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

    final templates = _filteredTemplates;
    final approvedCount = _allTemplates.where((t) => t.status == TemplateApprovalStatus.approved).length;
    final pendingCount = _allTemplates.where((t) => t.status == TemplateApprovalStatus.pending).length;
    final totalSent = _allTemplates.fold<int>(0, (sum, t) => sum + t.totalSent);

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
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.text_snippet_rounded, color: Color(0xFF10B981), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Meta Message Templates Hub',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF25D366).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'WhatsApp Cloud API Direct',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF25D366)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pre-approved WhatsApp business templates with interactive CTA buttons, dynamic parameter mapping, and delivery analytics.',
                              style: TextStyle(fontSize: 13, color: textMuted),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _openCreateTemplateModal(),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Create Meta Template', style: TextStyle(fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
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
                                _buildMetricCard('Approved Templates', '$approvedCount Active', 'Meta Verified', Icons.verified_rounded, const Color(0xFF10B981)),
                                const SizedBox(height: 10),
                                _buildMetricCard('In Review Queue', '$pendingCount Pending', 'Under 24h SLA', Icons.hourglass_top_rounded, const Color(0xFFF59E0B)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Total Dispatches', '$totalSent Messages', 'Across all campaigns', Icons.send_rounded, const Color(0xFF3B82F6)),
                                const SizedBox(height: 10),
                                _buildMetricCard('Avg Open Rate', '94.8%', '3.8x higher than email', Icons.visibility_rounded, const Color(0xFF8B5CF6)),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: _buildMetricCard('Approved Templates', '$approvedCount Active', 'Meta Verified', Icons.verified_rounded, const Color(0xFF10B981))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('In Review Queue', '$pendingCount Pending', 'Under 24h SLA', Icons.hourglass_top_rounded, const Color(0xFFF59E0B))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Total Dispatches', '$totalSent Messages', 'Across all campaigns', Icons.send_rounded, const Color(0xFF3B82F6))),
                                const SizedBox(width: 14),
                                Expanded(child: _buildMetricCard('Avg Open Rate', '94.8%', '3.8x higher than email', Icons.visibility_rounded, const Color(0xFF8B5CF6))),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Filters & Search Bar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: TextStyle(fontSize: 13, color: textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Search templates by name (festival_offer, site_progress) or body text...',
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(null, 'All Templates (${_allTemplates.length})'),
                        ...TemplateCategory.values.map((cat) {
                          final count = _allTemplates.where((t) => t.category == cat).length;
                          return _buildCategoryChip(cat, '${cat.label} ($count)');
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Template Cards Grid
          templates.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.text_snippet_outlined, size: 54, color: textMuted),
                        const SizedBox(height: 14),
                        Text('No templates match your search criteria.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _openCreateTemplateModal(),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Create New Template'),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.crossAxisExtent > 1150
                          ? 3
                          : constraints.crossAxisExtent > 750
                              ? 2
                              : 1;

                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 440,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final tpl = templates[index];
                            return _buildTemplateCard(context, tpl, isDark, surfaceColor, borderColor, textPrimary, textMuted);
                          },
                          childCount: templates.length,
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
    BuildContext context,
    MetaMessageTemplate t,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header image if present
          if (t.headerImageUrl != null) ...[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              child: Image.network(
                t.headerImageUrl!,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(height: 110, color: Colors.grey.shade300),
              ),
            ),
          ],

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: t.category.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        t.category.label,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: t.category.color),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: t.status.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(t.status.icon, size: 11, color: t.status.color),
                          const SizedBox(width: 4),
                          Text(
                            t.status.label,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: t.status.color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Template Name
                Text(
                  t.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 2),
                Text(t.language, style: TextStyle(fontSize: 11, color: textMuted)),

                const SizedBox(height: 10),

                // Body Snippet Box
                Container(
                  height: 90,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor.withValues(alpha: 0.6)),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      t.bodyText,
                      style: TextStyle(fontSize: 11.5, color: textPrimary, height: 1.35),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Buttons preview
                if (t.buttons.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: t.buttons.map((btn) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.touch_app_rounded, size: 12, color: Color(0xFF25D366)),
                            const SizedBox(width: 4),
                            Text(btn.text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF25D366))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 12),
                Divider(height: 1, color: borderColor),
                const SizedBox(height: 10),

                // Footer stats & actions
                Row(
                  children: [
                    Text('Sent: ${t.totalSent}', style: TextStyle(fontSize: 11, color: textMuted)),
                    const SizedBox(width: 10),
                    Text('Read: ${t.readRate}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      tooltip: 'Clone Template',
                      onPressed: () => _openCreateTemplateModal(t),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                      tooltip: 'Delete Template',
                      onPressed: () => _deleteTemplate(t),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(TemplateCategory? cat, String label) {
    final isSelected = _selectedCategory == cat;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = cat),
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(color: isSelected ? Colors.white : null),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

class _CreateMetaTemplateModal extends StatefulWidget {
  final MetaMessageTemplate? initialTemplate;
  final VoidCallback onSuccess;

  const _CreateMetaTemplateModal({
    this.initialTemplate,
    required this.onSuccess,
  });

  @override
  State<_CreateMetaTemplateModal> createState() => _CreateMetaTemplateModalState();
}

class _CreateMetaTemplateModalState extends State<_CreateMetaTemplateModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _bodyCtrl;
  late TextEditingController _btnTextCtrl;
  late TextEditingController _btnUrlCtrl;
  TemplateCategory _selectedCat = TemplateCategory.utility;
  bool _hasHeaderImage = false;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTemplate;
    _nameCtrl = TextEditingController(text: t != null ? '${t.name}_copy' : '');
    _bodyCtrl = TextEditingController(
      text: t?.bodyText ?? 'Namaste {{1}}! Your customized 3D design blueprint for {{2}} is ready for digital approval. Tap below to review.',
    );
    _btnTextCtrl = TextEditingController(text: t?.buttons.isNotEmpty == true ? t!.buttons.first.text : 'Review Blueprint');
    _btnUrlCtrl = TextEditingController(text: 'https://homiocrm.com/client/review');
    if (t != null) {
      _selectedCat = t.category;
      _hasHeaderImage = t.headerImageUrl != null;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bodyCtrl.dispose();
    _btnTextCtrl.dispose();
    _btnUrlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newTpl = MetaMessageTemplate(
      id: 'TPL-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: _nameCtrl.text.trim().toLowerCase().replaceAll(' ', '_'),
      category: _selectedCat,
      status: TemplateApprovalStatus.approved,
      bodyText: _bodyCtrl.text.trim(),
      headerImageUrl: _hasHeaderImage ? 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600' : null,
      buttons: [
        TemplateActionButton(
          text: _btnTextCtrl.text.trim(),
          type: TemplateButtonType.url,
          urlOrPhone: _btnUrlCtrl.text.trim(),
        ),
      ],
      placeholders: ['Client Name', 'Project'],
      dateCreated: DateTime.now(),
    );

    TemplateMockData.addTemplate(newTpl);
    widget.onSuccess();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        content: Text('Template "${newTpl.name}" created and approved by Meta Cloud Sandbox!'),
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
        width: 740,
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add_to_photos_rounded, color: Color(0xFF10B981), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create Meta WhatsApp Template', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
                        const SizedBox(height: 2),
                        Text('Configure category, variable tags {{1}}, and CTA buttons with live preview.', style: TextStyle(fontSize: 12, color: textMuted)),
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
                      Text('Template Identifier Name *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameCtrl,
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          hintText: 'e.g. site_milestone_civil_passed',
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Template name is required' : null,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<TemplateCategory>(
                                  initialValue: _selectedCat,
                                  dropdownColor: surfaceColor,
                                  style: TextStyle(fontSize: 13, color: textPrimary),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                                  ),
                                  items: TemplateCategory.values.map((c) {
                                    return DropdownMenuItem(value: c, child: Text(c.label));
                                  }).toList(),
                                  onChanged: (v) => setState(() => _selectedCat = v ?? _selectedCat),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Header Media', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                                const SizedBox(height: 6),
                                SwitchListTile(
                                  value: _hasHeaderImage,
                                  onChanged: (v) => setState(() => _hasHeaderImage = v),
                                  title: const Text('Include Photo/Render', style: TextStyle(fontSize: 12.5)),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text('Template Body Text (Use {{1}}, {{2}} for variables) *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _bodyCtrl,
                        maxLines: 4,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(fontSize: 13, color: textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Type WhatsApp message content with dynamic variable placeholders...',
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Body text is required' : null,
                      ),
                      const SizedBox(height: 16),

                      Text('Interactive CTA Button', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _btnTextCtrl,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(fontSize: 13, color: textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Button Label',
                                filled: true,
                                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _btnUrlCtrl,
                              style: TextStyle(fontSize: 13, color: textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Website URL / Deep Link',
                                filled: true,
                                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Live Mobile Screen Preview
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
                                Icon(Icons.smartphone_rounded, size: 16, color: Color(0xFF075E54)),
                                SizedBox(width: 6),
                                Text('Live Smartphone Preview', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF075E54))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_hasHeaderImage) ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600',
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                  Text(_bodyCtrl.text, style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.35)),
                                  const SizedBox(height: 10),
                                  if (_btnTextCtrl.text.isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF25D366).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _btnTextCtrl.text,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF075E54)),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
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
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: const Text('Submit to Meta Cloud', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
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
