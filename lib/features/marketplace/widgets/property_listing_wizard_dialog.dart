import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_enums.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';

class PropertyListingWizardDialog extends StatefulWidget {
  final PropertyListingEntity? propertyToEdit;

  const PropertyListingWizardDialog({super.key, this.propertyToEdit});

  static Future<void> show(BuildContext context, {PropertyListingEntity? propertyToEdit}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PropertyListingWizardDialog(propertyToEdit: propertyToEdit),
    );
  }

  @override
  State<PropertyListingWizardDialog> createState() => _PropertyListingWizardDialogState();
}

class _PropertyListingWizardDialogState extends State<PropertyListingWizardDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _repo = MarketplaceRepository();
  late TabController _tabController;

  // Step 1: Listing Info
  late TextEditingController _titleCtrl;
  PropertyType _propertyType = PropertyType.penthouse;
  ListingIntent _intent = ListingIntent.rent;
  PropertyVerificationStatus _verificationStatus = PropertyVerificationStatus.verified;

  // Step 2: Specs
  late TextEditingController _bhkCtrl;
  late TextEditingController _bedroomsCtrl;
  late TextEditingController _bathroomsCtrl;
  late TextEditingController _carpetAreaCtrl;
  late TextEditingController _superAreaCtrl;
  late TextEditingController _floorCtrl;
  late TextEditingController _furnishingCtrl;
  late TextEditingController _parkingCtrl;

  // Step 3: Location
  late TextEditingController _addressCtrl;
  late TextEditingController _localityCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _pinCtrl;
  late TextEditingController _latCtrl;
  late TextEditingController _lngCtrl;
  bool _showExactLocation = false;

  // Step 4: Commercials
  late TextEditingController _rentCtrl;
  late TextEditingController _depositCtrl;
  late TextEditingController _maintCtrl;

  // Step 5: Description
  late TextEditingController _shortDescCtrl;
  late TextEditingController _fullDescCtrl;
  late TextEditingController _archHighlightCtrl;
  late TextEditingController _interiorHighlightCtrl;

  // Step 6: Media
  late TextEditingController _coverImageCtrl;
  late TextEditingController _videoUrlCtrl;

  // Step 7: Protected Owner
  late TextEditingController _ownerNameCtrl;
  late TextEditingController _ownerPhoneCtrl;
  late TextEditingController _ownerEmailCtrl;
  late TextEditingController _ownerTypeCtrl;
  late TextEditingController _ownerKycCtrl;
  late TextEditingController _internalNotesCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    final p = widget.propertyToEdit;

    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _propertyType = p?.propertyType ?? PropertyType.penthouse;
    _intent = p?.intent ?? ListingIntent.rent;
    _verificationStatus = p?.verificationStatus ?? PropertyVerificationStatus.verified;

    _bhkCtrl = TextEditingController(text: p?.bhk ?? '4 BHK Duplex Penthouse');
    _bedroomsCtrl = TextEditingController(text: p?.bedrooms.toString() ?? '4');
    _bathroomsCtrl = TextEditingController(text: p?.bathrooms.toString() ?? '5');
    _carpetAreaCtrl = TextEditingController(text: p?.carpetAreaSqft.toString() ?? '3850');
    _superAreaCtrl = TextEditingController(text: p?.superBuiltUpSqft.toString() ?? '4900');
    _floorCtrl = TextEditingController(text: p?.floorNumber.toString() ?? '32');
    _furnishingCtrl = TextEditingController(text: p?.furnishingStatus ?? 'Fully Designer Furnished');
    _parkingCtrl = TextEditingController(text: p?.coveredParkingSlots.toString() ?? '3');

    _addressCtrl = TextEditingController(text: p?.addressLine1 ?? 'Tower Alpha, Skycrest Residences');
    _localityCtrl = TextEditingController(text: p?.locality ?? 'Bellandur / Outer Ring Road');
    _cityCtrl = TextEditingController(text: p?.city ?? 'Bangalore');
    _pinCtrl = TextEditingController(text: p?.pinCode ?? '560103');
    _latCtrl = TextEditingController(text: p?.latitude.toString() ?? '12.9260');
    _lngCtrl = TextEditingController(text: p?.longitude.toString() ?? '77.6762');
    _showExactLocation = p?.showExactLocationPublicly ?? false;

    _rentCtrl = TextEditingController(text: p?.monthlyRent.toString() ?? '240000.0');
    _depositCtrl = TextEditingController(text: p?.securityDeposit.toString() ?? '1440000.0');
    _maintCtrl = TextEditingController(text: p?.maintenanceMonthly.toString() ?? '18500.0');

    _shortDescCtrl = TextEditingController(text: p?.shortDescription ?? '');
    _fullDescCtrl = TextEditingController(text: p?.fullDescription ?? '');
    _archHighlightCtrl = TextEditingController(text: p?.architecturalHighlight ?? 'Double-height 22ft living room ceiling with Low-E glass');
    _interiorHighlightCtrl = TextEditingController(text: p?.interiorHighlights ?? 'Botticino Classico Italian Marble flooring');

    _coverImageCtrl = TextEditingController(text: p?.coverImageUrl ?? 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600');
    _videoUrlCtrl = TextEditingController(text: p?.walkthroughVideoUrl ?? 'https://cdn.homio.in/videos/prop-tour.mp4');

    _ownerNameCtrl = TextEditingController(text: p?.ownerName ?? 'Vikramaditya Singhania');
    _ownerPhoneCtrl = TextEditingController(text: p?.ownerMobileReal ?? '+91 98450 44891');
    _ownerEmailCtrl = TextEditingController(text: p?.ownerEmail ?? 'vikram.singhania@vsinvestments.in');
    _ownerTypeCtrl = TextEditingController(text: p?.ownerType ?? 'Individual NRI Investor');
    _ownerKycCtrl = TextEditingController(text: p?.ownerKycStatus ?? 'Aadhaar Verified & Title Deed Registered');
    _internalNotesCtrl = TextEditingController(text: p?.internalAdminNotes ?? 'Owner stationed in Singapore. Immediate unlock approved.');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _bhkCtrl.dispose();
    _bedroomsCtrl.dispose();
    _bathroomsCtrl.dispose();
    _carpetAreaCtrl.dispose();
    _superAreaCtrl.dispose();
    _floorCtrl.dispose();
    _furnishingCtrl.dispose();
    _parkingCtrl.dispose();
    _addressCtrl.dispose();
    _localityCtrl.dispose();
    _cityCtrl.dispose();
    _pinCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _rentCtrl.dispose();
    _depositCtrl.dispose();
    _maintCtrl.dispose();
    _shortDescCtrl.dispose();
    _fullDescCtrl.dispose();
    _archHighlightCtrl.dispose();
    _interiorHighlightCtrl.dispose();
    _coverImageCtrl.dispose();
    _videoUrlCtrl.dispose();
    _ownerNameCtrl.dispose();
    _ownerPhoneCtrl.dispose();
    _ownerEmailCtrl.dispose();
    _ownerTypeCtrl.dispose();
    _ownerKycCtrl.dispose();
    _internalNotesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete required fields marked with *')));
      return;
    }

    final masked = _ownerPhoneCtrl.text.trim().length > 7
        ? '${_ownerPhoneCtrl.text.trim().substring(0, 8)} •••••'
        : '+91 •••••';

    final prop = PropertyListingEntity(
      id: widget.propertyToEdit?.id ?? 'PROP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: _titleCtrl.text.trim(),
      propertyType: _propertyType,
      intent: _intent,
      verificationStatus: _verificationStatus,
      verifiedByAdmin: 'Operations Admin',
      bhk: _bhkCtrl.text.trim(),
      bedrooms: int.tryParse(_bedroomsCtrl.text) ?? 3,
      bathrooms: int.tryParse(_bathroomsCtrl.text) ?? 3,
      balconies: 2,
      carpetAreaSqft: int.tryParse(_carpetAreaCtrl.text) ?? 2000,
      superBuiltUpSqft: int.tryParse(_superAreaCtrl.text) ?? 2600,
      floorNumber: int.tryParse(_floorCtrl.text) ?? 1,
      totalFloors: 25,
      propertyAgeYears: 2,
      facingDirection: 'North-East',
      furnishingStatus: _furnishingCtrl.text.trim(),
      coveredParkingSlots: int.tryParse(_parkingCtrl.text) ?? 2,
      availableFrom: DateTime.now().add(const Duration(days: 15)),
      addressLine1: _addressCtrl.text.trim(),
      addressLine2: '',
      locality: _localityCtrl.text.trim(),
      landmark: 'Near Central Park',
      city: _cityCtrl.text.trim(),
      state: 'Karnataka',
      pinCode: _pinCtrl.text.trim(),
      latitude: double.tryParse(_latCtrl.text) ?? 12.9260,
      longitude: double.tryParse(_lngCtrl.text) ?? 77.6762,
      showExactLocationPublicly: _showExactLocation,
      monthlyRent: double.tryParse(_rentCtrl.text) ?? 150000.0,
      securityDeposit: double.tryParse(_depositCtrl.text) ?? 900000.0,
      maintenanceMonthly: double.tryParse(_maintCtrl.text) ?? 12000.0,
      priceValidUntil: DateTime.now().add(const Duration(days: 90)),
      amenities: ['Private Heated Plunge Pool', 'Direct Private High-Speed Elevator', 'Modular Kitchen', 'Clubhouse & Swimming Pool', '24/7 Security'],
      shortDescription: _shortDescCtrl.text.trim(),
      fullDescription: _fullDescCtrl.text.trim(),
      architecturalHighlight: _archHighlightCtrl.text.trim(),
      interiorHighlights: _interiorHighlightCtrl.text.trim(),
      neighbourhoodNotes: 'Located in prime tech corridor with top international schools nearby.',
      coverImageUrl: _coverImageCtrl.text.trim(),
      galleryImageUrls: [_coverImageCtrl.text.trim()],
      floorPlanUrls: [],
      walkthroughVideoUrl: _videoUrlCtrl.text.trim(),
      virtualTour3dUrl: '',
      ownerName: _ownerNameCtrl.text.trim(),
      ownerMobileMasked: masked,
      ownerMobileReal: _ownerPhoneCtrl.text.trim(),
      ownerEmail: _ownerEmailCtrl.text.trim(),
      ownerType: _ownerTypeCtrl.text.trim(),
      ownerKycStatus: _ownerKycCtrl.text.trim(),
      ownerPreferredContactTime: '10:00 AM to 6:00 PM',
      internalAdminNotes: _internalNotesCtrl.text.trim(),
      createdAt: widget.propertyToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.propertyToEdit != null) {
      _repo.updateProperty(prop);
    } else {
      _repo.addProperty(prop);
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Property "${prop.title}" successfully saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880, maxHeight: 720),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.villa_rounded, color: Color(0xFF10B981), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.propertyToEdit != null ? 'Edit Verified Property Listing' : 'Property Listing Wizard',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '8-Step Comprehensive Listing, GPS Mapping & Protected Owner Dossier',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
              ),

              // Tab Bar
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                indicatorColor: AppColors.primary,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: '1. Identity'),
                  Tab(text: '2. Specifications'),
                  Tab(text: '3. Location & GPS'),
                  Tab(text: '4. Commercials'),
                  Tab(text: '5. Descriptions'),
                  Tab(text: '6. Media'),
                  Tab(text: '7. Protected Owner'),
                ],
              ),

              // Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildIdentityTab(isDark),
                    _buildSpecsTab(isDark),
                    _buildLocationTab(isDark),
                    _buildCommercialsTab(isDark),
                    _buildDescriptionTab(isDark),
                    _buildMediaTab(isDark),
                    _buildProtectedOwnerTab(isDark),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontSize: 12.5))),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: Text(widget.propertyToEdit != null ? 'Update Listing' : 'Save & Publish Property', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentityTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Property Listing Title *'),
          TextFormField(
            controller: _titleCtrl,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: _inputDeco('e.g. The Sky Villa: 4 BHK Duplex Penthouse with Private Plunge Pool', isDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Property Structural Type'),
                    DropdownButtonFormField<PropertyType>(
                      initialValue: _propertyType,
                      decoration: _inputDeco('', isDark),
                      items: PropertyType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
                      onChanged: (v) => setState(() => _propertyType = v ?? _propertyType),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Listing Transaction Intent'),
                    DropdownButtonFormField<ListingIntent>(
                      initialValue: _intent,
                      decoration: _inputDeco('', isDark),
                      items: ListingIntent.values.map((i) => DropdownMenuItem(value: i, child: Text(i.label))).toList(),
                      onChanged: (v) => setState(() => _intent = v ?? _intent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Homio Verification Status'),
          DropdownButtonFormField<PropertyVerificationStatus>(
            initialValue: _verificationStatus,
            decoration: _inputDeco('', isDark),
            items: PropertyVerificationStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
            onChanged: (v) => setState(() => _verificationStatus = v ?? _verificationStatus),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _subInput('BHK Configuration *', _bhkCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Bedrooms', _bedroomsCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Bathrooms', _bathroomsCtrl, isDark, isNum: true)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Carpet Area (Sq.Ft) *', _carpetAreaCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Super Built-Up (Sq.Ft)', _superAreaCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Floor Level', _floorCtrl, isDark, isNum: true)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Furnishing Status', _furnishingCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Covered Parking Slots', _parkingCtrl, isDark, isNum: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subInput('Address Line 1 *', _addressCtrl, isDark),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Locality / Sub-market *', _localityCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('City *', _cityCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('PIN Code', _pinCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Latitude GPS', _latCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Longitude GPS', _lngCtrl, isDark, isNum: true)),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text('Publicly Show Exact Building Location', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: Text('When turned off, only approx locality radius is shown before paid unlock', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
            value: _showExactLocation,
            onChanged: (v) => setState(() => _showExactLocation = v),
          ),
        ],
      ),
    );
  }

  Widget _buildCommercialsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _subInput('Monthly Rent (₹) *', _rentCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Security Deposit (₹) *', _depositCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Monthly Maintenance (₹)', _maintCtrl, isDark, isNum: true)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: AppRadius.md,
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.vpn_key_rounded, color: Color(0xFF10B981)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '₹500 Paywall Rule Active: Owner phone number and direct identity remain masked from public visitors until the ₹500 verified unlock fee is processed.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF10B981), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Short Catchy Description'),
          TextFormField(controller: _shortDescCtrl, maxLines: 2, decoration: _inputDeco('Magnificent 32nd-floor double-height penthouse...', isDark)),
          const SizedBox(height: 12),
          _fieldLabel('Full Architectural Description'),
          TextFormField(controller: _fullDescCtrl, maxLines: 4, decoration: _inputDeco('Sprawled across 3,850 sq ft of carpet area, this penthouse features...', isDark)),
          const SizedBox(height: 12),
          _subInput('Architectural Highlights (Void, Facade, Cantilever)', _archHighlightCtrl, isDark),
          const SizedBox(height: 12),
          _subInput('Interior Highlights (Flooring, Sanware, Appliances)', _interiorHighlightCtrl, isDark),
        ],
      ),
    );
  }

  Widget _buildMediaTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subInput('High-Res Cover Image CDN URL *', _coverImageCtrl, isDark),
          const SizedBox(height: 12),
          _subInput('Walkthrough Video Tour URL (MP4 / YouTube)', _videoUrlCtrl, isDark),
        ],
      ),
    );
  }

  Widget _buildProtectedOwnerTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: AppRadius.sm,
              border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security_rounded, size: 16, color: Color(0xFFEF4444)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Protected Internal Dossier: Field-level RBAC protected. These owner contact details are strictly hidden from public APIs.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _subInput('Legal Owner Name *', _ownerNameCtrl, isDark),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Real Mobile Number *', _ownerPhoneCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Owner Email Address', _ownerEmailCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Owner Category', _ownerTypeCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Title Deed / KYC Status', _ownerKycCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          _subInput('Internal Confidential Notes', _internalNotesCtrl, isDark),
        ],
      ),
    );
  }

  Widget _subInput(String label, TextEditingController ctrl, bool isDark, {bool isNum = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        TextFormField(
          controller: ctrl,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          decoration: _inputDeco('', isDark),
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
    );
  }

  InputDecoration _inputDeco(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
      isDense: true,
      filled: true,
      fillColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
      border: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFCBD5E1))),
      enabledBorder: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFCBD5E1))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
