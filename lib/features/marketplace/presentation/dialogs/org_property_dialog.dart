import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';
import '../../data/models/org_marketplace_models.dart';
import '../queries/org_marketplace_queries.dart';
import '../widgets/marketplace_image_picker_field.dart';

class OrgPropertyDialog extends StatefulWidget {
  final PlatformMarketplaceCategoryModel category;
  final OrgPropertyListingModel? property;

  const OrgPropertyDialog({
    super.key,
    required this.category,
    this.property,
  });

  static Future<void> show(
    BuildContext context, {
    required PlatformMarketplaceCategoryModel category,
    OrgPropertyListingModel? property,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OrgPropertyDialog(
        category: category,
        property: property,
      ),
    );
  }

  @override
  State<OrgPropertyDialog> createState() => _OrgPropertyDialogState();
}

class _OrgPropertyDialogState extends State<OrgPropertyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _queries = OrgMarketplaceQueries();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _propertyTypeCtrl;
  late final TextEditingController _intentCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _bhkCtrl;
  late final TextEditingController _bathsCtrl;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _localityCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _amenitiesCtrl;
  late final TextEditingController _ownerNameCtrl;
  late final TextEditingController _ownerPhoneCtrl;

  Uint8List? _selectedCoverBytes;
  String? _selectedCoverFileName;
  String? _initialCoverUrl;
  bool _isFeatured = false;
  bool _isSubmitting = false;

  bool get isEdit => widget.property != null;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _propertyTypeCtrl = TextEditingController(text: p?.propertyType ?? 'APARTMENT');
    _intentCtrl = TextEditingController(text: p?.intent ?? 'SALE');
    _priceCtrl = TextEditingController(text: p?.price != null ? p!.price.toStringAsFixed(0) : '');
    _bhkCtrl = TextEditingController(text: p?.bhk ?? '3 BHK');
    _bathsCtrl = TextEditingController(text: p?.bathrooms != null ? p!.bathrooms.toString() : '2');
    _areaCtrl = TextEditingController(text: p?.carpetAreaSqft != null ? p!.carpetAreaSqft.toString() : '1500');
    _localityCtrl = TextEditingController(text: p?.locality ?? '');
    _cityCtrl = TextEditingController(text: p?.city ?? 'Gurugram');
    _stateCtrl = TextEditingController(text: p?.state ?? 'Haryana');
    _ownerNameCtrl = TextEditingController(text: p?.ownerName ?? 'Direct Owner');
    _ownerPhoneCtrl = TextEditingController(text: p?.ownerPhone ?? '+91 9876543210');
    _amenitiesCtrl = TextEditingController(text: p?.amenities.join(', ') ?? 'Gym, Pool, Clubhouse, 24/7 Security');
    _isFeatured = p?.isFeatured ?? false;
    _initialCoverUrl = p?.coverImageUrl;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _propertyTypeCtrl.dispose();
    _intentCtrl.dispose();
    _priceCtrl.dispose();
    _bhkCtrl.dispose();
    _bathsCtrl.dispose();
    _areaCtrl.dispose();
    _localityCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _ownerNameCtrl.dispose();
    _ownerPhoneCtrl.dispose();
    _amenitiesCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final priceVal = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
      final bathsVal = int.tryParse(_bathsCtrl.text.trim()) ?? 2;
      final areaVal = int.tryParse(_areaCtrl.text.trim()) ?? 1200;
      final amenitiesList = _amenitiesCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final dataMap = <String, dynamic>{
        'categoryId': widget.category.id,
        'title': _titleCtrl.text.trim(),
        'propertyType': _propertyTypeCtrl.text.trim(),
        'intent': _intentCtrl.text.trim(),
        'price': priceVal,
        'bhk': _bhkCtrl.text.trim(),
        'bathrooms': bathsVal,
        'carpetAreaSqft': areaVal,
        'locality': _localityCtrl.text.trim(),
        'city': _cityCtrl.text.trim(),
        'state': _stateCtrl.text.trim(),
        'ownerName': _ownerNameCtrl.text.trim(),
        'ownerPhone': _ownerPhoneCtrl.text.trim(),
        'description': _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
        'amenities': amenitiesList,
        'isFeatured': _isFeatured,
      };

      if (isEdit) {
        final mutation = _queries.getUpdatePropertyMutation();
        await mutation.mutate((
          id: widget.property!.id,
          data: dataMap,
          imageBytes: _selectedCoverBytes,
          imageFileName: _selectedCoverFileName,
        ));
      } else {
        final mutation = _queries.getCreatePropertyMutation();
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
          maxWidth: 660,
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
                          isEdit ? 'Edit Property Listing' : 'Add Real Estate Property Listing',
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
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.category.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Marketplace Vertical: Properties',
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
                          label: 'Property Primary Exterior / Interior Photo',
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

                        // Title
                        TextFormField(
                          controller: _titleCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Listing Title *',
                            hintText: 'e.g. 3BHK Luxury High-Rise Apartment in Cyber City',
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Title is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Property Type & Intent
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _propertyTypeCtrl.text,
                                decoration: const InputDecoration(labelText: 'Property Type *'),
                                items: const [
                                  DropdownMenuItem(value: 'APARTMENT', child: Text('Apartment / Flat')),
                                  DropdownMenuItem(value: 'VILLA', child: Text('Independent Villa / House')),
                                  DropdownMenuItem(value: 'PENTHOUSE', child: Text('Penthouse')),
                                  DropdownMenuItem(value: 'COMMERCIAL', child: Text('Commercial Space / Office')),
                                  DropdownMenuItem(value: 'PLOT', child: Text('Residential / Commercial Plot')),
                                ],
                                onChanged: (val) {
                                  if (val != null) _propertyTypeCtrl.text = val;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _intentCtrl.text,
                                decoration: const InputDecoration(labelText: 'Listing Model *'),
                                items: const [
                                  DropdownMenuItem(value: 'SALE', child: Text('For Sale')),
                                  DropdownMenuItem(value: 'RENT', child: Text('For Rent')),
                                  DropdownMenuItem(value: 'LEASE', child: Text('Commercial Lease')),
                                ],
                                onChanged: (val) {
                                  if (val != null) _intentCtrl.text = val;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Price, BHK, Area Sqft
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _priceCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Price (₹ INR) *',
                                  prefixText: '₹ ',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Price is required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _bhkCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Configuration',
                                  hintText: '3 BHK',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _areaCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Carpet Area (Sq. Ft) *',
                                  hintText: '1500',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Area required';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Location
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _localityCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Locality / Sector',
                                  hintText: 'Sector 54, Golf Course Rd',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _cityCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'City *',
                                  hintText: 'Gurugram',
                                ),
                                validator: (val) => val == null || val.trim().isEmpty ? 'City required' : null,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _stateCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'State *',
                                  hintText: 'Haryana',
                                ),
                                validator: (val) => val == null || val.trim().isEmpty ? 'State required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Owner Details Row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _ownerNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Contact / Owner Name *',
                                  hintText: 'Sunil Verma',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _ownerPhoneCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Contact Phone *',
                                  hintText: '+91 9876543210',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Amenities
                        TextFormField(
                          controller: _amenitiesCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Key Amenities (comma separated)',
                            hintText: 'Swimming Pool, Gym, Gated Security, EV Charging',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Description
                        TextFormField(
                          controller: _descCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Property Description',
                            hintText: 'Highlight construction quality, view, direction, and furnishings',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Row(
                          children: [
                            Switch(
                              value: _isFeatured,
                              onChanged: (val) => setState(() => _isFeatured = val),
                              activeThumbColor: const Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Feature on Homepage Spotlight',
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
                                ? 'Update Property'
                                : 'Publish Property Listing',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
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
