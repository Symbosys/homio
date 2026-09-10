import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_enums.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';

class DecorProductFormDialog extends StatefulWidget {
  final HomeDecorProductEntity? productToEdit;

  const DecorProductFormDialog({super.key, this.productToEdit});

  static Future<void> show(BuildContext context, {HomeDecorProductEntity? productToEdit}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DecorProductFormDialog(productToEdit: productToEdit),
    );
  }

  @override
  State<DecorProductFormDialog> createState() => _DecorProductFormDialogState();
}

class _DecorProductFormDialogState extends State<DecorProductFormDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _repo = MarketplaceRepository();
  late TabController _tabController;

  // Identity
  late TextEditingController _nameCtrl;
  late TextEditingController _skuCtrl;
  String _brand = 'West Elm Modern Furnishings';
  String _category = 'CAT-DECOR';
  late TextEditingController _collectionCtrl;
  late TextEditingController _typeCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _coverImageCtrl;

  // Specs
  late TextEditingController _materialCtrl;
  late TextEditingController _colourCtrl;
  late TextEditingController _finishCtrl;
  late TextEditingController _dimensionsCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _roomTypeCtrl;
  late TextEditingController _careCtrl;
  late TextEditingController _warrantyCtrl;

  // Commercials
  late TextEditingController _mrpCtrl;
  late TextEditingController _tradePriceCtrl;
  late TextEditingController _customerPriceCtrl;
  late TextEditingController _leadTimeCtrl;
  late TextEditingController _moqCtrl;

  // Affiliate
  bool _isAffiliateEnabled = true;
  AffiliatePartner _affiliatePartner = AffiliatePartner.westElm;
  late TextEditingController _externalUrlCtrl;
  late TextEditingController _trackingUrlCtrl;
  late TextEditingController _campaignCtrl;
  late TextEditingController _commissionRateCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final p = widget.productToEdit;

    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? 'HOM-FURN-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
    _brand = p?.brandName ?? 'West Elm Modern Furnishings';
    _category = p?.categoryId ?? 'CAT-DECOR';
    _collectionCtrl = TextEditingController(text: p?.collection ?? 'Autumn Milan Series');
    _typeCtrl = TextEditingController(text: p?.productType ?? 'Accent Seating');
    _descCtrl = TextEditingController(text: p?.shortDescription ?? '');
    _coverImageCtrl = TextEditingController(text: p?.coverImageUrl ?? 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=600');

    _materialCtrl = TextEditingController(text: p?.primaryMaterial ?? 'Italian Wool Boucle');
    _colourCtrl = TextEditingController(text: p?.colour ?? 'Ivory Cream');
    _finishCtrl = TextEditingController(text: p?.finish ?? 'Brushed Brass Swivel');
    _dimensionsCtrl = TextEditingController(text: p?.dimensions ?? '34"W x 32"D x 30"H');
    _weightCtrl = TextEditingController(text: p?.weight ?? '24.0 kg');
    _roomTypeCtrl = TextEditingController(text: p?.roomType ?? 'Living Room');
    _careCtrl = TextEditingController(text: p?.careInstructions ?? 'Dry clean fabric. Dust brass base.');
    _warrantyCtrl = TextEditingController(text: p?.warrantyPeriod ?? '5 Years Frame Warranty');

    _mrpCtrl = TextEditingController(text: p?.mrp.toString() ?? '48900.0');
    _tradePriceCtrl = TextEditingController(text: p?.tradePrice.toString() ?? '31200.0');
    _customerPriceCtrl = TextEditingController(text: p?.customerPrice.toString() ?? '38900.0');
    _leadTimeCtrl = TextEditingController(text: p?.leadTimeDays.toString() ?? '7');
    _moqCtrl = TextEditingController(text: p?.minOrderQuantity.toString() ?? '1');

    _isAffiliateEnabled = p?.isAffiliateEnabled ?? true;
    _affiliatePartner = p?.affiliatePartner ?? AffiliatePartner.westElm;
    _externalUrlCtrl = TextEditingController(text: p?.externalProductUrl ?? 'https://westelm.in');
    _trackingUrlCtrl = TextEditingController(text: p?.trackingUrl ?? 'https://westelm.in?utm_source=homio_crm');
    _campaignCtrl = TextEditingController(text: p?.campaignName ?? 'Homio Curated 2026');
    _commissionRateCtrl = TextEditingController(text: p?.commissionRate.toString() ?? '8.5');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _collectionCtrl.dispose();
    _typeCtrl.dispose();
    _descCtrl.dispose();
    _coverImageCtrl.dispose();
    _materialCtrl.dispose();
    _colourCtrl.dispose();
    _finishCtrl.dispose();
    _dimensionsCtrl.dispose();
    _weightCtrl.dispose();
    _roomTypeCtrl.dispose();
    _careCtrl.dispose();
    _warrantyCtrl.dispose();
    _mrpCtrl.dispose();
    _tradePriceCtrl.dispose();
    _customerPriceCtrl.dispose();
    _leadTimeCtrl.dispose();
    _moqCtrl.dispose();
    _externalUrlCtrl.dispose();
    _trackingUrlCtrl.dispose();
    _campaignCtrl.dispose();
    _commissionRateCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete required fields marked with *')));
      return;
    }

    final product = HomeDecorProductEntity(
      id: widget.productToEdit?.id ?? 'DEC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: _nameCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      brandName: _brand,
      categoryId: _category,
      categoryName: 'Luxury Furniture & Seating',
      subcategory: 'Living Room Sofas & Couches',
      collection: _collectionCtrl.text.trim(),
      productType: _typeCtrl.text.trim(),
      shortDescription: _descCtrl.text.trim(),
      fullDescription: _descCtrl.text.trim(),
      coverImageUrl: _coverImageCtrl.text.trim(),
      galleryUrls: [_coverImageCtrl.text.trim()],
      tags: ['Luxury', 'Decor', _brand],
      primaryMaterial: _materialCtrl.text.trim(),
      secondaryMaterial: 'Hardwood Timber',
      colour: _colourCtrl.text.trim(),
      finish: _finishCtrl.text.trim(),
      texture: 'Textured Weave',
      dimensions: _dimensionsCtrl.text.trim(),
      weight: _weightCtrl.text.trim(),
      roomType: _roomTypeCtrl.text.trim(),
      careInstructions: _careCtrl.text.trim(),
      warrantyPeriod: _warrantyCtrl.text.trim(),
      countryOfOrigin: 'India',
      mrp: double.tryParse(_mrpCtrl.text) ?? 45000.0,
      tradePrice: double.tryParse(_tradePriceCtrl.text) ?? 30000.0,
      customerPrice: double.tryParse(_customerPriceCtrl.text) ?? 38000.0,
      taxRate: 18.0,
      leadTimeDays: int.tryParse(_leadTimeCtrl.text) ?? 7,
      minOrderQuantity: int.tryParse(_moqCtrl.text) ?? 1,
      isAffiliateEnabled: _isAffiliateEnabled,
      affiliatePartner: _affiliatePartner,
      externalProductUrl: _externalUrlCtrl.text.trim(),
      trackingUrl: _trackingUrlCtrl.text.trim(),
      campaignName: _campaignCtrl.text.trim(),
      commissionType: CommissionType.percentage,
      commissionRate: double.tryParse(_commissionRateCtrl.text) ?? 8.5,
      createdAt: widget.productToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.productToEdit != null) {
      _repo.updateDecorProduct(product);
    } else {
      _repo.addDecorProduct(product);
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Home decor product "${product.name}" successfully saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 680),
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
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.chair_rounded, color: Color(0xFF8B5CF6), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productToEdit != null ? 'Edit Home Decor Item' : 'Add Curated Decor / Affiliate Product',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Specifications, Trade Pricing & Affiliate Partner Tracking',
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
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                indicatorColor: AppColors.primary,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: '1. Identity'),
                  Tab(text: '2. Specifications'),
                  Tab(text: '3. Pricing & Supply'),
                  Tab(text: '4. Affiliate Setup'),
                ],
              ),

              // Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildIdentityTab(isDark),
                    _buildSpecsTab(isDark),
                    _buildPricingTab(isDark),
                    _buildAffiliateTab(isDark),
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), foregroundColor: Colors.white),
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: Text(widget.productToEdit != null ? 'Update Product' : 'Save & Publish Decor Item', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
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
          _fieldLabel('Product Name *'),
          TextFormField(
            controller: _nameCtrl,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: _inputDeco('e.g. Verona Curved Boucle Lounge Accent Chair', isDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('SKU *'),
                    TextFormField(
                      controller: _skuCtrl,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      decoration: _inputDeco('HOM-FURN-01', isDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Brand Partner'),
                    DropdownButtonFormField<String>(
                      initialValue: _brand,
                      decoration: _inputDeco('', isDark),
                      items: _repo.brands.map((b) => DropdownMenuItem(value: b.name, child: Text(b.name, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (v) => setState(() => _brand = v ?? _brand),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Collection & Product Type'),
          Row(
            children: [
              Expanded(child: TextFormField(controller: _collectionCtrl, decoration: _inputDeco('Autumn Milan Series', isDark))),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: _typeCtrl, decoration: _inputDeco('Accent Armchair', isDark))),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Short Description'),
          TextFormField(
            controller: _descCtrl,
            maxLines: 3,
            decoration: _inputDeco('Organic sculptural silhouette upholstered in heavy-weight Italian cream boucle...', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Image URL'),
          TextFormField(
            controller: _coverImageCtrl,
            decoration: _inputDeco('https://images.unsplash.com/...', isDark),
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
              Expanded(child: _subInput('Primary Material', _materialCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Colour', _colourCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Finish', _finishCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Dimensions', _dimensionsCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Weight (kg)', _weightCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Room Category', _roomTypeCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          _subInput('Care Instructions', _careCtrl, isDark),
          const SizedBox(height: 12),
          _subInput('Warranty Terms', _warrantyCtrl, isDark),
        ],
      ),
    );
  }

  Widget _buildPricingTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _subInput('MRP (Retail) ₹ *', _mrpCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Trade Price ₹ (B2B)', _tradePriceCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Customer Price ₹ *', _customerPriceCtrl, isDark, isNum: true)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _subInput('Lead Time (Days)', _leadTimeCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('MOQ (Min Order Qty)', _moqCtrl, isDark, isNum: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAffiliateTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Affiliate Link & Click Tracking Active', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: Text('Redirects customer purchase button to external merchant via affiliate tag', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
            value: _isAffiliateEnabled,
            onChanged: (v) => setState(() => _isAffiliateEnabled = v),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Affiliate Merchant Partner'),
          DropdownButtonFormField<AffiliatePartner>(
            initialValue: _affiliatePartner,
            decoration: _inputDeco('', isDark),
            items: AffiliatePartner.values.map((p) => DropdownMenuItem(value: p, child: Text('${p.label} (${p.domain})'))).toList(),
            onChanged: (v) => setState(() => _affiliatePartner = v ?? AffiliatePartner.westElm),
          ),
          const SizedBox(height: 12),
          _subInput('Direct Merchant External URL', _externalUrlCtrl, isDark),
          const SizedBox(height: 12),
          _subInput('Affiliate Tagged Tracking URL', _trackingUrlCtrl, isDark),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Campaign Name', _campaignCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Estimated Commission (%)', _commissionRateCtrl, isDark, isNum: true)),
            ],
          ),
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
