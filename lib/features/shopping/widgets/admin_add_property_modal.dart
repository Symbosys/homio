import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';

/// Admin Modal to List & Publish a New Property in the CRM Directory
class AdminAddPropertyModal extends StatefulWidget {
  final PropertyListing? initialProperty; // Non-null if editing
  final VoidCallback onSuccess;

  const AdminAddPropertyModal({
    super.key,
    this.initialProperty,
    required this.onSuccess,
  });

  @override
  State<AdminAddPropertyModal> createState() => _AdminAddPropertyModalState();
}

class _AdminAddPropertyModalState extends State<AdminAddPropertyModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _societyCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _zoneCtrl;
  late TextEditingController _rentCtrl;
  late TextEditingController _depositCtrl;
  late TextEditingController _salePriceCtrl;
  late TextEditingController _superAreaCtrl;
  late TextEditingController _carpetAreaCtrl;
  late TextEditingController _floorInfoCtrl;
  late TextEditingController _ownerNameCtrl;
  late TextEditingController _ownerPhoneCtrl;
  late TextEditingController _ownerEmailCtrl;
  late TextEditingController _videoUrlCtrl;
  late TextEditingController _imageUrlCtrl;

  PropertyType _selectedType = PropertyType.luxuryApartment;
  ListingIntent _selectedIntent = ListingIntent.rent;
  ListingStatus _selectedStatus = ListingStatus.active;
  String _selectedFurnishing = 'Semi-Furnished';
  int _bedrooms = 3;
  int _bathrooms = 3;
  bool _isVerified = true;

  final List<String> _availableAmenities = [
    '24/7 Concierge & Security',
    'Private Elevator Access',
    '2 Covered Reserved Car Parking Slots',
    '100% Power Backup',
    'Olympic Swimming Pool & Clubhouse',
    'VRV/VRF Central Air Conditioning',
    'Imported Italian Marble Flooring',
    'Modular Kitchen with Bosch Appliances',
    'Private Terrace Deck',
    'EV Fast Charger in Garage',
  ];

  late Set<String> _selectedAmenities;
  late List<String> _imageUrls;

  bool get isEditing => widget.initialProperty != null;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProperty;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _societyCtrl = TextEditingController(text: p?.societyName ?? '');
    _addressCtrl = TextEditingController(text: p?.address ?? '');
    _cityCtrl = TextEditingController(text: p?.city ?? 'Gurugram');
    _zoneCtrl = TextEditingController(text: p?.zone ?? 'Golf Course Road');
    _rentCtrl = TextEditingController(text: p != null ? p.monthlyRent.toInt().toString() : '125000');
    _depositCtrl = TextEditingController(text: p != null ? p.securityDeposit.toInt().toString() : '250000');
    _salePriceCtrl = TextEditingController(text: p != null ? p.salePrice.toInt().toString() : '0');
    _superAreaCtrl = TextEditingController(text: p != null ? p.superAreaSqft.toString() : '2850');
    _carpetAreaCtrl = TextEditingController(text: p != null ? p.carpetAreaSqft.toString() : '2350');
    _floorInfoCtrl = TextEditingController(text: p?.floorInfo ?? '14th Floor of 32 Floors (East Facing)');
    _ownerNameCtrl = TextEditingController(text: p?.ownerName ?? 'Vikramaditya Singhania');
    _ownerPhoneCtrl = TextEditingController(text: p?.ownerRealPhone ?? '+91 98101 22849');
    _ownerEmailCtrl = TextEditingController(text: p?.ownerEmail ?? 'owner.contact@homiocrm.com');
    _videoUrlCtrl = TextEditingController(text: p?.walkthroughVideoUrl ?? 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
    _imageUrlCtrl = TextEditingController(
      text: p != null && p.images.isNotEmpty ? p.images.first : 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
    );

    if (p != null) {
      _selectedType = p.propertyType;
      _selectedIntent = p.intent;
      _selectedStatus = p.status;
      _selectedFurnishing = p.furnishing;
      _bedrooms = p.bedrooms;
      _bathrooms = p.bathrooms;
      _isVerified = p.isVerified;
      _selectedAmenities = Set.from(p.amenities);
      _imageUrls = List.from(p.images);
    } else {
      _selectedAmenities = {
        '24/7 Concierge & Security',
        'Private Elevator Access',
        '2 Covered Reserved Car Parking Slots',
        '100% Power Backup',
      };
      _imageUrls = [
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
        'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
      ];
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _societyCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _zoneCtrl.dispose();
    _rentCtrl.dispose();
    _depositCtrl.dispose();
    _salePriceCtrl.dispose();
    _superAreaCtrl.dispose();
    _carpetAreaCtrl.dispose();
    _floorInfoCtrl.dispose();
    _ownerNameCtrl.dispose();
    _ownerPhoneCtrl.dispose();
    _ownerEmailCtrl.dispose();
    _videoUrlCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  void _saveProperty() {
    if (!_formKey.currentState!.validate()) return;

    final phone = _ownerPhoneCtrl.text.trim();
    final maskedPhone = phone.length > 5 ? '${phone.substring(0, 6)}XXXXXX' : '+91 9810XXXXXX';

    final property = PropertyListing(
      id: widget.initialProperty?.id ?? 'PROP-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: _titleCtrl.text.trim(),
      propertyType: _selectedType,
      intent: _selectedIntent,
      monthlyRent: double.tryParse(_rentCtrl.text.trim()) ?? 0.0,
      securityDeposit: double.tryParse(_depositCtrl.text.trim()) ?? 0.0,
      salePrice: double.tryParse(_salePriceCtrl.text.trim()) ?? 0.0,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
      superAreaSqft: int.tryParse(_superAreaCtrl.text.trim()) ?? 2000,
      carpetAreaSqft: int.tryParse(_carpetAreaCtrl.text.trim()) ?? 1600,
      floorInfo: _floorInfoCtrl.text.trim(),
      furnishing: _selectedFurnishing,
      societyName: _societyCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      zone: _zoneCtrl.text.trim(),
      images: _imageUrls.isNotEmpty ? _imageUrls : [_imageUrlCtrl.text.trim()],
      walkthroughVideoUrl: _videoUrlCtrl.text.trim(),
      amenities: _selectedAmenities.toList(),
      isVerified: _isVerified,
      ownerName: _ownerNameCtrl.text.trim(),
      ownerMaskedPhone: maskedPhone,
      ownerRealPhone: phone,
      ownerEmail: _ownerEmailCtrl.text.trim(),
      isUnlocked: widget.initialProperty?.isUnlocked ?? false,
      dateListed: widget.initialProperty?.dateListed ?? DateTime.now(),
      status: _selectedStatus,
      totalUnlocks: widget.initialProperty?.totalUnlocks ?? 0,
      grossUnlockRevenue: widget.initialProperty?.grossUnlockRevenue ?? 0.0,
      leadInquiries: widget.initialProperty?.leadInquiries ?? 0,
    );

    if (isEditing) {
      ShoppingMockData.updateProperty(property);
    } else {
      ShoppingMockData.addProperty(property);
    }

    widget.onSuccess();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isEditing ? 'Property #${property.id} updated successfully!' : 'Property #${property.id} published to live catalog!',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textMuted = AppColors.getTextMuted(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 740,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(isEditing ? Icons.edit_note_rounded : Icons.add_home_work_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Property Listing (#${widget.initialProperty!.id})' : 'Admin: List New Luxury Property',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Configure pricing, direct owner credentials, 3D tour links, and listing lifecycle.',
                          style: TextStyle(fontSize: 12, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: textMuted),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Modal Body Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Basic Info
                      _buildSectionHeader('1. Property Details & Type', Icons.apartment_rounded),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _titleCtrl,
                        label: 'Property Title *',
                        hint: 'e.g. 4BHK Ultra-Luxury High-Rise Residence at The Camellias',
                        validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown<PropertyType>(
                              label: 'Property Structural Type',
                              value: _selectedType,
                              items: PropertyType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
                              onChanged: (val) => setState(() => _selectedType = val!),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildDropdown<ListingIntent>(
                              label: 'Transaction Intent',
                              value: _selectedIntent,
                              items: ListingIntent.values.map((i) => DropdownMenuItem(value: i, child: Text(i.label))).toList(),
                              onChanged: (val) => setState(() => _selectedIntent = val!),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildDropdown<ListingStatus>(
                              label: 'Listing Status',
                              value: _selectedStatus,
                              items: ListingStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
                              onChanged: (val) => setState(() => _selectedStatus = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Section 2: Pricing & Areas
                      _buildSectionHeader('2. Pricing & Spatial Configuration', Icons.currency_rupee_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _rentCtrl,
                              label: 'Monthly Rent (₹) *',
                              keyboardType: TextInputType.number,
                              hint: 'e.g. 150000',
                              validator: (v) => v == null || v.isEmpty ? 'Rent is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _depositCtrl,
                              label: 'Security Deposit (₹) *',
                              keyboardType: TextInputType.number,
                              hint: 'e.g. 300000',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _salePriceCtrl,
                              label: 'Resale Outright Price (₹, optional)',
                              keyboardType: TextInputType.number,
                              hint: '0 for rental only',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCounterField('Bedrooms (BHK)', _bedrooms, (v) => setState(() => _bedrooms = v)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildCounterField('Bathrooms', _bathrooms, (v) => setState(() => _bathrooms = v)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _superAreaCtrl,
                              label: 'Super Area (sq.ft)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _carpetAreaCtrl,
                              label: 'Carpet Area (sq.ft)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _floorInfoCtrl,
                              label: 'Floor & Direction Info',
                              hint: 'e.g. 14th Floor of 32 Floors (East Facing)',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildDropdown<String>(
                              label: 'Furnishing State',
                              value: _selectedFurnishing,
                              items: const [
                                DropdownMenuItem(value: 'Fully Furnished', child: Text('Fully Furnished')),
                                DropdownMenuItem(value: 'Semi-Furnished', child: Text('Semi-Furnished')),
                                DropdownMenuItem(value: 'Unfurnished', child: Text('Unfurnished')),
                                DropdownMenuItem(value: 'Luxury Designer Fitted', child: Text('Luxury Designer Fitted')),
                              ],
                              onChanged: (val) => setState(() => _selectedFurnishing = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Section 3: Location & Society
                      _buildSectionHeader('3. Society & Location Coordinates', Icons.location_on_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _societyCtrl,
                              label: 'Society / Project Name *',
                              hint: 'e.g. DLF The Camellias',
                              validator: (v) => v == null || v.isEmpty ? 'Society is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _zoneCtrl,
                              label: 'Locality / Zone *',
                              hint: 'e.g. Golf Course Road',
                              validator: (v) => v == null || v.isEmpty ? 'Zone is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _cityCtrl,
                              label: 'City *',
                              hint: 'e.g. Gurugram',
                              validator: (v) => v == null || v.isEmpty ? 'City is required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _addressCtrl,
                        label: 'Detailed Address',
                        hint: 'e.g. Tower 4, Unit 1402, Sector 42, Gurugram, Haryana - 122002',
                      ),
                      const SizedBox(height: 20),

                      // Section 4: Direct Owner Information
                      _buildSectionHeader('4. Direct Owner Credentials (Paywalled to Clients)', Icons.shield_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _ownerNameCtrl,
                              label: 'Owner Full Name *',
                              hint: 'e.g. Vikramaditya Singhania',
                              validator: (v) => v == null || v.isEmpty ? 'Owner name is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _ownerPhoneCtrl,
                              label: 'Real Contact Number *',
                              hint: 'e.g. +91 98101 22849',
                              validator: (v) => v == null || v.isEmpty ? 'Phone is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _ownerEmailCtrl,
                              label: 'Owner Email',
                              hint: 'e.g. vikram@singhania.com',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Direct Owner Title Deed Verified (100% Legitimacy Badge)'),
                        subtitle: const Text('Enables the Homio Verified Owner Badge on the client app'),
                        value: _isVerified,
                        activeThumbColor: const Color(0xFF10B981),
                        onChanged: (v) => setState(() => _isVerified = v),
                      ),
                      const SizedBox(height: 20),

                      // Section 5: Media & 3D Tour
                      _buildSectionHeader('5. Media Showcase & 3D Tour Link', Icons.video_collection_rounded),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _imageUrlCtrl,
                        label: 'Primary Cover Image URL',
                        hint: 'https://images.unsplash.com/...',
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _videoUrlCtrl,
                        label: '3D Virtual Walkthrough URL',
                        hint: 'e.g. https://www.youtube.com/watch?v=... or Matterport Link',
                      ),
                      const SizedBox(height: 20),

                      // Section 6: Amenities Checklist
                      _buildSectionHeader('6. Key Amenities & Facilities', Icons.checklist_rounded),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableAmenities.map((amenity) {
                          final isSelected = _selectedAmenities.contains(amenity);
                          return FilterChip(
                            label: Text(amenity, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : textPrimary)),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            checkmarkColor: Colors.white,
                            backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            side: BorderSide(color: isSelected ? AppColors.primary : borderColor),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAmenities.add(amenity);
                                } else {
                                  _selectedAmenities.remove(amenity);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🔒 All owner details are cryptographically encrypted on client paywall.',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _saveProperty,
                        icon: Icon(isEditing ? Icons.check_rounded : Icons.publish_rounded, size: 16),
                        label: Text(
                          isEditing ? 'Save Changes' : 'Publish Property',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.3),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.getBorder(context))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.getBorder(context))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      style: TextStyle(fontSize: 13, color: AppColors.getTextPrimary(context)),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.getBorder(context))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.getBorder(context))),
      ),
    );
  }

  Widget _buildCounterField(String label, int value, ValueChanged<int> onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.getBorder(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                icon: const Icon(Icons.remove, size: 16),
                onPressed: value > 1 ? () => onChanged(value - 1) : null,
              ),
              Text('$value', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                icon: const Icon(Icons.add, size: 16),
                onPressed: value < 10 ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
