import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';
import '../../data/models/org_marketplace_models.dart';
import '../queries/org_marketplace_queries.dart';
import '../widgets/marketplace_image_picker_field.dart';

class OrgHomeDecorDialog extends StatefulWidget {
  final PlatformMarketplaceCategoryModel category;
  final OrgHomeDecorProductModel? product;

  const OrgHomeDecorDialog({
    super.key,
    required this.category,
    this.product,
  });

  static Future<void> show(
    BuildContext context, {
    required PlatformMarketplaceCategoryModel category,
    OrgHomeDecorProductModel? product,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgHomeDecorDialog(
        category: category,
        product: product,
      ),
    );
  }

  @override
  State<OrgHomeDecorDialog> createState() => _OrgHomeDecorDialogState();
}

class _OrgHomeDecorDialogState extends State<OrgHomeDecorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _queries = OrgMarketplaceQueries();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _dimensionsCtrl;
  late final TextEditingController _materialCtrl;
  late final TextEditingController _colorCtrl;
  late final TextEditingController _mrpCtrl;
  late final TextEditingController _sellingPriceCtrl;
  late final TextEditingController _stockCtrl;

  Uint8List? _selectedCoverBytes;
  String? _selectedCoverFileName;
  String? _initialCoverUrl;
  bool _inStock = true;
  bool _isActive = true;
  bool _isSubmitting = false;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _brandCtrl = TextEditingController(text: p?.brandName ?? '');
    _dimensionsCtrl = TextEditingController(text: p?.dimensions ?? '');
    _materialCtrl = TextEditingController(text: p?.material ?? '');
    _colorCtrl = TextEditingController(text: p?.color ?? '');
    _mrpCtrl = TextEditingController(text: p?.mrp != null ? p!.mrp.toStringAsFixed(2) : '');
    _sellingPriceCtrl = TextEditingController(text: p?.sellingPrice != null ? p!.sellingPrice.toStringAsFixed(2) : '');
    _stockCtrl = TextEditingController(text: p?.stockCount != null ? p!.stockCount.toString() : '10');
    _inStock = p?.inStock ?? true;
    _isActive = p?.status == 'PUBLISHED' || p?.status == 'ACTIVE' || p == null;
    _initialCoverUrl = p?.coverImageUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _descCtrl.dispose();
    _brandCtrl.dispose();
    _dimensionsCtrl.dispose();
    _materialCtrl.dispose();
    _colorCtrl.dispose();
    _mrpCtrl.dispose();
    _sellingPriceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final mrpVal = double.tryParse(_mrpCtrl.text.trim()) ?? 0.0;
      final sellingPriceVal = _sellingPriceCtrl.text.trim().isNotEmpty
          ? double.tryParse(_sellingPriceCtrl.text.trim()) ?? mrpVal
          : mrpVal;
      final stockVal = int.tryParse(_stockCtrl.text.trim()) ?? 0;

      final dataMap = <String, dynamic>{
        'categoryId': widget.category.id,
        'name': _nameCtrl.text.trim(),
        'sku': _skuCtrl.text.trim().isNotEmpty ? _skuCtrl.text.trim() : 'DEC-${DateTime.now().millisecondsSinceEpoch % 100000}',
        'description': _descCtrl.text.trim(),
        'brandName': _brandCtrl.text.trim().isNotEmpty ? _brandCtrl.text.trim() : null,
        'dimensions': _dimensionsCtrl.text.trim().isNotEmpty ? _dimensionsCtrl.text.trim() : null,
        'material': _materialCtrl.text.trim().isNotEmpty ? _materialCtrl.text.trim() : null,
        'color': _colorCtrl.text.trim().isNotEmpty ? _colorCtrl.text.trim() : null,
        'mrp': mrpVal,
        'sellingPrice': sellingPriceVal,
        'stockCount': stockVal,
        'inStock': _inStock,
        'status': _isActive ? 'PUBLISHED' : 'DRAFT',
      };

      if (isEdit) {
        final mutation = _queries.getUpdateHomeDecorMutation();
        await mutation.mutate((
          id: widget.product!.id,
          data: dataMap,
          imageBytes: _selectedCoverBytes,
          imageFileName: _selectedCoverFileName,
        ));
      } else {
        final mutation = _queries.getCreateHomeDecorMutation();
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
                          isEdit ? 'Edit Home Decor Item' : 'Add Home Decor & Furnishing Item',
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
                                color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.category.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFEC4899),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Marketplace Vertical: Home Decor',
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
                          label: 'Product Photo / Gallery Image',
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

                        // Name & SKU Row
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Product Name *',
                                  hintText: 'e.g. Scandinavian Solid Oak Coffee Table',
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
                                  labelText: 'SKU / Model Code',
                                  hintText: 'e.g. DECOR-TBL-001',
                                ),
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
                            labelText: 'Description',
                            hintText: 'Describe aesthetics, build quality, finish, and care instructions',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Brand, Dimensions
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _brandCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Brand / Manufacturer',
                                  hintText: 'e.g. Urban Living',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _dimensionsCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Dimensions',
                                  hintText: '120cm x 60cm x 45cm',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Material & Color
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _materialCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Material Spec',
                                  hintText: 'Teak Wood, Brass Accents',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _colorCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Color / Finish',
                                  hintText: 'Walnut Brown, Matte Black',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Pricing & Stock Row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _mrpCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'MRP / Retail Price (₹) *',
                                  prefixText: '₹ ',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Price required';
                                  if (double.tryParse(val.trim()) == null) return 'Invalid price';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _sellingPriceCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Offer / Selling Price (₹)',
                                  prefixText: '₹ ',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _stockCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Stock Qty *',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Stock required';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Status Switches
                        Row(
                          children: [
                            Switch(
                              value: _inStock,
                              onChanged: (val) => setState(() => _inStock = val),
                              activeThumbColor: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _inStock ? 'In Stock' : 'Out of Stock',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: AppSpacing.xl),
                            Switch(
                              value: _isActive,
                              onChanged: (val) => setState(() => _isActive = val),
                              activeThumbColor: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isActive ? 'Published' : 'Draft',
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
                                ? 'Update Product'
                                : 'Add to Decor Catalog',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEC4899),
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
