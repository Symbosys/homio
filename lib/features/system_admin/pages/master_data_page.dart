import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_models.dart';
import '../models/admin_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class MasterDataPage extends StatefulWidget {
  const MasterDataPage({super.key});

  @override
  State<MasterDataPage> createState() => _MasterDataPageState();
}

class _MasterDataPageState extends State<MasterDataPage> {
  // State
  List<MasterCategoryItem> _categories = [];
  List<MasterRecord> _records = [];
  late MasterCategoryItem _selectedCategory;

  // Filter & Search
  String _searchQuery = '';
  bool? _statusFilter; // null = all, true = active, false = inactive
  MasterGroupCategory? _selectedGroupFilter;

  // Modals
  bool _isAddRecordModalOpen = false;
  MasterRecord? _editingRecord;

  @override
  void initState() {
    super.initState();
    _categories = List.from(AdminMockData.masterCategories);
    _records = List.from(AdminMockData.masterRecords);
    _selectedCategory = _categories.first;
  }

  List<MasterRecord> get _filteredRecords {
    return _records.where((rec) {
      if (rec.categoryId != _selectedCategory.id) return false;
      if (_statusFilter != null && rec.isActive != _statusFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = rec.name.toLowerCase().contains(q) ||
            rec.code.toLowerCase().contains(q) ||
            rec.description.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  List<MasterCategoryItem> get _filteredCategories {
    if (_selectedGroupFilter == null) return _categories;
    return _categories.where((c) => c.group == _selectedGroupFilter).toList();
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
                  title: 'Master Data Configuration',
                  description: 'Configure reusable business values driving CRM, projects, commercial pricing, and field operations.',
                  icon: Icons.dataset_rounded,
                  breadcrumbs: const ['Homio Administration', 'Platform Configuration', 'Master Data'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () => _showAddCategoryDialog(context),
                      icon: const Icon(Icons.create_new_folder_outlined, size: 16),
                      label: const Text('Add Master Category', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _editingRecord = null;
                          _isAddRecordModalOpen = true;
                        });
                      },
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: Text('Add ${_selectedCategory.name.split(" ").first} Record', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Metrics Summary
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Configured Categories',
                      value: '${_categories.length}',
                      subtitle: '7 Operational Clusters',
                      icon: Icons.folder_copy_outlined,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Master Records',
                      value: '${_records.length}',
                      subtitle: 'Active standard values',
                      icon: Icons.list_alt_rounded,
                      color: AppColors.success,
                    ),
                    AdminMetricItem(
                      label: 'Live Operations Linked',
                      value: '3,850+',
                      subtitle: 'Protected from deletion',
                      icon: Icons.shield_outlined,
                      color: AppColors.secondary,
                    ),
                    AdminMetricItem(
                      label: 'System Baseline',
                      value: '100% Validated',
                      subtitle: 'ISO compliance preserved',
                      icon: Icons.verified_outlined,
                      color: AppColors.info,
                    ),
                  ],
                ),

                // 3. Main Workspace: Sidebar Categories + Detail Table
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Category Navigator
                    Container(
                      width: isMobile ? 160 : 220,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        border: Border(
                          right: BorderSide(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: DropdownButtonFormField<MasterGroupCategory?>(
                              isExpanded: true,
                              initialValue: _selectedGroupFilter,
                              decoration: InputDecoration(
                                labelText: 'Cluster Filter',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Clusters', style: TextStyle(fontSize: 12))),
                                for (final grp in MasterGroupCategory.values)
                                  DropdownMenuItem(value: grp, child: Text(grp.label, style: const TextStyle(fontSize: 12))),
                              ],
                              onChanged: (val) => setState(() => _selectedGroupFilter = val),
                            ),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _filteredCategories.length,
                              itemBuilder: (context, index) {
                                final cat = _filteredCategories[index];
                                final isSelected = cat.id == _selectedCategory.id;

                                return ListTile(
                                  dense: true,
                                  selected: isSelected,
                                  selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
                                  leading: Icon(cat.group.icon, size: 18, color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                  title: Text(
                                    cat.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                    ),
                                  ),
                                  subtitle: Text(cat.code, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${cat.recordCount}',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                    ),
                                  ),
                                  onTap: () => setState(() => _selectedCategory = cat),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right Column: Records Workspace
                    Expanded(
                      child: Column(
                        children: [
                          // Search & Status Filter Bar
                          AdminFilterBar(
                            searchQuery: _searchQuery,
                            onSearchChanged: (q) => setState(() => _searchQuery = q),
                            searchHint: 'Search records in ${_selectedCategory.name}...',
                            filterControls: [
                              DropdownButton<bool?>(
                                value: _statusFilter,
                                hint: const Text('Status', style: TextStyle(fontSize: 12)),
                                underline: const SizedBox(),
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('All States', style: TextStyle(fontSize: 12))),
                                  DropdownMenuItem(value: true, child: Text('Active Only', style: TextStyle(fontSize: 12))),
                                  DropdownMenuItem(value: false, child: Text('Archived / Inactive', style: TextStyle(fontSize: 12))),
                                ],
                                onChanged: (val) => setState(() => _statusFilter = val),
                              ),
                            ],
                            onExport: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Exported ${_selectedCategory.name} records to CSV format.')),
                              );
                            },
                          ),

                          // Records Data Table
                          _filteredRecords.isEmpty
                              ? _buildEmptyState(isDark)
                              : _buildRecordsTable(_filteredRecords, isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Add / Edit Record Modal
          if (_isAddRecordModalOpen)
            _buildRecordFormModal(isDark),
        ],
      ),
    );
  }

  Widget _buildRecordsTable(List<MasterRecord> list, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
              ),
              dataRowMinHeight: 46,
              dataRowMaxHeight: 54,
            columns: const [
              DataColumn(label: Text('Record Name & Description', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Code', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Order', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Live Usages', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Safety Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
            ],
            rows: list.map((rec) {
              return DataRow(
                cells: [
                  // Name & Description
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(rec.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(rec.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                  // Code
                  DataCell(
                    Text(rec.code, style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                  ),
                  // Display Order
                  DataCell(
                    Text('#${rec.displayOrder}', style: const TextStyle(fontSize: 12)),
                  ),
                  // Usages
                  DataCell(
                    Tooltip(
                      message: rec.usageContextDescription,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.link_rounded, size: 14, color: rec.usageCount > 0 ? AppColors.primary : Colors.grey),
                          const SizedBox(width: 4),
                          Text('${rec.usageCount} refs', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: rec.usageCount > 0 ? AppColors.primary : Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  // Type Badge (System vs Admin Created)
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: rec.isSystemDefined ? Colors.blue.withValues(alpha: 0.12) : Colors.purple.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        rec.isSystemDefined ? 'System' : 'Custom',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: rec.isSystemDefined ? Colors.blue : Colors.purple,
                        ),
                      ),
                    ),
                  ),
                  // Status Badge
                  DataCell(
                    AdminStatusBadge(
                      label: rec.isActive ? 'Active' : 'Archived',
                      color: rec.isActive ? AppColors.success : AppColors.darkTextMuted,
                    ),
                  ),
                  // Safety Actions (Edit, Delete with Safety Guard)
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          tooltip: 'Edit Master Record',
                          onPressed: () {
                            setState(() {
                              _editingRecord = rec;
                              _isAddRecordModalOpen = true;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                          tooltip: 'Delete / Deactivate Record',
                          onPressed: () => _handleRecordDeletion(rec),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Critical Safety Blocker preventing hard-deletes of referenced data
  void _handleRecordDeletion(MasterRecord record) {
    if (record.usageCount > 0) {
      AdminSafetyModal.show(
        context: context,
        title: 'Master Value Deletion Guard',
        recordName: record.name,
        recordCode: record.code,
        referenceCount: record.usageCount,
        referenceContextDescription: record.usageContextDescription,
        onDeactivateInstead: () {
          setState(() {
            final idx = _records.indexWhere((r) => r.id == record.id);
            if (idx != -1) {
              _records[idx] = record.copyWith(isActive: false);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Record "${record.name}" has been deactivated for future operations while preserving historical integrity.'),
              backgroundColor: AppColors.warning,
            ),
          );
        },
      );
    } else {
      // Safe to delete because usage count is 0
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Delete "${record.name}" permanently? It has 0 operational references.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _records.removeWhere((r) => r.id == record.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Record "${record.name}" deleted.')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRecordFormModal(bool isDark) {
    final isEditing = _editingRecord != null;
    final nameCtrl = TextEditingController(text: _editingRecord?.name ?? '');
    final codeCtrl = TextEditingController(text: _editingRecord?.code ?? '');
    final descCtrl = TextEditingController(text: _editingRecord?.description ?? '');
    final orderCtrl = TextEditingController(text: '${_editingRecord?.displayOrder ?? _filteredRecords.length + 1}');

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 540,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 25)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Master Record' : 'Add New Record to ${_selectedCategory.name}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Values defined here will be available across Homio modules automatically.',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Record Name *', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeCtrl,
                      decoration: const InputDecoration(labelText: 'Code / Key *', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: orderCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Order #', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description / Usage Guidance', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => setState(() => _isAddRecordModalOpen = false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isEmpty || codeCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Record Name and Code are mandatory.')),
                        );
                        return;
                      }

                      setState(() {
                        if (isEditing) {
                          final idx = _records.indexWhere((r) => r.id == _editingRecord!.id);
                          if (idx != -1) {
                            _records[idx] = _editingRecord!.copyWith(
                              name: nameCtrl.text,
                              code: codeCtrl.text,
                              description: descCtrl.text,
                              displayOrder: int.tryParse(orderCtrl.text) ?? 1,
                            );
                          }
                        } else {
                          _records.add(
                            MasterRecord(
                              id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
                              categoryId: _selectedCategory.id,
                              categoryName: _selectedCategory.name,
                              code: codeCtrl.text.toUpperCase(),
                              name: nameCtrl.text,
                              description: descCtrl.text,
                              displayOrder: int.tryParse(orderCtrl.text) ?? 1,
                              isSystemDefined: false,
                              effectiveDate: DateTime.now(),
                              usageCount: 0,
                              usageContextDescription: 'Newly configured master record.',
                            ),
                          );
                        }
                        _isAddRecordModalOpen = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Record ${isEditing ? "updated" : "created"} successfully.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: Text(isEditing ? 'Update Record' : 'Create Record'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final catNameCtrl = TextEditingController();
    final catCodeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Master Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: catNameCtrl, decoration: const InputDecoration(labelText: 'Category Name *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: catCodeCtrl, decoration: const InputDecoration(labelText: 'Category Code (e.g. CRM-EXP) *', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (catNameCtrl.text.isNotEmpty && catCodeCtrl.text.isNotEmpty) {
                setState(() {
                  final newCat = MasterCategoryItem(
                    id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
                    group: MasterGroupCategory.custom,
                    code: catCodeCtrl.text.toUpperCase(),
                    name: catNameCtrl.text,
                    description: 'Custom administrator master configuration group.',
                    recordCount: 0,
                  );
                  _categories.add(newCat);
                  _selectedCategory = newCat;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom category added successfully.'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('Create Category'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dataset_outlined, size: 54, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          const SizedBox(height: 12),
          Text('No records found in ${_selectedCategory.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 6),
          Text('Click "Add Record" to configure standard business values for this category.', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        ],
      ),
    );
  }
}
