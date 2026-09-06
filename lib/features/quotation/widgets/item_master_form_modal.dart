import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Modal form to add or edit an item in the Master Rate Catalogue.
class ItemMasterFormModal extends StatefulWidget {
  final ItemMasterEntry? initialItem;
  final ValueChanged<ItemMasterEntry> onSave;

  const ItemMasterFormModal({
    super.key,
    this.initialItem,
    required this.onSave,
  });

  @override
  State<ItemMasterFormModal> createState() => _ItemMasterFormModalState();
}

class _ItemMasterFormModalState extends State<ItemMasterFormModal> {
  late final TextEditingController _nameController;
  late final TextEditingController _specsController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _baseCostController;
  late final TextEditingController _brandsController;

  late ItemCategory _selectedCategory;
  late UnitOfMeasurement _selectedUom;
  late double _marginPercent;
  late double _gstPercent;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _specsController = TextEditingController(text: item?.technicalSpecs ?? '');
    _imageUrlController = TextEditingController(
      text: item?.imageUrl ?? 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400&q=80',
    );
    _baseCostController = TextEditingController(text: item?.baseCostRate.toStringAsFixed(0) ?? '1200');
    _brandsController = TextEditingController(text: item?.approvedBrands.join(', ') ?? 'CenturyPly, Hafele');
    _selectedCategory = item?.category ?? ItemCategory.carpentry;
    _selectedUom = item?.uom ?? UnitOfMeasurement.sqft;
    _marginPercent = item?.marginPercent ?? 25.0;
    _gstPercent = item?.gstPercent ?? 18.0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specsController.dispose();
    _imageUrlController.dispose();
    _baseCostController.dispose();
    _brandsController.dispose();
    super.dispose();
  }

  double get _sellingRate {
    final base = double.tryParse(_baseCostController.text) ?? 0.0;
    return base * (1 + (_marginPercent / 100.0));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lg,
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
        child: Column(
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Icon(
                          widget.initialItem == null ? Icons.add_box_rounded : Icons.edit_note_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.initialItem == null ? 'Add New Master Catalogue Item' : 'Edit Catalogue Item',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name
                    Text('Item Standard Nomenclature', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: _inputDecoration(isDark, 'e.g., Full Height Sliding Wardrobe with Loft'),
                    ),
                    const SizedBox(height: 14),

                    // Category & UOM Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category', style: _labelStyle(isDark)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<ItemCategory>(
                                initialValue: _selectedCategory,
                                items: ItemCategory.values.map((cat) {
                                  return DropdownMenuItem(
                                    value: cat,
                                    child: Text(cat.label, style: GoogleFonts.inter(fontSize: 13)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedCategory = val);
                                },
                                decoration: _inputDecoration(isDark, ''),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Unit of Measure (UOM)', style: _labelStyle(isDark)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<UnitOfMeasurement>(
                                initialValue: _selectedUom,
                                items: UnitOfMeasurement.values.map((uom) {
                                  return DropdownMenuItem(
                                    value: uom,
                                    child: Text('${uom.symbol} - ${uom.label}', style: GoogleFonts.inter(fontSize: 13)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedUom = val);
                                },
                                decoration: _inputDecoration(isDark, ''),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Technical Specifications
                    Text('Technical Material Specifications', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _specsController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        isDark,
                        'Specify ply grade (BWP 710), laminate thickness (1.0mm), edge banding, hardware brand...',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Base Cost, Margin & Selling Rate
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Base Unit Cost Rate (₹)', style: _labelStyle(isDark)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _baseCostController,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                decoration: _inputDecoration(isDark, '1200'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Target Margin %', style: _labelStyle(isDark)),
                                  Text(
                                    '${_marginPercent.toStringAsFixed(0)}%',
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _marginPercent,
                                min: 5.0,
                                max: 60.0,
                                divisions: 55,
                                activeColor: AppColors.primary,
                                onChanged: (val) => setState(() => _marginPercent = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Selling Rate preview card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                        borderRadius: AppRadius.sm,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Final Computed Selling Rate',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              Text(
                                'Base Cost + ${_marginPercent.toStringAsFixed(0)}% Margin (excl. 18% GST)',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹${_sellingRate.toStringAsFixed(0)} / ${_selectedUom.symbol}',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Image URL & Approved Brands
                    Text('Thumbnail Image URL', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _imageUrlController,
                      decoration: _inputDecoration(isDark, 'https://...'),
                    ),
                    const SizedBox(height: 14),

                    Text('Approved Brand Standards (comma separated)', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _brandsController,
                      decoration: _inputDecoration(isDark, 'e.g. CenturyPly, Greenlam, Hafele, Blum'),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Modal Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _saveItem,
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: Text(widget.initialItem == null ? 'Create Item' : 'Update Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  TextStyle _labelStyle(bool isDark) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  InputDecoration _inputDecoration(bool isDark, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
      border: OutlineInputBorder(
        borderRadius: AppRadius.sm,
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.sm,
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  void _saveItem() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final baseCost = double.tryParse(_baseCostController.text) ?? 1000.0;
    final brands = _brandsController.text.split(',').map((b) => b.trim()).where((b) => b.isNotEmpty).toList();

    final item = ItemMasterEntry(
      id: widget.initialItem?.id ?? 'ITM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: name,
      category: _selectedCategory,
      technicalSpecs: _specsController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      uom: _selectedUom,
      baseCostRate: baseCost,
      marginPercent: _marginPercent,
      gstPercent: _gstPercent,
      approvedBrands: brands.isEmpty ? ['Standard Architectural Grade'] : brands,
    );

    widget.onSave(item);
    Navigator.of(context).pop();
  }
}
