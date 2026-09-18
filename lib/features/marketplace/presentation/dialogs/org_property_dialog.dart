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
  late final TextEditingController _bhkCtrl;
  late final TextEditingController _bedroomsCtrl;
  late final TextEditingController _bathsCtrl;
  late final TextEditingController _balconiesCtrl;
  late final TextEditingController _carpetAreaCtrl;
  late final TextEditingController _superBuiltUpCtrl;
  late final TextEditingController _floorNumberCtrl;
  late final TextEditingController _totalFloorsCtrl;
  late final TextEditingController _furnishingCtrl;
  late final TextEditingController _parkingSlotsCtrl;
  late final TextEditingController _availableFromCtrl;
  late final TextEditingController _addressLineCtrl;
  late final TextEditingController _localityCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _pinCodeCtrl;
  late final TextEditingController _latitudeCtrl;
  late final TextEditingController _longitudeCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _maintenanceCtrl;
  late final TextEditingController _unlockFeeCtrl;
  late final TextEditingController _unlockDaysCtrl;
  late final TextEditingController _totalUnlocksCtrl;
  late final TextEditingController _ownerNameCtrl;
  late final TextEditingController _ownerPhoneCtrl;
  late final TextEditingController _ownerEmailCtrl;
  late final TextEditingController _amenitiesCtrl;

  Uint8List? _selectedCoverBytes;
  String? _selectedCoverFileName;
  String? _initialCoverUrl;
  bool _isNegotiable = true;
  bool _isFeatured = false;
  String _verificationStatus = 'DRAFT';
  String _status = 'DRAFT';
  bool _isSubmitting = false;

  bool get isEdit => widget.property != null;

  static const List<String> _propertyTypes = [
    'APARTMENT',
    'PENTHOUSE',
    'BUILDER_FLOOR',
    'VILLA',
    'COMMERCIAL',
  ];

  static const List<String> _furnishingStatuses = [
    'Unfurnished',
    'Semi-Furnished',
    'Fully Furnished',
  ];

  static const List<String> _verificationStatuses = [
    'DRAFT',
    'UNDER_REVIEW',
    'VERIFIED',
    'REJECTED',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _propertyTypeCtrl = TextEditingController(text: p?.propertyType ?? 'APARTMENT');
    _intentCtrl = TextEditingController(text: p?.intent ?? 'SALE');
    _bhkCtrl = TextEditingController(text: p?.bhk ?? '3 BHK');
    _bedroomsCtrl = TextEditingController(text: (p?.bedrooms ?? 3).toString());
    _bathsCtrl = TextEditingController(text: (p?.bathrooms ?? 2).toString());
    _balconiesCtrl = TextEditingController(text: (p?.balconies ?? 1).toString());
    _carpetAreaCtrl = TextEditingController(text: p?.carpetAreaSqft != null ? p!.carpetAreaSqft.toString() : '1500');
    _superBuiltUpCtrl = TextEditingController(text: p?.superBuiltUpSqft != null ? p!.superBuiltUpSqft.toString() : '');
    _floorNumberCtrl = TextEditingController(text: p?.floorNumber != null ? p!.floorNumber.toString() : '');
    _totalFloorsCtrl = TextEditingController(text: p?.totalFloors != null ? p!.totalFloors.toString() : '');
    _furnishingCtrl = TextEditingController(text: p?.furnishingStatus ?? 'Semi-Furnished');
    _parkingSlotsCtrl = TextEditingController(text: (p?.coveredParkingSlots ?? 1).toString());
    _availableFromCtrl = TextEditingController(
      text: p?.availableFrom != null ? p!.availableFrom!.toIso8601String().split('T').first : '',
    );
    _addressLineCtrl = TextEditingController(text: p?.addressLine ?? '');
    _localityCtrl = TextEditingController(text: p?.locality ?? '');
    _cityCtrl = TextEditingController(text: p?.city ?? 'Gurugram');
    _stateCtrl = TextEditingController(text: p?.state ?? 'Haryana');
    _pinCodeCtrl = TextEditingController(text: p?.pinCode ?? '');
    _latitudeCtrl = TextEditingController(text: p?.latitude != null ? p!.latitude.toString() : '');
    _longitudeCtrl = TextEditingController(text: p?.longitude != null ? p!.longitude.toString() : '');
    _priceCtrl = TextEditingController(text: p?.price != null ? p!.price.toStringAsFixed(0) : '');
    _maintenanceCtrl = TextEditingController(text: p?.maintenanceMonthly != null ? p!.maintenanceMonthly.toStringAsFixed(0) : '0');
    _unlockFeeCtrl = TextEditingController(text: p?.contactUnlockFee != null ? p!.contactUnlockFee.toStringAsFixed(0) : '500');
    _unlockDaysCtrl = TextEditingController(text: (p?.contactUnlockDurationDays ?? 30).toString());
    _totalUnlocksCtrl = TextEditingController(text: (p?.totalContactUnlocks ?? 0).toString());
    _ownerNameCtrl = TextEditingController(text: p?.ownerName ?? 'Direct Owner');
    _ownerPhoneCtrl = TextEditingController(text: p?.ownerPhone ?? '+91 9876543210');
    _ownerEmailCtrl = TextEditingController(text: p?.ownerEmail ?? '');
    _amenitiesCtrl = TextEditingController(text: p?.amenities.join(', ') ?? 'Gym, Swimming Pool, Clubhouse, 24/7 Power Backup, Gated Security');
    _isNegotiable = p?.isNegotiable ?? true;
    _isFeatured = p?.isFeatured ?? false;
    _verificationStatus = p?.verificationStatus ?? 'DRAFT';
    _status = p?.status ?? 'DRAFT';
    _initialCoverUrl = p?.coverImageUrl;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _propertyTypeCtrl.dispose();
    _intentCtrl.dispose();
    _bhkCtrl.dispose();
    _bedroomsCtrl.dispose();
    _bathsCtrl.dispose();
    _balconiesCtrl.dispose();
    _carpetAreaCtrl.dispose();
    _superBuiltUpCtrl.dispose();
    _floorNumberCtrl.dispose();
    _totalFloorsCtrl.dispose();
    _furnishingCtrl.dispose();
    _parkingSlotsCtrl.dispose();
    _availableFromCtrl.dispose();
    _addressLineCtrl.dispose();
    _localityCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pinCodeCtrl.dispose();
    _latitudeCtrl.dispose();
    _longitudeCtrl.dispose();
    _priceCtrl.dispose();
    _maintenanceCtrl.dispose();
    _unlockFeeCtrl.dispose();
    _unlockDaysCtrl.dispose();
    _totalUnlocksCtrl.dispose();
    _ownerNameCtrl.dispose();
    _ownerPhoneCtrl.dispose();
    _ownerEmailCtrl.dispose();
    _amenitiesCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final priceVal = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
      final maintVal = double.tryParse(_maintenanceCtrl.text.trim()) ?? 0.0;
      final unlockFeeVal = double.tryParse(_unlockFeeCtrl.text.trim()) ?? 500.0;
      final unlockDaysVal = int.tryParse(_unlockDaysCtrl.text.trim()) ?? 30;
      final totalUnlocksVal = int.tryParse(_totalUnlocksCtrl.text.trim()) ?? 0;
      final bedsVal = int.tryParse(_bedroomsCtrl.text.trim()) ?? 2;
      final bathsVal = int.tryParse(_bathsCtrl.text.trim()) ?? 2;
      final balconiesVal = int.tryParse(_balconiesCtrl.text.trim()) ?? 1;
      final carpetAreaVal = int.tryParse(_carpetAreaCtrl.text.trim()) ?? 1200;
      final superAreaVal = int.tryParse(_superBuiltUpCtrl.text.trim());
      final floorNumVal = int.tryParse(_floorNumberCtrl.text.trim());
      final totalFloorsVal = int.tryParse(_totalFloorsCtrl.text.trim());
      final parkingVal = int.tryParse(_parkingSlotsCtrl.text.trim()) ?? 1;
      final latVal = double.tryParse(_latitudeCtrl.text.trim());
      final lngVal = double.tryParse(_longitudeCtrl.text.trim());
      final availDate = _availableFromCtrl.text.trim().isNotEmpty
          ? DateTime.tryParse(_availableFromCtrl.text.trim())
          : null;

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
        'verificationStatus': _verificationStatus,
        'bhk': _bhkCtrl.text.trim(),
        'bedrooms': bedsVal,
        'bathrooms': bathsVal,
        'balconies': balconiesVal,
        'carpetAreaSqft': carpetAreaVal,
        'superBuiltUpSqft': superAreaVal,
        'floorNumber': floorNumVal,
        'totalFloors': totalFloorsVal,
        'furnishingStatus': _furnishingCtrl.text.trim(),
        'coveredParkingSlots': parkingVal,
        'availableFrom': availDate?.toIso8601String(),
        'addressLine': _addressLineCtrl.text.trim().isNotEmpty ? _addressLineCtrl.text.trim() : null,
        'locality': _localityCtrl.text.trim(),
        'city': _cityCtrl.text.trim(),
        'state': _stateCtrl.text.trim(),
        'pinCode': _pinCodeCtrl.text.trim().isNotEmpty ? _pinCodeCtrl.text.trim() : null,
        'latitude': latVal,
        'longitude': lngVal,
        'price': priceVal,
        'maintenanceMonthly': maintVal,
        'isNegotiable': _isNegotiable,
        'contactUnlockFee': unlockFeeVal,
        'contactUnlockDurationDays': unlockDaysVal,
        'totalContactUnlocks': totalUnlocksVal,
        'ownerName': _ownerNameCtrl.text.trim(),
        'ownerPhone': _ownerPhoneCtrl.text.trim(),
        'ownerEmail': _ownerEmailCtrl.text.trim().isNotEmpty ? _ownerEmailCtrl.text.trim() : null,
        'amenities': amenitiesList,
        'description': _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
        'status': _status,
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
          maxWidth: 820,
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
                          isEdit ? 'Edit Property Listing' : 'Add Verified Real Estate Listing',
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
                              'Marketplace Vertical: Verified Properties',
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
                        // Cover Photo
                        MarketplaceImagePickerField(
                          label: 'Primary Property Photo / Elevation Image',
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

                        // Intent & Property Type Row
                        Row(
                          children: [
                            Text(
                              'Transaction Intent: ',
                              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('For Sale'),
                              selected: _intentCtrl.text == 'SALE',
                              onSelected: (sel) {
                                if (sel) setState(() => _intentCtrl.text = 'SALE');
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('For Rent / Lease'),
                              selected: _intentCtrl.text == 'RENT',
                              onSelected: (sel) {
                                if (sel) setState(() => _intentCtrl.text = 'RENT');
                              },
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 220,
                              child: DropdownButtonFormField<String>(
                                initialValue: _propertyTypeCtrl.text,
                                decoration: const InputDecoration(labelText: 'Property Typology *'),
                                items: _propertyTypes.map((t) {
                                  return DropdownMenuItem<String>(
                                    value: t,
                                    child: Text(t.replaceAll('_', ' ')),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _propertyTypeCtrl.text = val);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Title
                        TextFormField(
                          controller: _titleCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Property Title *',
                            hintText: 'e.g. Luxurious 3 BHK Sun-Facing Apartment with Private Terrace',
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Title is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // BHK, Beds, Baths, Balconies
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _bhkCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'BHK Configuration *',
                                  hintText: '3 BHK / Studio / Duplex',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'BHK is required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _bedroomsCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Bedrooms *'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _bathsCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Bathrooms *'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _balconiesCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Balconies'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Carpet Area, Super Area, Floor No, Total Floors
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _carpetAreaCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Carpet Area (Sq.Ft) *',
                                  suffixText: 'sqft',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Carpet area required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _superBuiltUpCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Super Built-up (Sq.Ft)',
                                  suffixText: 'sqft',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _floorNumberCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Floor Number',
                                  hintText: 'e.g. 7',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _totalFloorsCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Total Floors',
                                  hintText: 'e.g. 14',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Furnishing, Covered Parking, Available From Date
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _furnishingCtrl.text,
                                decoration: const InputDecoration(labelText: 'Furnishing Status *'),
                                items: _furnishingStatuses.map((f) {
                                  return DropdownMenuItem<String>(value: f, child: Text(f));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) _furnishingCtrl.text = val;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _parkingSlotsCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Covered Parking Slots',
                                  hintText: '1',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _availableFromCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Available From (YYYY-MM-DD)',
                                  hintText: 'e.g. 2026-10-01',
                                  prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Location Section Header & Inputs
                        Text(
                          'Property Location & Geo Coordinates',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _addressLineCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Full Address / Project Name / Unit Number',
                            hintText: 'Flat 702, Tower B, DLF Phase 5',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _localityCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Locality / Sector *',
                                  hintText: 'Sector 54, Golf Course Road',
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Locality required';
                                  return null;
                                },
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
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'City required';
                                  return null;
                                },
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
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'State required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _pinCodeCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'PIN Code',
                                  hintText: '122002',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // GPS Coordinates: Lat & Long
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _latitudeCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Latitude (Optional GPS)',
                                  hintText: '28.4595',
                                  prefixIcon: Icon(Icons.location_on_outlined, size: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _longitudeCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Longitude (Optional GPS)',
                                  hintText: '77.0266',
                                  prefixIcon: Icon(Icons.location_on_outlined, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Pricing & Monetization Section
                        Text(
                          'Pricing & Contact Unlock Monetization',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _priceCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: _intentCtrl.text == 'SALE' ? 'Total Price (₹) *' : 'Monthly Rent (₹) *',
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
                                controller: _maintenanceCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Monthly Maintenance (₹)',
                                  prefixText: '₹ ',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _unlockFeeCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Lead Unlock Fee (₹)',
                                  prefixText: '₹ ',
                                  hintText: '500',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _unlockDaysCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Unlock Validity (Days)',
                                  hintText: '30',
                                  suffixText: 'days',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Owner Contact Details (Secured Behind Unlock)
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
                                  const Icon(Icons.lock_person_rounded, size: 16, color: Color(0xFF10B981)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Owner Contact Details (Protected Behind Unlock Fee)',
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
                                      controller: _ownerNameCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'Owner / Seller Name *',
                                      ),
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) return 'Owner name required';
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _ownerPhoneCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'Owner Contact Phone *',
                                      ),
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) return 'Owner phone required';
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _ownerEmailCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'Owner Email (Optional)',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Amenities
                        TextFormField(
                          controller: _amenitiesCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Amenities (comma-separated)',
                            hintText: 'Gym, Swimming Pool, Clubhouse, Power Backup, Security, Lift, Park',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Description
                        TextFormField(
                          controller: _descCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Detailed Description & Neighborhood Highlights',
                            hintText: 'Describe facing, sunlight, construction quality, distance from metro, and key landmarks',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Verification Status, Status & Switches
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _verificationStatus,
                                decoration: const InputDecoration(labelText: 'Platform Verification *'),
                                items: _verificationStatuses.map((v) {
                                  return DropdownMenuItem<String>(
                                    value: v,
                                    child: Text(v.replaceAll('_', ' ')),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _verificationStatus = val);
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _status,
                                decoration: const InputDecoration(labelText: 'Listing Status *'),
                                items: const [
                                  DropdownMenuItem(value: 'PUBLISHED', child: Text('PUBLISHED (Active on Store)')),
                                  DropdownMenuItem(value: 'DRAFT', child: Text('DRAFT (Hidden)')),
                                  DropdownMenuItem(value: 'ARCHIVED', child: Text('ARCHIVED / SOLD')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _status = val);
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TextFormField(
                                controller: _totalUnlocksCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Total Contact Unlocks',
                                  hintText: '0',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Row(
                          children: [
                            Switch(
                              value: _isNegotiable,
                              onChanged: (val) => setState(() => _isNegotiable = val),
                              activeThumbColor: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Price is Negotiable',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: AppSpacing.xl),
                            Switch(
                              value: _isFeatured,
                              onChanged: (val) => setState(() => _isFeatured = val),
                              activeThumbColor: const Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Featured Spotlight Property',
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
                                ? 'Update Property Listing'
                                : 'Create Property Listing',
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
