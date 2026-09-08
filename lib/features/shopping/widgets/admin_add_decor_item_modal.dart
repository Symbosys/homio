import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';

/// Admin Modal to Add & Curate Affiliate Home Decor Products
class AdminAddDecorItemModal extends StatefulWidget {
  final DecorItem? initialItem;
  final VoidCallback onSuccess;

  const AdminAddDecorItemModal({
    super.key,
    this.initialItem,
    required this.onSuccess,
  });

  @override
  State<AdminAddDecorItemModal> createState() => _AdminAddDecorItemModalState();
}

class _AdminAddDecorItemModalState extends State<AdminAddDecorItemModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _brandCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _origPriceCtrl;
  late TextEditingController _commissionCtrl;
  late TextEditingController _affiliateUrlCtrl;
  late TextEditingController _imageUrlCtrl;
  late TextEditingController _leadTimeCtrl;
  late TextEditingController _materialCtrl;
  late TextEditingController _dimensionsCtrl;

  DecorCategory _selectedCategory = DecorCategory.furniture;
  String _selectedMerchant = 'Pepperfry';
  ListingStatus _selectedStatus = ListingStatus.active;
  bool _inStock = true;

  final List<String> _merchants = [
    'Pepperfry',
    'Urban Ladder',
    'Amazon Luxury',
    'West Elm',
    'IKEA',
    'Fabindia Home',
  ];

  bool get isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final d = widget.initialItem;
    _titleCtrl = TextEditingController(text: d?.title ?? '');
    _brandCtrl = TextEditingController(text: d?.brand ?? 'Urban Ladder');
    _priceCtrl = TextEditingController(text: d != null ? d.price.toInt().toString() : '28999');
    _origPriceCtrl = TextEditingController(text: d != null ? d.originalPrice.toInt().toString() : '39999');
    _commissionCtrl = TextEditingController(text: d != null ? d.commissionPercent.toString() : '12.5');
    _affiliateUrlCtrl = TextEditingController(
      text: d?.affiliateUrl ?? 'https://www.pepperfry.com/item/homio-affiliate?tag=homio-crm-21',
    );
    _imageUrlCtrl = TextEditingController(
      text: d?.imageUrl ?? 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600',
    );
    _leadTimeCtrl = TextEditingController(text: d != null ? d.leadTimeDays.toString() : '7');
    _materialCtrl = TextEditingController(text: d?.specifications['Material'] ?? 'Solid Sheesham Wood & Velvet');
    _dimensionsCtrl = TextEditingController(text: d?.specifications['Dimensions'] ?? '84" W x 36" D x 32" H');

    if (d != null) {
      _selectedCategory = d.category;
      _selectedMerchant = d.affiliatePartner;
      _selectedStatus = d.status;
      _inStock = d.inStock;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _brandCtrl.dispose();
    _priceCtrl.dispose();
    _origPriceCtrl.dispose();
    _commissionCtrl.dispose();
    _affiliateUrlCtrl.dispose();
    _imageUrlCtrl.dispose();
    _leadTimeCtrl.dispose();
    _materialCtrl.dispose();
    _dimensionsCtrl.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (!_formKey.currentState!.validate()) return;

    final item = DecorItem(
      id: widget.initialItem?.id ?? 'DEC-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: _titleCtrl.text.trim(),
      category: _selectedCategory,
      brand: _brandCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text.trim()) ?? 10000.0,
      originalPrice: double.tryParse(_origPriceCtrl.text.trim()) ?? 15000.0,
      rating: widget.initialItem?.rating ?? 4.8,
      reviewsCount: widget.initialItem?.reviewsCount ?? 24,
      imageUrl: _imageUrlCtrl.text.trim(),
      affiliatePartner: _selectedMerchant,
      affiliateUrl: _affiliateUrlCtrl.text.trim(),
      commissionPercent: double.tryParse(_commissionCtrl.text.trim()) ?? 10.0,
      inStock: _inStock,
      specifications: {
        'Material': _materialCtrl.text.trim(),
        'Dimensions': _dimensionsCtrl.text.trim(),
      },
      leadTimeDays: int.tryParse(_leadTimeCtrl.text.trim()) ?? 5,
      status: _selectedStatus,
      clickCount: widget.initialItem?.clickCount ?? 0,
      estimatedCommissionEarned: widget.initialItem?.estimatedCommissionEarned ?? 0.0,
      dateAdded: widget.initialItem?.dateAdded ?? DateTime.now(),
    );

    if (isEditing) {
      ShoppingMockData.updateDecorItem(item);
    } else {
      ShoppingMockData.addDecorItem(item);
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
                isEditing ? 'Decor Item #${item.id} updated!' : 'Curated Decor Item #${item.id} added to directory!',
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
        width: 700,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
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
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chair_rounded, color: Color(0xFFF59E0B), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Curated Decor Item (#${widget.initialItem!.id})' : 'Admin: Curate & Add Home Decor Item',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Configure partner affiliate link, merchant commission %, and catalog specs.',
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
                      _buildSectionHeader('1. Product & Brand Identity', Icons.style_rounded),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _titleCtrl,
                        label: 'Product Title *',
                        hint: 'e.g. Modern Scandinavian 3-Seater Velvet Sofa',
                        validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _brandCtrl,
                              label: 'Brand / Manufacturer *',
                              hint: 'e.g. West Elm / Urban Ladder',
                              validator: (v) => v == null || v.isEmpty ? 'Brand is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: DropdownButtonFormField<DecorCategory>(
                              initialValue: _selectedCategory,
                              items: DecorCategory.values
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedCategory = val!),
                              decoration: InputDecoration(
                                labelText: 'Decor Category',
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

                      _buildSectionHeader('2. Affiliate Link & Commission Setup', Icons.link_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedMerchant,
                              items: _merchants
                                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedMerchant = val!),
                              decoration: InputDecoration(
                                labelText: 'Partner Merchant',
                                filled: true,
                                fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _commissionCtrl,
                              label: 'Homio Commission (%) *',
                              keyboardType: TextInputType.number,
                              hint: 'e.g. 12.5',
                              validator: (v) => v == null || v.isEmpty ? 'Commission is required' : null,
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
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _affiliateUrlCtrl,
                        label: 'Affiliate Outbound URL (with UTM tag) *',
                        hint: 'https://...',
                        validator: (v) => v == null || v.isEmpty ? 'Affiliate URL is required' : null,
                      ),
                      const SizedBox(height: 20),

                      _buildSectionHeader('3. Pricing & Logistics', Icons.currency_rupee_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _priceCtrl,
                              label: 'Discounted Price (₹) *',
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty ? 'Price is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _origPriceCtrl,
                              label: 'MSRP Original Price (₹) *',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _leadTimeCtrl,
                              label: 'Estimated Delivery (Days)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _materialCtrl,
                              label: 'Material / Texture',
                              hint: 'e.g. Solid Sheesham Wood & Velvet',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _dimensionsCtrl,
                              label: 'Dimensions',
                              hint: 'e.g. 84" W x 36" D x 32" H',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _imageUrlCtrl,
                        label: 'Product High-Res Image URL *',
                        hint: 'https://images.unsplash.com/...',
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
                    'Affiliate click-through revenue will be automatically tracked in analytics.',
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
                        onPressed: _saveItem,
                        icon: Icon(isEditing ? Icons.check_rounded : Icons.add_rounded, size: 16),
                        label: Text(isEditing ? 'Save Changes' : 'Add Decor Item'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
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
        Icon(icon, size: 16, color: const Color(0xFFF59E0B)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 1.5)),
      ),
    );
  }
}
