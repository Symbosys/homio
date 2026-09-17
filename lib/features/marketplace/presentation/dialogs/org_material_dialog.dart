import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';
import '../../data/models/org_marketplace_models.dart';
import '../queries/org_marketplace_queries.dart';
import '../widgets/marketplace_image_picker_field.dart';

class OrgMaterialDialog extends StatefulWidget {
  final PlatformMarketplaceCategoryModel category;
  final OrgMaterialProductModel? material;

  const OrgMaterialDialog({
    super.key,
    required this.category,
    this.material,
  });

  static Future<void> show(
    BuildContext context, {
    required PlatformMarketplaceCategoryModel category,
    OrgMaterialProductModel? material,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgMaterialDialog(
        category: category,
        material: material,
      ),
    );
  }

  @override
  State<OrgMaterialDialog> createState() => _OrgMaterialDialogState();
}

class _OrgMaterialDialogState extends State<OrgMaterialDialog> {
  final _formKey = GlobalKey<FormState>();
  final _queries = OrgMarketplaceQueries();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _materialTypeCtrl;
  late final TextEditingController _gradeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _unitCtrl;
  late final TextEditingController _wholesalePriceCtrl;
  late final TextEditingController _retailPriceCtrl;
  late final TextEditingController _minOrderCtrl;
  late final TextEditingController _stockCtrl;

  Uint8List? _selectedCoverBytes;
  String? _selectedCoverFileName;
  String? _initialCoverUrl;
  bool _isActive = true;
  bool _isSubmitting = false;

  bool get isEdit => widget.material != null;

  @override
  void initState() {
    super.initState();
    final m = widget.material;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _skuCtrl = TextEditingController(text: m?.sku ?? '');
    _brandCtrl = TextEditingController(text: m?.brandName ?? '');
    _materialTypeCtrl = TextEditingController(text: m?.materialType ?? 'Cement & Aggregates');
    _gradeCtrl = TextEditingController(text: m?.grade ?? 'Grade 53 OPC');
    _descCtrl = TextEditingController(text: m?.description ?? '');
    _unitCtrl = TextEditingController(text: m?.unitOfMeasure ?? 'BAG');
    _wholesalePriceCtrl = TextEditingController(text: m?.wholesalePrice != null ? m!.wholesalePrice.toStringAsFixed(2) : '');
    _retailPriceCtrl = TextEditingController(text: m?.retailPrice != null ? m!.retailPrice.toStringAsFixed(2) : '');
    _minOrderCtrl = TextEditingController(text: m?.minOrderQuantity != null ? m!.minOrderQuantity.toString() : '50');
    _stockCtrl = TextEditingController(text: m?.stockAvailableUnits != null ? m!.stockAvailableUnits.toString() : '500');
    _isActive = m?.status == 'PUBLISHED' || m?.status == 'ACTIVE' || m == null;
    _initialCoverUrl = m?.coverImageUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _brandCtrl.dispose();
    _materialTypeCtrl.dispose();
    _gradeCtrl.dispose();
    _descCtrl.dispose();
    _unitCtrl.dispose();
    _wholesalePriceCtrl.dispose();
    _retailPriceCtrl.dispose();
    _minOrderCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final wholesaleVal = double.tryParse(_wholesalePriceCtrl.text.trim()) ?? 0.0;
      final retailVal = _retailPriceCtrl.text.trim().isNotEmpty
          ? double.tryParse(_retailPriceCtrl.text.trim()) ?? wholesaleVal
          : wholesaleVal;
      final minOrderVal = int.tryParse(_minOrderCtrl.text.trim()) ?? 1;
      final stockVal = int.tryParse(_stockCtrl.text.trim()) ?? 100;

      final dataMap = <String, dynamic>{
        'categoryId': widget.category.id,
        'name': _nameCtrl.text.trim(),
        'sku': _skuCtrl.text.trim().isNotEmpty ? _skuCtrl.text.trim() : 'MAT-${DateTime.now().millisecondsSinceEpoch % 100000}',
        'brandName': _brandCtrl.text.trim().isNotEmpty ? _brandCtrl.text.trim() : null,
        'materialType': _materialTypeCtrl.text.trim().isNotEmpty ? _materialTypeCtrl.text.trim() : null,
        'grade': _gradeCtrl.text.trim().isNotEmpty ? _gradeCtrl.text.trim() : null,
        'description': _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
        'unitOfMeasure': _unitCtrl.text.trim(),
        'wholesalePrice': wholesaleVal,
        'retailPrice': retailVal,
        'minOrderQuantity': minOrderVal,
        'stockAvailableUnits': stockVal,
        'status': _isActive ? 'PUBLISHED' : 'DRAFT',
      };

      if (isEdit) {
        final mutation = _queries.getUpdateMaterialMutation();
        await mutation.mutate((
          id: widget.material!.id,
          data: dataMap,
          imageBytes: _selectedCoverBytes,
          imageFileName: _selectedCoverFileName,
        ));
      } else {
        final mutation = _queries.getCreateMaterialMutation();
        await mutation.mutate((
          data: dataMap,
          imageBytes: _selectedCoverBytes,
          imageFileName: _selectedCoverFileName,
        ));
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 640,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit Construction Material' : 'Add Wholesale Construction Material',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.category.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Marketplace Vertical: Materials',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Scrollable Body
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Picker
                        MarketplaceImagePickerField(
                          label: 'Material Catalog Photo / Spec Sheet Image',
                          initialUrl: _initialCoverUrl,
                          selectedBytes: _selectedCoverBytes,
                          selectedFileName: _selectedCoverFileName,
                          onImageSelected: (bytes, name) {
                            setState(() {
                              _selectedCoverBytes = bytes;
                              _selectedCoverFileName = name;
                            });
                          },
                          onImageRemoved: () {
                            setState(() {
                              _selectedCoverBytes = null;
                              _selectedCoverFileName = null;
                              _initialCoverUrl = null;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Name & SKU
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Material Name *',
                                  hintText: 'e.g. UltraTech OPC 53 Grade Cement',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Name is required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _skuCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'SKU / Batch Code',
                                  hintText: 'MAT-CEM-53',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Brand & Grade Row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _brandCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Brand / Mill',
                                  hintText: 'UltraTech / Tata Steel',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _gradeCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Grade / Specification',
                                  hintText: 'IS: 12269 / Fe 550D',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Unit & Unit Price & Min Order
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _unitCtrl.text,
                                decoration: const InputDecoration(labelText: 'Pricing Unit *'),
                                items: const [
                                  DropdownMenuItem(value: 'SQFT', child: Text('Per Sq. Ft (sqft)')),
                                  DropdownMenuItem(value: 'BAG', child: Text('Per Bag (50kg)')),
                                  DropdownMenuItem(value: 'PIECE', child: Text('Per Piece / Tile')),
                                  DropdownMenuItem(value: 'TON', child: Text('Per Metric Ton')),
                                  DropdownMenuItem(value: 'LTR', child: Text('Per Litre (Ltr)')),
                                  DropdownMenuItem(value: 'KG', child: Text('Per Kilogram (Kg)')),
                                  DropdownMenuItem(value: 'METER', child: Text('Per Running Meter')),
                                ],
                                onChanged: (val) {
                                  if (val != null) _unitCtrl.text = val;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _wholesalePriceCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Wholesale Price (₹) *',
                                  prefixText: '₹ ',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Price required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _minOrderCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Min Order Qty *',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Min order required';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Description
                        TextFormField(
                          controller: _descCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description & Bulk Terms',
                            hintText: 'Describe composition, delivery radius, unloading charges, and warranty',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Row(
                          children: [
                            Switch(
                              value: _isActive,
                              onChanged: (val) => setState(() => _isActive = val),
                              activeThumbColor: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isActive ? 'Published in B2B Index' : 'Draft / Hidden',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.md),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(isEdit ? Icons.save_rounded : Icons.add_rounded, size: 18),
                      label: Text(
                        _isSubmitting
                            ? 'Saving...'
                            : isEdit
                                ? 'Update Material'
                                : 'Add to Material Catalog',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
