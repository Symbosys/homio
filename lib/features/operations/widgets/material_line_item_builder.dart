import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class MaterialLineItemBuilder extends StatefulWidget {
  final List<MaterialRequestItem> initialItems;
  final ValueChanged<List<MaterialRequestItem>> onChanged;

  const MaterialLineItemBuilder({
    super.key,
    required this.initialItems,
    required this.onChanged,
  });

  @override
  State<MaterialLineItemBuilder> createState() => _MaterialLineItemBuilderState();
}

class _MaterialLineItemBuilderState extends State<MaterialLineItemBuilder> {
  late List<MaterialRequestItem> _items;

  static const List<String> _units = [
    'Sq.Ft.',
    'PC / Nos',
    'Running Ft.',
    'Lump Sum',
    'Sheets (8x4)',
    'Sets',
    'Kg',
    'Litre',
    'Box',
    'Rolls (90m)',
  ];

  static const List<String> _categories = [
    'Wood & Boards',
    'Hardware & Fittings',
    'Flooring & Cladding',
    'Electrical & Automation',
    'Civil & Masonry',
    'Paints & Finishes',
    'Sanitary & Plumbing',
    'Glass & Mirrors',
  ];

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
  }

  void _addItem() {
    setState(() {
      _items.add(
        MaterialRequestItem(
          id: 'item_${DateTime.now().millisecondsSinceEpoch}',
          itemName: 'New Material Specification',
          itemCode: 'MAT-GEN-01',
          category: 'Wood & Boards',
          specification: const MaterialSpecification(
            materialType: 'Commercial Core',
            grade: 'Grade A',
            thickness: '18mm',
          ),
          dimensions: const DimensionInput(length: 8, width: 4, unit: 'ft'),
          quantity: 10,
          unit: 'Sheets (8x4)',
          estimatedRate: 1500,
          estimatedAmount: 15000,
          requiredDate: DateTime.now().add(const Duration(days: 7)),
        ),
      );
      widget.onChanged(_items);
    });
  }

  void _duplicateItem(int index) {
    setState(() {
      final source = _items[index];
      _items.insert(
        index + 1,
        source.copyWith(
          id: 'item_${DateTime.now().millisecondsSinceEpoch}',
          itemName: '${source.itemName} (Copy)',
        ),
      );
      widget.onChanged(_items);
    });
  }

  void _removeItem(int index) {
    if (_items.length <= 1) return;
    setState(() {
      _items.removeAt(index);
      widget.onChanged(_items);
    });
  }

  void _updateItem(int index, MaterialRequestItem updated) {
    setState(() {
      _items[index] = updated;
      widget.onChanged(_items);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final totalMaterialValue =
        _items.fold<double>(0.0, (sum, item) => sum + item.estimatedAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.format_list_bulleted_rounded,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Material Line Items (${_items.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.primaryMuted,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Total Est: ₹${totalMaterialValue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Item', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = _items[index];
            return _buildItemCard(context, index, item, isDark, theme);
          },
        ),
      ],
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    int index,
    MaterialRequestItem item,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: item.itemName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    labelText: 'Item Name & Model',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) =>
                      _updateItem(index, item.copyWith(itemName: val)),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 140,
                child: DropdownButtonFormField<String>(
                  initialValue: _categories.contains(item.category)
                      ? item.category
                      : _categories.first,
                  isExpanded: true,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _updateItem(index, item.copyWith(category: val));
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16),
                tooltip: 'Duplicate Row',
                onPressed: () => _duplicateItem(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    size: 16, color: AppColors.error),
                tooltip: 'Remove',
                onPressed: _items.length > 1 ? () => _removeItem(index) : null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Specifications and Dimensions Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: item.specification.grade.isNotEmpty
                      ? '${item.specification.materialType} • ${item.specification.grade} • ${item.specification.thickness}'
                      : 'IS:710 Marine Grade Calibrated 18mm',
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    labelText: 'Material Specification (Type • Grade • Thickness)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    _updateItem(
                      index,
                      item.copyWith(
                        specification: MaterialSpecification(
                          materialType: val,
                          grade: 'IS Standard',
                          thickness: 'Standard',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: item.dimensions != null
                      ? '${item.dimensions!.length}x${item.dimensions!.width}'
                      : '8x4',
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    labelText: 'Dimensions (LxW)',
                    hintText: '8x4 ft',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 90,
                child: TextFormField(
                  initialValue: item.quantity.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    final qty = double.tryParse(val) ?? item.quantity;
                    _updateItem(
                      index,
                      item.copyWith(
                        quantity: qty,
                        estimatedAmount: qty * item.estimatedRate,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 120,
                child: DropdownButtonFormField<String>(
                  initialValue: _units.contains(item.unit) ? item.unit : _units.first,
                  isExpanded: true,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _updateItem(index, item.copyWith(unit: val));
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 110,
                child: TextFormField(
                  initialValue: item.estimatedRate.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    labelText: 'Rate (₹)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    final rate = double.tryParse(val) ?? item.estimatedRate;
                    _updateItem(
                      index,
                      item.copyWith(
                        estimatedRate: rate,
                        estimatedAmount: item.quantity * rate,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 120,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('EST. AMOUNT',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                    Text(
                      '₹${item.estimatedAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
