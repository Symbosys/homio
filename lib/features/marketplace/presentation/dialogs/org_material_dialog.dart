import 'package:cached_query_flutter/cached_query_flutter.dart';
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
  late final TextEditingController _dimensionsCtrl;
  late final TextEditingController _thicknessCtrl;
  late final TextEditingController _applicationCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _tagsCtrl;
  late final TextEditingController _wholesalePriceCtrl;
  late final TextEditingController _retailPriceCtrl;
  late final TextEditingController _taxRateCtrl;
  late final TextEditingController _minOrderCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _ownerCommissionRateCtrl;
  late final TextEditingController _ratingCtrl;
  late final TextEditingController _ordersCountCtrl;

  String _ownershipType = 'SELF_OWNED';
  String? _selectedVendorId;
  String _unitOfMeasure = 'BAG';
  String _status = 'DRAFT';
  Uint8List? _selectedCoverBytes;
  String? _selectedCoverFileName;
  String? _initialCoverUrl;
  bool _isFeatured = false;
  bool _isSubmitting = false;

  bool get isEdit => widget.material != null;

  static const List<(String, String)> _tradeUnits = [
    ('BAG', 'Bag (e.g. 50kg cement)'),
    ('PIECE', 'Piece / Unit'),
    ('TON', 'Metric Ton (MT)'),
    ('KG', 'Kilogram (Kg)'),
    ('GRAM', 'Gram (g)'),
    ('SQ_FT', 'Square Feet (sq.ft)'),
    ('SQ_M', 'Square Meter (sq.m)'),
    ('SHEET', 'Sheet (plywood / glass)'),
    ('BOX', 'Box / Carton'),
    ('BUNDLE', 'Bundle (rebars / pipes)'),
    ('PACK', 'Pack'),
    ('ROLL', 'Roll (wire / membrane)'),
    ('DRUM', 'Drum (bitumen / chemical)'),
    ('LITRE', 'Litre (L)'),
    ('ML', 'Millilitre (ml)'),
    ('METER', 'Running Meter (m)'),
    ('MM', 'Millimeter (mm)'),
    ('CM', 'Centimeter (cm)'),
    ('KM', 'Kilometer (km)'),
    ('SET', 'Set'),
    ('PAIR', 'Pair'),
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.material;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _skuCtrl = TextEditingController(text: m?.sku ?? '');
    _brandCtrl = TextEditingController(text: m?.brandName ?? '');
    _materialTypeCtrl = TextEditingController(text: m?.materialType ?? 'Cement & Aggregates');
    _gradeCtrl = TextEditingController(text: m?.grade ?? 'Grade 53 OPC');
    _dimensionsCtrl = TextEditingController(text: m?.dimensions ?? '');
    _thicknessCtrl = TextEditingController(text: m?.thickness ?? '');
    _applicationCtrl = TextEditingController(text: m?.application ?? 'Structural RCC, Foundations, Commercial Flooring');
    _descCtrl = TextEditingController(text: m?.description ?? '');
    _tagsCtrl = TextEditingController(text: m?.tags.join(', ') ?? '');
    _wholesalePriceCtrl = TextEditingController(text: m?.wholesalePrice != null ? m!.wholesalePrice.toStringAsFixed(2) : '');
    _retailPriceCtrl = TextEditingController(text: m?.retailPrice != null ? m!.retailPrice.toStringAsFixed(2) : '');
    _taxRateCtrl = TextEditingController(text: m?.taxRate != null ? m!.taxRate.toStringAsFixed(1) : '18.0');
    _minOrderCtrl = TextEditingController(text: m?.minOrderQuantity != null ? m!.minOrderQuantity.toString() : '50');
    _stockCtrl = TextEditingController(text: m?.stockAvailableUnits != null ? m!.stockAvailableUnits.toString() : '500');
    _ownerCommissionRateCtrl = TextEditingController(text: m?.ownerCommissionRate != null ? m!.ownerCommissionRate!.toStringAsFixed(1) : '');
    _ratingCtrl = TextEditingController(text: m?.rating != null ? m!.rating.toStringAsFixed(1) : '0.0');
    _ordersCountCtrl = TextEditingController(text: (m?.ordersCount ?? 0).toString());

    _ownershipType = m?.ownershipType ?? 'SELF_OWNED';
    _selectedVendorId = m?.vendorId;
    _unitOfMeasure = m?.unitOfMeasure ?? 'BAG';
    _status = m?.status ?? 'DRAFT';
    _isFeatured = m?.isFeatured ?? false;
    _initialCoverUrl = m?.coverImageUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _brandCtrl.dispose();
    _materialTypeCtrl.dispose();
    _gradeCtrl.dispose();
    _dimensionsCtrl.dispose();
    _thicknessCtrl.dispose();
    _applicationCtrl.dispose();
    _descCtrl.dispose();
    _tagsCtrl.dispose();
    _wholesalePriceCtrl.dispose();
    _retailPriceCtrl.dispose();
    _taxRateCtrl.dispose();
    _minOrderCtrl.dispose();
    _stockCtrl.dispose();
    _ownerCommissionRateCtrl.dispose();
    _ratingCtrl.dispose();
    _ordersCountCtrl.dispose();
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
      final taxVal = double.tryParse(_taxRateCtrl.text.trim()) ?? 18.0;
      final minOrderVal = int.tryParse(_minOrderCtrl.text.trim()) ?? 1;
      final stockVal = int.tryParse(_stockCtrl.text.trim()) ?? 100;
      final ownerCommVal = double.tryParse(_ownerCommissionRateCtrl.text.trim());
      final ratingVal = double.tryParse(_ratingCtrl.text.trim()) ?? 0.0;
      final ordersVal = int.tryParse(_ordersCountCtrl.text.trim()) ?? 0;
      final tagsList = _tagsCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final dataMap = <String, dynamic>{
        'categoryId': widget.category.id,
        'name': _nameCtrl.text.trim(),
        'sku': _skuCtrl.text.trim().isNotEmpty ? _skuCtrl.text.trim() : 'MAT-${DateTime.now().millisecondsSinceEpoch % 100000}',
        'brandName': _brandCtrl.text.trim().isNotEmpty ? _brandCtrl.text.trim() : null,
        'materialType': _materialTypeCtrl.text.trim().isNotEmpty ? _materialTypeCtrl.text.trim() : null,
        'grade': _gradeCtrl.text.trim().isNotEmpty ? _gradeCtrl.text.trim() : null,
        'dimensions': _dimensionsCtrl.text.trim().isNotEmpty ? _dimensionsCtrl.text.trim() : null,
        'thickness': _thicknessCtrl.text.trim().isNotEmpty ? _thicknessCtrl.text.trim() : null,
        'application': _applicationCtrl.text.trim().isNotEmpty ? _applicationCtrl.text.trim() : null,
        'description': _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
        'tags': tagsList,
        'ownershipType': _ownershipType,
        'vendorId': _ownershipType == 'VENDOR_OWNED' ? _selectedVendorId : null,
        'ownerCommissionRate': _ownershipType == 'VENDOR_OWNED' ? ownerCommVal : null,
        'unitOfMeasure': _unitOfMeasure,
        'wholesalePrice': wholesaleVal,
        'retailPrice': retailVal,
        'taxRate': taxVal,
        'minOrderQuantity': minOrderVal,
        'stockAvailableUnits': stockVal,
        'rating': ratingVal,
        'ordersCount': ordersVal,
        'status': _status,
        'isFeatured': _isFeatured,
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
          maxWidth: 750,
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
                              'Marketplace Vertical: Materials & Raw Procurement',
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

                        // Ownership & Vendor Section
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
                              Text(
                                'Ownership & Fulfillment Source',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ChoiceChip(
                                    label: const Text('Self-Owned / Direct Yard'),
                                    selected: _ownershipType == 'SELF_OWNED',
                                    onSelected: (sel) {
                                      if (sel) setState(() => _ownershipType = 'SELF_OWNED');
                                    },
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  ChoiceChip(
                                    label: const Text('Vendor / Supplier Channel'),
                                    selected: _ownershipType == 'VENDOR_OWNED',
                                    onSelected: (sel) {
                                      if (sel) setState(() => _ownershipType = 'VENDOR_OWNED');
                                    },
                                  ),
                                ],
                              ),
                              if (_ownershipType == 'VENDOR_OWNED') ...[
                                const SizedBox(height: AppSpacing.md),
                                QueryBuilder(
                                  query: _queries.getVendorsQuery(),
                                  builder: (context, vState) {
                                    final vendors = vState.data ?? <OrgVendorModel>[];
                                    return DropdownButtonFormField<String>(
                                      initialValue: _selectedVendorId,
                                      decoration: const InputDecoration(
                                        labelText: 'Select Registered Supplier / Vendor *',
                                      ),
                                      items: vendors.map((v) {
                                        return DropdownMenuItem<String>(
                                          value: v.id,
                                          child: Text('${v.companyName} (${v.taxId ?? "Supplier"})'),
                                        );
                                      }).toList(),
                                      onChanged: (val) => setState(() => _selectedVendorId = val),
                                    );
                                  },
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                TextFormField(
                                  controller: _ownerCommissionRateCtrl,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Owner Commission Rate (%)',
                                    hintText: 'e.g. 10.0',
                                    suffixText: '%',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Name, SKU & Brand
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
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _brandCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Brand / Manufacturer',
                                  hintText: 'UltraTech / Tata Steel',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Material Type, Grade & Application
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _materialTypeCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Material Classification',
                                  hintText: 'Cement / TMT Steel / Plywood',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _gradeCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Grade / Specification Standard',
                                  hintText: 'IS: 12269 / Fe 550D',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _applicationCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Application / Use Case',
                                  hintText: 'RCC Slab, Columns, Foundation',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Dimensions & Thickness & Tags
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _dimensionsCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Dimensions / Dimensions Spec',
                                  hintText: 'e.g. 8ft x 4ft / 12m length',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _thicknessCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Thickness / Diameter',
                                  hintText: 'e.g. 18mm / 12mm TMT',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _tagsCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Tags (comma-separated)',
                                  hintText: 'Cement, 53 Grade, Bulk',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Unit of Measure, Wholesale Price, Retail Price & Tax Rate
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                initialValue: _unitOfMeasure,
                                decoration: const InputDecoration(labelText: 'Trade Unit of Measure *'),
                                items: _tradeUnits.map((u) {
                                  return DropdownMenuItem<String>(
                                    value: u.$1,
                                    child: Text(u.$2),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _unitOfMeasure = val);
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
                                controller: _retailPriceCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Retail / MRP (₹)',
                                  prefixText: '₹ ',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _taxRateCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'GST Rate (%)',
                                  suffixText: '%',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Min Order Qty & Stock
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _minOrderCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Min Order Qty (Units) *',
                                  hintText: '50',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Min order required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _stockCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Available Stock (Units) *',
                                  hintText: '500',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Stock required';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Admin Metrics & Social Proof Panel
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
                                  const Icon(Icons.admin_panel_settings_rounded, size: 16, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Admin Performance & Order Stats',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _ratingCtrl,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                        labelText: 'Rating (0.0 - 5.0)',
                                        hintText: '4.9',
                                        prefixIcon: Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _ordersCountCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Total Orders Fulfilled',
                                        hintText: '120',
                                        prefixIcon: Icon(Icons.local_shipping_rounded, size: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      initialValue: _status,
                                      decoration: const InputDecoration(labelText: 'Status *'),
                                      items: const [
                                        DropdownMenuItem(value: 'PUBLISHED', child: Text('PUBLISHED (In Store)')),
                                        DropdownMenuItem(value: 'DRAFT', child: Text('DRAFT (Hidden)')),
                                        DropdownMenuItem(value: 'ARCHIVED', child: Text('ARCHIVED')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) setState(() => _status = val);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Description
                        TextFormField(
                          controller: _descCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description & Bulk Delivery Terms',
                            hintText: 'Describe composition, delivery radius, unloading charges, quality tests, and manufacturer warranty',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Featured Switch
                        Row(
                          children: [
                            Switch(
                              value: _isFeatured,
                              onChanged: (val) => setState(() => _isFeatured = val),
                              activeThumbColor: const Color(0xFF6366F1),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Featured in Materials Showcase',
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
