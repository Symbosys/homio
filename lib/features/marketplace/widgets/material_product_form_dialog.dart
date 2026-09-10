import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_enums.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';

class MaterialProductFormDialog extends StatefulWidget {
  final MaterialProductEntity? materialToEdit;

  const MaterialProductFormDialog({super.key, this.materialToEdit});

  static Future<void> show(BuildContext context, {MaterialProductEntity? materialToEdit}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => MaterialProductFormDialog(materialToEdit: materialToEdit),
    );
  }

  @override
  State<MaterialProductFormDialog> createState() => _MaterialProductFormDialogState();
}

class _MaterialProductFormDialogState extends State<MaterialProductFormDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _repo = MarketplaceRepository();
  late TabController _tabController;

  late TextEditingController _nameCtrl;
  late TextEditingController _skuCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _brandCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _imageCtrl;

  late TextEditingController _typeCtrl;
  late TextEditingController _gradeCtrl;
  late TextEditingController _certCtrl;
  late TextEditingController _dimensionsCtrl;
  late TextEditingController _thicknessCtrl;
  late TextEditingController _finishCtrl;
  late TextEditingController _applicationCtrl;

  MaterialUnit _unit = MaterialUnit.perSheet;
  late TextEditingController _wholesalePriceCtrl;
  late TextEditingController _retailMrpCtrl;
  late TextEditingController _tradePriceCtrl;
  late TextEditingController _moqCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _leadTimeCtrl;
  late TextEditingController _zonesCtrl;

  // Supplier info
  late TextEditingController _supplierNameCtrl;
  late TextEditingController _supplierPriceCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final m = widget.materialToEdit;

    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _skuCtrl = TextEditingController(text: m?.sku ?? 'PLY-CEN-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
    _codeCtrl = TextEditingController(text: m?.materialCode ?? 'MAT-710-01');
    _brandCtrl = TextEditingController(text: m?.brandName ?? 'CenturyPly');
    _descCtrl = TextEditingController(text: m?.shortDescription ?? '');
    _imageCtrl = TextEditingController(text: m?.coverImageUrl ?? 'https://images.unsplash.com/photo-1541123437800-1bb1317badc2?w=600');

    _typeCtrl = TextEditingController(text: m?.materialType ?? 'BWP Marine Plywood');
    _gradeCtrl = TextEditingController(text: m?.grade ?? 'Club Prime IS:710');
    _certCtrl = TextEditingController(text: m?.isStandardCertification ?? 'IS:710 & E1 Certified');
    _dimensionsCtrl = TextEditingController(text: m?.dimensions ?? '8 x 4 feet (2440 x 1220 mm)');
    _thicknessCtrl = TextEditingController(text: m?.thickness ?? '18 mm');
    _finishCtrl = TextEditingController(text: m?.finish ?? 'Smooth Calibrated Sanded');
    _applicationCtrl = TextEditingController(text: m?.application ?? 'Kitchen Carcass & Wet Area Cabinetry');

    _unit = m?.unitOfMeasure ?? MaterialUnit.perSheet;
    _wholesalePriceCtrl = TextEditingController(text: m?.wholesalePrice.toString() ?? '2840.0');
    _retailMrpCtrl = TextEditingController(text: m?.retailMrp.toString() ?? '3650.0');
    _tradePriceCtrl = TextEditingController(text: m?.tradePrice.toString() ?? '2680.0');
    _moqCtrl = TextEditingController(text: m?.minOrderQuantity.toString() ?? '10');
    _stockCtrl = TextEditingController(text: m?.stockAvailableUnits.toString() ?? '350');
    _leadTimeCtrl = TextEditingController(text: m?.leadTimeDays.toString() ?? '2');
    _zonesCtrl = TextEditingController(text: m?.deliveryZones ?? 'Bangalore Metro, Delhi-NCR, Mumbai');

    _supplierNameCtrl = TextEditingController(text: m?.primarySupplier.vendorName ?? 'Karnataka Plywood Distributors Ltd.');
    _supplierPriceCtrl = TextEditingController(text: m?.primarySupplier.supplierPrice.toString() ?? '2620.0');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _codeCtrl.dispose();
    _brandCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    _typeCtrl.dispose();
    _gradeCtrl.dispose();
    _certCtrl.dispose();
    _dimensionsCtrl.dispose();
    _thicknessCtrl.dispose();
    _finishCtrl.dispose();
    _applicationCtrl.dispose();
    _wholesalePriceCtrl.dispose();
    _retailMrpCtrl.dispose();
    _tradePriceCtrl.dispose();
    _moqCtrl.dispose();
    _stockCtrl.dispose();
    _leadTimeCtrl.dispose();
    _zonesCtrl.dispose();
    _supplierNameCtrl.dispose();
    _supplierPriceCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete required fields marked with *')));
      return;
    }

    final supplier = SupplierAssociation(
      vendorId: widget.materialToEdit?.primarySupplier.vendorId ?? 'VND-001',
      vendorName: _supplierNameCtrl.text.trim(),
      vendorCode: 'VND-BLR-001',
      vendorRating: 4.85,
      region: 'Bangalore Hub',
      supplierPrice: double.tryParse(_supplierPriceCtrl.text) ?? 2600.0,
      leadTimeDays: int.tryParse(_leadTimeCtrl.text) ?? 2,
      minimumOrderQty: int.tryParse(_moqCtrl.text) ?? 10,
      isPreferred: true,
      isPrimary: true,
      lastUpdated: DateTime.now(),
    );

    final mat = MaterialProductEntity(
      id: widget.materialToEdit?.id ?? 'MAT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: _nameCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      materialCode: _codeCtrl.text.trim(),
      categoryId: 'CAT-PLYWOOD',
      categoryName: 'Fluted Panels & Veneers',
      subcategory: 'Marine Grade Calibrated Plywood',
      brandName: _brandCtrl.text.trim(),
      manufacturer: '${_brandCtrl.text.trim()} India',
      coverImageUrl: _imageCtrl.text.trim(),
      shortDescription: _descCtrl.text.trim(),
      fullDescription: _descCtrl.text.trim(),
      tags: ['Procurement', 'Wholesale', _brandCtrl.text.trim()],
      materialType: _typeCtrl.text.trim(),
      grade: _gradeCtrl.text.trim(),
      isStandardCertification: _certCtrl.text.trim(),
      dimensions: _dimensionsCtrl.text.trim(),
      thickness: _thicknessCtrl.text.trim(),
      finish: _finishCtrl.text.trim(),
      colour: 'Natural Wood Grain',
      application: _applicationCtrl.text.trim(),
      careInstructions: 'Store flat in dry conditions.',
      warrantyPeriod: '25 Years Manufacturer Warranty',
      countryOfOrigin: 'India',
      unitOfMeasure: _unit,
      wholesalePrice: double.tryParse(_wholesalePriceCtrl.text) ?? 2800.0,
      retailMrp: double.tryParse(_retailMrpCtrl.text) ?? 3600.0,
      tradePrice: double.tryParse(_tradePriceCtrl.text) ?? 2650.0,
      taxRate: 18.0,
      minOrderQuantity: int.tryParse(_moqCtrl.text) ?? 10,
      stockAvailableUnits: int.tryParse(_stockCtrl.text) ?? 200,
      leadTimeDays: int.tryParse(_leadTimeCtrl.text) ?? 2,
      deliveryZones: _zonesCtrl.text.trim(),
      primarySupplier: supplier,
      createdAt: widget.materialToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.materialToEdit != null) {
      _repo.updateMaterial(mat);
    } else {
      _repo.addMaterial(mat);
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Material item "${mat.name}" saved to procurement catalogue.')),
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
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.inventory_2_rounded, color: Color(0xFFF59E0B), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.materialToEdit != null ? 'Edit Wholesale Material Spec' : 'Add Procurement Material',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Technical Specs, Commercial Index & Authoritative Supplier Linking',
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
                  Tab(text: '1. Basic Info'),
                  Tab(text: '2. Technical Specs'),
                  Tab(text: '3. Commercials'),
                  Tab(text: '4. Supplier Link'),
                ],
              ),

              // Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBasicTab(isDark),
                    _buildTechTab(isDark),
                    _buildCommercialsTab(isDark),
                    _buildSupplierTab(isDark),
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), foregroundColor: Colors.white),
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: Text(widget.materialToEdit != null ? 'Update Material' : 'Save Material to Index', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
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

  Widget _buildBasicTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Material Trade Name *'),
          TextFormField(
            controller: _nameCtrl,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: _inputDeco('e.g. CenturyPly Club Prime 18mm BWP Marine Plywood', isDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('SKU *'),
                    TextFormField(controller: _skuCtrl, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null, decoration: _inputDeco('PLY-CEN-18', isDark)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Brand Name *'),
                    TextFormField(controller: _brandCtrl, decoration: _inputDeco('CenturyPly', isDark)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Brief Technical Summary'),
          TextFormField(controller: _descCtrl, maxLines: 3, decoration: _inputDeco('IS:710 boiling waterproof calibrated sheet...', isDark)),
          const SizedBox(height: 12),
          _fieldLabel('Cover Image CDN URL'),
          TextFormField(controller: _imageCtrl, decoration: _inputDeco('https://images.unsplash.com/...', isDark)),
        ],
      ),
    );
  }

  Widget _buildTechTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _subInput('Material Substrate Type', _typeCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Grade / Standard Code', _gradeCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Certification (IS / ISO)', _certCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Standard Dimensions', _dimensionsCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Thickness Specification', _thicknessCtrl, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Surface Finish', _finishCtrl, isDark)),
            ],
          ),
          const SizedBox(height: 12),
          _subInput('Recommended Application Zone', _applicationCtrl, isDark),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Unit of Measurement'),
                    DropdownButtonFormField<MaterialUnit>(
                      initialValue: _unit,
                      decoration: _inputDeco('', isDark),
                      items: MaterialUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.label))).toList(),
                      onChanged: (v) => setState(() => _unit = v ?? _unit),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Wholesale Price ₹ *', _wholesalePriceCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Retail MRP ₹ *', _retailMrpCtrl, isDark, isNum: true)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Trade B2B Price ₹', _tradePriceCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('MOQ (Min Order Qty)', _moqCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Current Warehouse Stock', _stockCtrl, isDark, isNum: true)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _subInput('Delivery Lead Time (Days)', _leadTimeCtrl, isDark, isNum: true)),
              const SizedBox(width: 12),
              Expanded(child: _subInput('Eligible Delivery Regions', _zonesCtrl, isDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: AppRadius.sm,
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.link_rounded, size: 18, color: Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Direct Supplier Association: Linked to registered Homio Vendor entities for purchase orders and fulfillment dispatch.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFF59E0B)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _subInput('Primary Authoritative Supplier Name *', _supplierNameCtrl, isDark),
          const SizedBox(height: 12),
          _subInput('Direct Supplier Acquisition Price ₹', _supplierPriceCtrl, isDark, isNum: true),
        ],
      ),
    );
  }

  Widget _subInput(String label, TextEditingController ctrl, bool isDark, {bool isNum = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        TextFormField(controller: ctrl, keyboardType: isNum ? TextInputType.number : TextInputType.text, decoration: _inputDeco('', isDark)),
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
