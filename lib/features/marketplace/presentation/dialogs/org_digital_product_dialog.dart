import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';
import '../../data/models/org_marketplace_models.dart';
import '../queries/org_marketplace_queries.dart';
import '../widgets/marketplace_image_picker_field.dart';

class OrgDigitalProductDialog extends StatefulWidget {
  final PlatformMarketplaceCategoryModel category;
  final OrgDigitalProductModel? product;

  const OrgDigitalProductDialog({
    super.key,
    required this.category,
    this.product,
  });

  static Future<void> show(
    BuildContext context, {
    required PlatformMarketplaceCategoryModel category,
    OrgDigitalProductModel? product,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgDigitalProductDialog(
        category: category,
        product: product,
      ),
    );
  }

  @override
  State<OrgDigitalProductDialog> createState() => _OrgDigitalProductDialogState();
}

class _OrgDigitalProductDialogState extends State<OrgDigitalProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _queries = OrgMarketplaceQueries();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _fileFormatCtrl;
  late final TextEditingController _fileUrlCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _mrpCtrl;
  late final TextEditingController _fileSizeCtrl;

  Uint8List? _selectedCoverBytes;
  String? _selectedCoverFileName;
  String? _initialCoverUrl;
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
    _fileFormatCtrl = TextEditingController(text: p?.fileFormat ?? 'PDF / CAD');
    _fileUrlCtrl = TextEditingController(text: p?.fileUrl ?? '');
    _priceCtrl = TextEditingController(text: p?.sellingPrice != null ? p!.sellingPrice.toStringAsFixed(2) : '0');
    _mrpCtrl = TextEditingController(text: p?.mrp != null ? p!.mrp.toStringAsFixed(2) : '0');
    _fileSizeCtrl = TextEditingController(text: p?.fileSize ?? '5 MB');
    _isActive = p?.status == 'PUBLISHED' || p?.status == 'ACTIVE' || p == null;
    _initialCoverUrl = p?.coverImageUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _descCtrl.dispose();
    _fileFormatCtrl.dispose();
    _fileUrlCtrl.dispose();
    _priceCtrl.dispose();
    _mrpCtrl.dispose();
    _fileSizeCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final priceVal = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
      final mrpVal = double.tryParse(_mrpCtrl.text.trim()) ?? priceVal;

      final dataMap = <String, dynamic>{
        'categoryId': widget.category.id,
        'name': _nameCtrl.text.trim(),
        'sku': _skuCtrl.text.trim().isNotEmpty ? _skuCtrl.text.trim() : 'DIG-${DateTime.now().millisecondsSinceEpoch % 100000}',
        'description': _descCtrl.text.trim(),
        'fileFormat': _fileFormatCtrl.text.trim(),
        'fileSize': _fileSizeCtrl.text.trim(),
        'fileUrl': _fileUrlCtrl.text.trim(),
        'sellingPrice': priceVal,
        'mrp': mrpVal,
        'status': _isActive ? 'PUBLISHED' : 'DRAFT',
      };

      if (isEdit) {
        final mutation = _queries.getUpdateDigitalProductMutation();
        await mutation.mutate((
          id: widget.product!.id,
          data: dataMap,
          imageBytes: _selectedCoverBytes,
          imageFileName: _selectedCoverFileName,
        ));
      } else {
        final mutation = _queries.getCreateDigitalProductMutation();
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
          maxWidth: 600,
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
                          isEdit ? 'Edit Digital Asset' : 'Add Digital Asset / Handbook',
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
                                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.category.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6366F1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Marketplace Vertical: Digital Asset',
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
                          label: 'Digital Product Thumbnail / Cover',
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

                        // Title & SKU
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Title / Guide Name *',
                                  hintText: 'e.g. Modern Minimalist Interior Design Handbook',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Title is required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _skuCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'SKU / Identifier',
                                  hintText: 'DIG-VSTD-01',
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
                            hintText: 'Provide specifications, topics covered, or file contents',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Format & Size Row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _fileFormatCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'File Format *',
                                  hintText: 'e.g. PDF, CAD, 3DS',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Format is required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _fileSizeCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'File Size',
                                  hintText: '5.2 MB',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // File URL
                        TextFormField(
                          controller: _fileUrlCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Download URL / Drive Link *',
                            hintText: 'https://...',
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'File URL is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Price & Active Switch Row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _priceCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Selling Price (₹ INR) *',
                                  hintText: '0 for free',
                                  prefixText: '₹ ',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Price is required';
                                  if (double.tryParse(val.trim()) == null) return 'Must be a valid number';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _mrpCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'MRP / Retail Price (₹)',
                                  prefixText: '₹ ',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Row(
                              children: [
                                Switch(
                                  value: _isActive,
                                  onChanged: (val) => setState(() => _isActive = val),
                                  activeThumbColor: const Color(0xFF10B981),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isActive ? 'Active' : 'Draft',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
                                ? 'Update Digital Asset'
                                : 'Publish Digital Asset',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
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
