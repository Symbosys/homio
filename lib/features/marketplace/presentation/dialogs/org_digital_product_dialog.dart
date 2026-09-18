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
  late final TextEditingController _authorCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _tagsCtrl;
  late final TextEditingController _fileUrlCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _mrpCtrl;
  late final TextEditingController _taxRateCtrl;
  late final TextEditingController _fileSizeCtrl;
  late final TextEditingController _expiryHoursCtrl;
  late final TextEditingController _maxDownloadsCtrl;
  late final TextEditingController _ratingCtrl;
  late final TextEditingController _reviewsCountCtrl;
  late final TextEditingController _totalPurchasesCtrl;

  String _fileFormat = 'PDF';
  Uint8List? _selectedCoverBytes;
  String? _selectedCoverFileName;
  String? _initialCoverUrl;
  bool _isActive = true;
  bool _isFeatured = false;
  bool _isSubmitting = false;

  bool get isEdit => widget.product != null;

  static const List<String> _digitalFormats = [
    'PDF',
    'EPUB',
    'ZIP',
    'DWG',
    'DXF',
    'RVT',
    'SKP',
    'OBJ',
    'FBX',
    'DOCX',
    'XLSX',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? '');
    _authorCtrl = TextEditingController(text: p?.authorName ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _tagsCtrl = TextEditingController(text: p?.tags.join(', ') ?? '');
    _fileFormat = p?.fileFormat ?? 'PDF';
    if (!_digitalFormats.contains(_fileFormat)) _fileFormat = 'OTHER';
    _fileUrlCtrl = TextEditingController(text: p?.fileUrl ?? '');
    _priceCtrl = TextEditingController(text: p?.sellingPrice != null ? p!.sellingPrice.toStringAsFixed(2) : '0');
    _mrpCtrl = TextEditingController(text: p?.mrp != null ? p!.mrp.toStringAsFixed(2) : '0');
    _taxRateCtrl = TextEditingController(text: p?.taxRate != null ? p!.taxRate.toStringAsFixed(1) : '18.0');
    _fileSizeCtrl = TextEditingController(text: p?.fileSize ?? '5 MB');
    _expiryHoursCtrl = TextEditingController(text: (p?.downloadLinkExpiryHours ?? 48).toString());
    _maxDownloadsCtrl = TextEditingController(text: (p?.maxDownloads ?? 5).toString());
    _ratingCtrl = TextEditingController(text: p?.rating != null ? p!.rating.toStringAsFixed(1) : '0.0');
    _reviewsCountCtrl = TextEditingController(text: (p?.reviewsCount ?? 0).toString());
    _totalPurchasesCtrl = TextEditingController(text: (p?.totalPurchases ?? 0).toString());
    _isActive = p?.status == 'PUBLISHED' || p?.status == 'ACTIVE' || p == null;
    _isFeatured = p?.isFeatured ?? false;
    _initialCoverUrl = p?.coverImageUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _authorCtrl.dispose();
    _descCtrl.dispose();
    _tagsCtrl.dispose();
    _fileUrlCtrl.dispose();
    _priceCtrl.dispose();
    _mrpCtrl.dispose();
    _taxRateCtrl.dispose();
    _fileSizeCtrl.dispose();
    _expiryHoursCtrl.dispose();
    _maxDownloadsCtrl.dispose();
    _ratingCtrl.dispose();
    _reviewsCountCtrl.dispose();
    _totalPurchasesCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final priceVal = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
      final mrpVal = double.tryParse(_mrpCtrl.text.trim()) ?? priceVal;
      final taxVal = double.tryParse(_taxRateCtrl.text.trim()) ?? 18.0;
      final expiryVal = int.tryParse(_expiryHoursCtrl.text.trim()) ?? 48;
      final maxDlVal = int.tryParse(_maxDownloadsCtrl.text.trim()) ?? 5;
      final ratingVal = double.tryParse(_ratingCtrl.text.trim()) ?? 0.0;
      final reviewsVal = int.tryParse(_reviewsCountCtrl.text.trim()) ?? 0;
      final purchasesVal = int.tryParse(_totalPurchasesCtrl.text.trim()) ?? 0;
      final tagsList = _tagsCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final dataMap = <String, dynamic>{
        'categoryId': widget.category.id,
        'name': _nameCtrl.text.trim(),
        'sku': _skuCtrl.text.trim().isNotEmpty ? _skuCtrl.text.trim() : 'DIG-${DateTime.now().millisecondsSinceEpoch % 100000}',
        'authorName': _authorCtrl.text.trim().isNotEmpty ? _authorCtrl.text.trim() : null,
        'description': _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
        'tags': tagsList,
        'fileFormat': _fileFormat,
        'fileSize': _fileSizeCtrl.text.trim().isNotEmpty ? _fileSizeCtrl.text.trim() : null,
        'fileUrl': _fileUrlCtrl.text.trim(),
        'sellingPrice': priceVal,
        'mrp': mrpVal,
        'taxRate': taxVal,
        'downloadLinkExpiryHours': expiryVal,
        'maxDownloads': maxDlVal,
        'rating': ratingVal,
        'reviewsCount': reviewsVal,
        'totalPurchases': purchasesVal,
        'isFeatured': _isFeatured,
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
          maxWidth: 720,
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
                          isEdit ? 'Edit Digital Asset / Handbook' : 'Add Digital Asset / Publication',
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
                              'Marketplace Vertical: Digital Assets',
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
                        // Cover Image Picker
                        MarketplaceImagePickerField(
                          label: 'Digital Asset Cover / Book Mockup Image',
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

                        // Title, SKU & Author
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Asset / Publication Title *',
                                  hintText: 'e.g. Modern Villa Architecture Guide 2026',
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
                                  labelText: 'SKU / Asset Code',
                                  hintText: 'DIG-ARCH-001',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _authorCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Author / Creator',
                                  hintText: 'Homio Studio',
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

                        // Tags
                        TextFormField(
                          controller: _tagsCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Search Tags (comma-separated)',
                            hintText: 'Architecture, Interior, Vastu, PDF, 3D',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Format (Enum Dropdown) & Size Row
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _fileFormat,
                                decoration: const InputDecoration(
                                  labelText: 'Digital File Format (Enum) *',
                                ),
                                items: _digitalFormats.map((f) {
                                  return DropdownMenuItem<String>(
                                    value: f,
                                    child: Text(f),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _fileFormat = val);
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
                            labelText: 'Download URL / Secure Asset Link *',
                            hintText: 'https://storage.homio.app/...',
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'File URL is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Access Limits: Expiry, Max Downloads, Tax Rate
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _expiryHoursCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Download Link Expiry (Hours)',
                                  hintText: '48',
                                  suffixText: 'hrs',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _maxDownloadsCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Max Download Count Limit',
                                  hintText: '5',
                                  suffixText: 'times',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _taxRateCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'GST / Tax Rate (%)',
                                  hintText: '18.0',
                                  suffixText: '%',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Price & MRP
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
                                  labelText: 'MRP / List Price (₹)',
                                  prefixText: '₹ ',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Admin Metrics & Manual Overrides Container
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: AppRadius.md,
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.admin_panel_settings_rounded, size: 16, color: Color(0xFF6366F1)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Admin Metrics & Social Proof Settings',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _ratingCtrl,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                        labelText: 'Rating (0.0 - 5.0)',
                                        hintText: '4.8',
                                        prefixIcon: Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _reviewsCountCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Reviews / Rating Count',
                                        hintText: '50',
                                        prefixIcon: Icon(Icons.reviews_rounded, size: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _totalPurchasesCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Total Purchases / Downloads',
                                        hintText: '250',
                                        prefixIcon: Icon(Icons.shopping_bag_rounded, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Status & Featured
                        Row(
                          children: [
                            Switch(
                              value: _isActive,
                              onChanged: (val) => setState(() => _isActive = val),
                              activeThumbColor: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isActive ? 'Published in Store' : 'Draft / Private',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: AppSpacing.xl),
                            Switch(
                              value: _isFeatured,
                              onChanged: (val) => setState(() => _isFeatured = val),
                              activeThumbColor: const Color(0xFF6366F1),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Featured Spotlight Asset',
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
                                ? 'Update Digital Asset'
                                : 'Create Digital Asset',
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
