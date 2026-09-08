import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';

/// Admin Modal to Add & Manage Wholesale Raw Materials & Live Price Indexes
class AdminAddMaterialModal extends StatefulWidget {
  final MaterialItem? initialMaterial;
  final VoidCallback onSuccess;

  const AdminAddMaterialModal({
    super.key,
    this.initialMaterial,
    required this.onSuccess,
  });

  @override
  State<AdminAddMaterialModal> createState() => _AdminAddMaterialModalState();
}

class _AdminAddMaterialModalState extends State<AdminAddMaterialModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _brandCtrl;
  late TextEditingController _wholesaleCtrl;
  late TextEditingController _retailCtrl;
  late TextEditingController _tradeUnitCtrl;
  late TextEditingController _moqCtrl;
  late TextEditingController _deliveryDaysCtrl;
  late TextEditingController _stockAvailableCtrl;
  late TextEditingController _supplierNameCtrl;
  late TextEditingController _supplierCityCtrl;
  late TextEditingController _specSheetUrlCtrl;
  late TextEditingController _imageUrlCtrl;
  late TextEditingController _keyFeaturesCtrl;

  MaterialCategory _selectedCategory = MaterialCategory.plywoodBoards;
  ListingStatus _selectedStatus = ListingStatus.active;

  bool get isEditing => widget.initialMaterial != null;

  @override
  void initState() {
    super.initState();
    final m = widget.initialMaterial;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _brandCtrl = TextEditingController(text: m?.brand ?? 'CenturyPly');
    _wholesaleCtrl = TextEditingController(text: m != null ? m.wholesalePrice.toInt().toString() : '4250');
    _retailCtrl = TextEditingController(text: m != null ? m.retailMrp.toInt().toString() : '5600');
    _tradeUnitCtrl = TextEditingController(text: m?.tradeUnit ?? 'Per 8x4 Sheet (32 Sq.Ft)');
    _moqCtrl = TextEditingController(text: m != null ? m.minOrderQuantity.toString() : '15');
    _deliveryDaysCtrl = TextEditingController(text: m != null ? m.deliveryDays.toString() : '1');
    _stockAvailableCtrl = TextEditingController(text: m?.stockAvailable ?? '450 Sheets in Gurugram Depot');
    _supplierNameCtrl = TextEditingController(text: m?.supplierName ?? 'Gupta Timber & Plywood Hub');
    _supplierCityCtrl = TextEditingController(text: m?.supplierCity ?? 'Sector 37, Gurugram');
    _specSheetUrlCtrl = TextEditingController(text: m?.specSheetUrl ?? 'https://cdn.homiocrm.com/specs/material-spec.pdf');
    _imageUrlCtrl = TextEditingController(
      text: m?.imageUrl ?? 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=600',
    );
    _keyFeaturesCtrl = TextEditingController(
      text: m != null
          ? m.keyFeatures.join('\n')
          : 'IS:710 Marine Grade with 25-Year Warranty\n4-Times Calibrated Core for CNC Accuracy\nViroKill Nano-Technology Antimicrobial Surface',
    );

    if (m != null) {
      _selectedCategory = m.category;
      _selectedStatus = m.status;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _wholesaleCtrl.dispose();
    _retailCtrl.dispose();
    _tradeUnitCtrl.dispose();
    _moqCtrl.dispose();
    _deliveryDaysCtrl.dispose();
    _stockAvailableCtrl.dispose();
    _supplierNameCtrl.dispose();
    _supplierCityCtrl.dispose();
    _specSheetUrlCtrl.dispose();
    _imageUrlCtrl.dispose();
    _keyFeaturesCtrl.dispose();
    super.dispose();
  }

  void _saveMaterial() {
    if (!_formKey.currentState!.validate()) return;

    final wholesale = double.tryParse(_wholesaleCtrl.text.trim()) ?? 1000.0;
    final retail = double.tryParse(_retailCtrl.text.trim()) ?? 1400.0;
    final features = _keyFeaturesCtrl.text.split('\n').where((s) => s.trim().isNotEmpty).toList();

    final material = MaterialItem(
      id: widget.initialMaterial?.id ?? 'MAT-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: _nameCtrl.text.trim(),
      brand: _brandCtrl.text.trim(),
      category: _selectedCategory,
      tradeUnit: _tradeUnitCtrl.text.trim(),
      wholesalePrice: wholesale,
      retailMrp: retail,
      minOrderQuantity: int.tryParse(_moqCtrl.text.trim()) ?? 10,
      stockAvailable: _stockAvailableCtrl.text.trim(),
      specSheetUrl: _specSheetUrlCtrl.text.trim(),
      supplierName: _supplierNameCtrl.text.trim(),
      supplierCity: _supplierCityCtrl.text.trim(),
      deliveryDays: int.tryParse(_deliveryDaysCtrl.text.trim()) ?? 2,
      rating: widget.initialMaterial?.rating ?? 4.9,
      imageUrl: _imageUrlCtrl.text.trim(),
      keyFeatures: features.isNotEmpty ? features : ['Certified Wholesale B2B Material'],
      status: _selectedStatus,
      lastPriceUpdated: DateTime.now(),
    );

    if (isEditing) {
      ShoppingMockData.updateMaterial(material);
    } else {
      ShoppingMockData.addMaterial(material);
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
                isEditing ? 'Material #${material.id} pricing updated!' : 'Material #${material.id} added to live price index!',
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
        width: 720,
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
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.inventory_2_rounded, color: Color(0xFF3B82F6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Update Material Rate Index (#${widget.initialMaterial!.id})' : 'Admin: Add Wholesale Material to Price Index',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Configure wholesale B2B baseline rate, retail MRP, MOQ, and warehouse city.',
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

            // Modal Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('1. Material Identification', Icons.category_outlined),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _nameCtrl,
                        label: 'Material Name / Grade *',
                        hint: 'e.g. Century Club Prime Calibrated Marine Plywood (19mm)',
                        validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _brandCtrl,
                              label: 'Brand / Manufacturer *',
                              hint: 'e.g. CenturyPly / Kajaria',
                              validator: (v) => v == null || v.isEmpty ? 'Brand is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: DropdownButtonFormField<MaterialCategory>(
                              initialValue: _selectedCategory,
                              items: MaterialCategory.values
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedCategory = val!),
                              decoration: InputDecoration(
                                labelText: 'Category',
                                filled: true,
                                fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: DropdownButtonFormField<ListingStatus>(
                              initialValue: _selectedStatus,
                              items: ListingStatus.values
                                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedStatus = val!),
                              decoration: InputDecoration(
                                labelText: 'Status',
                                filled: true,
                                fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _buildSectionHeader('2. Pricing & Wholesale Economics', Icons.currency_rupee_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _wholesaleCtrl,
                              label: 'Wholesale B2B Rate (₹) *',
                              keyboardType: TextInputType.number,
                              hint: 'e.g. 4250',
                              validator: (v) => v == null || v.isEmpty ? 'Wholesale rate is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _retailCtrl,
                              label: 'Retail Market MRP (₹) *',
                              keyboardType: TextInputType.number,
                              hint: 'e.g. 5600',
                              validator: (v) => v == null || v.isEmpty ? 'Retail MRP is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _tradeUnitCtrl,
                              label: 'Trade Unit *',
                              hint: 'e.g. Per 8x4 Sheet (32 Sq.Ft)',
                              validator: (v) => v == null || v.isEmpty ? 'Trade unit is required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _moqCtrl,
                              label: 'Minimum Order Qty (MOQ)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _deliveryDaysCtrl,
                              label: 'Delivery Lead Time (Days)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _stockAvailableCtrl,
                              label: 'Stock Availability String',
                              hint: 'e.g. 450 Sheets in Gurugram Depot',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _buildSectionHeader('3. Supplier & Depot Coordinates', Icons.storefront_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _supplierNameCtrl,
                              label: 'Authorized Distributor / Supplier Name',
                              hint: 'e.g. Gupta Timber & Plywood Hub',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _supplierCityCtrl,
                              label: 'Depot City / Area',
                              hint: 'e.g. Sector 37, Gurugram',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _buildSectionHeader('4. Technical Features & Media', Icons.verified_outlined),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _imageUrlCtrl,
                        label: 'Material Catalog Image URL',
                        hint: 'https://images.unsplash.com/...',
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _specSheetUrlCtrl,
                        label: 'IS Standard Technical Spec Sheet PDF URL',
                        hint: 'https://cdn.homiocrm.com/specs/...',
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _keyFeaturesCtrl,
                        label: 'Key Technical Features / Specifications (One per line)',
                        maxLines: 4,
                        hint: 'Feature 1\nFeature 2\nFeature 3',
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
                    'Price benchmark updates trigger live contractor procurement calculations.',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _saveMaterial,
                        icon: Icon(isEditing ? Icons.check_rounded : Icons.add_rounded, size: 16),
                        label: Text(isEditing ? 'Save Price Index' : 'Add to Price Index'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
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
        Icon(icon, size: 16, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
      ),
    );
  }
}
