import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';
import '../models/shopping_mock_data.dart';

/// Admin Modal to Upload, Price, and Publish Digital Architectural Assets & Guides
class AdminAddDigitalProductModal extends StatefulWidget {
  final DigitalProduct? initialProduct;
  final VoidCallback onSuccess;

  const AdminAddDigitalProductModal({
    super.key,
    this.initialProduct,
    required this.onSuccess,
  });

  @override
  State<AdminAddDigitalProductModal> createState() => _AdminAddDigitalProductModalState();
}

class _AdminAddDigitalProductModalState extends State<AdminAddDigitalProductModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _subtitleCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _origPriceCtrl;
  late TextEditingController _authorNameCtrl;
  late TextEditingController _authorTitleCtrl;
  late TextEditingController _pageCountCtrl;
  late TextEditingController _fileSizeCtrl;
  late TextEditingController _coverUrlCtrl;
  late TextEditingController _downloadUrlCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _chaptersCtrl;
  late TextEditingController _tagsCtrl;

  GuideCategory _selectedCategory = GuideCategory.vastu;
  ListingStatus _selectedStatus = ListingStatus.active;

  bool get isEditing => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProduct;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _subtitleCtrl = TextEditingController(text: p?.subtitle ?? '');
    _priceCtrl = TextEditingController(text: p != null ? p.price.toInt().toString() : '499');
    _origPriceCtrl = TextEditingController(text: p != null ? p.originalPrice.toInt().toString() : '1499');
    _authorNameCtrl = TextEditingController(text: p?.authorName ?? 'Acharya Vidyadhar Joshi');
    _authorTitleCtrl = TextEditingController(text: p?.authorTitle ?? 'Senior Architectural Consultant');
    _pageCountCtrl = TextEditingController(text: p != null ? p.pageCount.toString() : '180');
    _fileSizeCtrl = TextEditingController(text: p?.fileSize ?? '28.5 MB (High-Res CAD/PDF)');
    _coverUrlCtrl = TextEditingController(
      text: p?.coverImageUrl ?? 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600',
    );
    _downloadUrlCtrl = TextEditingController(
      text: p?.downloadUrl ?? 'https://cdn.homiocrm.com/assets/homio-master-blueprint.pdf',
    );
    _descriptionCtrl = TextEditingController(
      text: p?.description ?? 'Complete comprehensive blueprint and architectural reference guide.',
    );
    _chaptersCtrl = TextEditingController(
      text: p != null ? p.chapters.join('\n') : 'Chapter 1: Vedic Spatial Geometry\nChapter 2: Entrance & Foyer Vastu\nChapter 3: Modular Kitchen Planning',
    );
    _tagsCtrl = TextEditingController(text: p != null ? p.tags.join(', ') : 'Vastu, CAD, Blueprint, Architecture');

    if (p != null) {
      _selectedCategory = p.category;
      _selectedStatus = p.status;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _priceCtrl.dispose();
    _origPriceCtrl.dispose();
    _authorNameCtrl.dispose();
    _authorTitleCtrl.dispose();
    _pageCountCtrl.dispose();
    _fileSizeCtrl.dispose();
    _coverUrlCtrl.dispose();
    _downloadUrlCtrl.dispose();
    _descriptionCtrl.dispose();
    _chaptersCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    final chapters = _chaptersCtrl.text.split('\n').where((s) => s.trim().isNotEmpty).toList();
    final tags = _tagsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    final product = DigitalProduct(
      id: widget.initialProduct?.id ?? 'DP-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: _titleCtrl.text.trim(),
      subtitle: _subtitleCtrl.text.trim(),
      category: _selectedCategory,
      price: double.tryParse(_priceCtrl.text.trim()) ?? 499.0,
      originalPrice: double.tryParse(_origPriceCtrl.text.trim()) ?? 1499.0,
      rating: widget.initialProduct?.rating ?? 5.0,
      reviewsCount: widget.initialProduct?.reviewsCount ?? 0,
      pageCount: int.tryParse(_pageCountCtrl.text.trim()) ?? 150,
      fileSize: _fileSizeCtrl.text.trim(),
      coverImageUrl: _coverUrlCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      chapters: chapters.isNotEmpty ? chapters : ['Overview & Introduction'],
      sampleSnippets: widget.initialProduct?.sampleSnippets ?? ['Professional grade asset with lifetime updates.'],
      authorName: _authorNameCtrl.text.trim(),
      authorTitle: _authorTitleCtrl.text.trim(),
      downloadsCount: widget.initialProduct?.downloadsCount ?? 0,
      downloadUrl: _downloadUrlCtrl.text.trim(),
      tags: tags,
      isPurchased: widget.initialProduct?.isPurchased ?? false,
      status: _selectedStatus,
      totalSalesCount: widget.initialProduct?.totalSalesCount ?? 0,
      grossRevenue: widget.initialProduct?.grossRevenue ?? 0.0,
      dateAdded: widget.initialProduct?.dateAdded ?? DateTime.now(),
    );

    if (isEditing) {
      ShoppingMockData.updateDigitalProduct(product);
    } else {
      ShoppingMockData.addDigitalProduct(product);
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
                isEditing ? 'Digital Asset #${product.id} updated successfully!' : 'Digital Asset #${product.id} published to live catalog!',
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
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(isEditing ? Icons.edit_document : Icons.menu_book_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Digital Asset (#${widget.initialProduct!.id})' : 'Admin: Publish Digital Asset / Handbook',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Upload architectural guides, CAD models, Vastu playbooks, and set retail prices.',
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

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic info
                      _buildSectionHeader('1. Asset Identity & Category', Icons.category_rounded),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _titleCtrl,
                        label: 'Handbook / Product Title *',
                        hint: 'e.g. Vastu Shastra Comprehensive Master Blueprints',
                        validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _subtitleCtrl,
                        label: 'Subtitle / Tagline *',
                        hint: 'e.g. Complete directional layout blueprints and energy zones',
                        validator: (v) => v == null || v.isEmpty ? 'Subtitle is required' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<GuideCategory>(
                              initialValue: _selectedCategory,
                              items: GuideCategory.values
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

                      // Pricing & Specs
                      _buildSectionHeader('2. Pricing & File Specifications', Icons.currency_rupee_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _priceCtrl,
                              label: 'Offer Price (₹) *',
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty ? 'Price is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _origPriceCtrl,
                              label: 'Original MRP (₹) *',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _pageCountCtrl,
                              label: 'Page / Sheet Count',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _fileSizeCtrl,
                              label: 'File Format & Size',
                              hint: 'e.g. 35 MB High-Res PDF',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Author details
                      _buildSectionHeader('3. Author & Credentials', Icons.person_pin_rounded),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _authorNameCtrl,
                              label: 'Author Name *',
                              validator: (v) => v == null || v.isEmpty ? 'Author name is required' : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _authorTitleCtrl,
                              label: 'Author Designation / Credentials',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Download link & Cover
                      _buildSectionHeader('4. Digital Asset Links & Cover', Icons.cloud_download_rounded),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _downloadUrlCtrl,
                        label: 'Master Asset Download URL (Protected) *',
                        hint: 'https://cdn.homiocrm.com/assets/...',
                        validator: (v) => v == null || v.isEmpty ? 'Asset URL is required' : null,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _coverUrlCtrl,
                        label: 'Cover Image URL',
                        hint: 'https://images.unsplash.com/...',
                      ),
                      const SizedBox(height: 20),

                      // Content details
                      _buildSectionHeader('5. Description & Table of Contents', Icons.menu_book_outlined),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _descriptionCtrl,
                        label: 'Detailed Product Description',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _chaptersCtrl,
                        label: 'Table of Contents / Chapters (One per line)',
                        maxLines: 4,
                        hint: 'Chapter 1: Intro\nChapter 2: Layouts\nChapter 3: Blueprints',
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _tagsCtrl,
                        label: 'Search Tags (Comma separated)',
                        hint: 'Vastu, Architecture, Interior, Blueprints',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
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
                    'Downloads are delivered via encrypted single-use tokens.',
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
                        onPressed: _saveProduct,
                        icon: Icon(isEditing ? Icons.check_rounded : Icons.publish_rounded, size: 16),
                        label: Text(isEditing ? 'Save Changes' : 'Publish Asset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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
        Icon(icon, size: 16, color: AppColors.primary),
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }
}
