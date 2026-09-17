import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/platform_marketplace_category_model.dart';
import 'category_image_picker_field.dart';

class CreateEditCategoryDialog extends StatefulWidget {
  final PlatformMarketplaceCategoryModel? initialCategory;
  final List<PlatformMarketplaceCategoryModel> existingCategories;
  final Future<void> Function(
    Map<String, dynamic> data, {
    List<int>? imageBytes,
    String? imageFileName,
  }) onSubmit;

  const CreateEditCategoryDialog({
    super.key,
    this.initialCategory,
    this.existingCategories = const [],
    required this.onSubmit,
  });

  @override
  State<CreateEditCategoryDialog> createState() => _CreateEditCategoryDialogState();
}

class _CreateEditCategoryDialogState extends State<CreateEditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _iconCtrl;
  late final TextEditingController _sortCtrl;

  Uint8List? _selectedImageBytes;
  String? _selectedImageFileName;
  bool _imageRemoved = false;

  late String _selectedType;
  String? _selectedParentId;
  late bool _isActive;

  bool _isLoading = false;
  String? _error;

  static const List<Map<String, String>> _types = [
    {'value': 'DIGITAL_ASSET', 'label': 'Digital Assets (CAD, 3D, BIM)'},
    {'value': 'HOME_DECOR', 'label': 'Home Decor & Furniture'},
    {'value': 'PROPERTIES', 'label': 'Real Estate Properties'},
    {'value': 'MATERIALS', 'label': 'Wholesale Materials'},
    {'value': 'OTHER', 'label': 'Other Goods'},
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.initialCategory;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _codeCtrl = TextEditingController(text: c?.code ?? '');
    _slugCtrl = TextEditingController(text: c?.slug ?? '');
    _descCtrl = TextEditingController(text: c?.description ?? '');
    _iconCtrl = TextEditingController(text: c?.icon ?? '');
    _sortCtrl = TextEditingController(text: (c?.sortOrder ?? 0).toString());

    _selectedType = c?.marketplaceType ?? 'PROPERTIES';
    _selectedParentId = c?.parentId;
    _isActive = c?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _slugCtrl.dispose();
    _descCtrl.dispose();
    _iconCtrl.dispose();
    _sortCtrl.dispose();
    super.dispose();
  }

  void _onNameChanged(String val) {
    if (widget.initialCategory == null) {
      final slug = val.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      _slugCtrl.text = slug;

      final code = val
          .trim()
          .toUpperCase()
          .replaceAll(RegExp(r'[^A-Z0-9]+'), '_');
      if (code.length <= 16) {
        _codeCtrl.text = code;
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final payload = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'code': _codeCtrl.text.trim(),
        'slug': _slugCtrl.text.trim(),
        'marketplaceType': _selectedType,
        'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        'icon': _iconCtrl.text.trim().isEmpty ? null : _iconCtrl.text.trim(),
        if (_imageRemoved) 'imageUrl': null,
        'sortOrder': int.tryParse(_sortCtrl.text.trim()) ?? 0,
        'parentId': _selectedParentId,
        'isActive': _isActive,
      };

      await widget.onSubmit(
        payload,
        imageBytes: _selectedImageBytes,
        imageFileName: _selectedImageFileName,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.initialCategory != null;

    final potentialParents = widget.existingCategories
        .where((item) => item.id != widget.initialCategory?.id)
        .toList();

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.category_rounded,
                      color: Color(0xFF8B5CF6),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit Marketplace Category' : 'Create Master Category',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          isEdit
                              ? 'Modify category metadata across the platform'
                              : 'Define a new product or property vertical category',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 18),

              // Error alert banner
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Name
                      AppTextField(
                        controller: _nameCtrl,
                        label: 'Category Name',
                        hint: 'e.g. 3 BHK Luxury Apartments',
                        onChanged: _onNameChanged,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Category name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Code & Slug
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _codeCtrl,
                              label: 'Category Code',
                              hint: 'e.g. APT_3BHK',
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Code is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _slugCtrl,
                              label: 'URL Slug',
                              hint: 'e.g. 3-bhk-luxury-apartments',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Marketplace Vertical Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Marketplace Vertical',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedType,
                                isExpanded: true,
                                dropdownColor:
                                    isDark ? const Color(0xFF1E293B) : Colors.white,
                                items: _types.map((t) {
                                  return DropdownMenuItem<String>(
                                    value: t['value'],
                                    child: Text(
                                      t['label']!,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedType = val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Parent Category Dropdown
                      if (potentialParents.isNotEmpty) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Parent Category (Optional)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String?>(
                                  value: _selectedParentId,
                                  isExpanded: true,
                                  dropdownColor:
                                      isDark ? const Color(0xFF1E293B) : Colors.white,
                                  items: [
                                    DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text(
                                        'None (Top-Level Category)',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13.5,
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    ...potentialParents.map((cat) {
                                      return DropdownMenuItem<String?>(
                                        value: cat.id,
                                        child: Text(
                                          '${cat.name} (${cat.marketplaceType})',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                  onChanged: (val) {
                                    setState(() => _selectedParentId = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Description
                      AppTextField(
                        controller: _descCtrl,
                        label: 'Description (Optional)',
                        hint: 'Brief description of items under this vertical',
                      ),
                      const SizedBox(height: 14),

                      // Icon, ImageUrl, and SortOrder
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _iconCtrl,
                              label: 'Icon Code',
                              hint: 'e.g. apartment, chair',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _sortCtrl,
                              label: 'Sort Order',
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Category Banner / Image Picker
                      CategoryImagePickerField(
                        initialUrl: _imageRemoved ? null : widget.initialCategory?.imageUrl,
                        selectedBytes: _selectedImageBytes,
                        selectedFileName: _selectedImageFileName,
                        onImageSelected: (bytes, fileName) {
                          setState(() {
                            _selectedImageBytes = bytes;
                            _selectedImageFileName = fileName;
                            _imageRemoved = false;
                          });
                        },
                        onImageRemoved: () {
                          setState(() {
                            _selectedImageBytes = null;
                            _selectedImageFileName = null;
                            _imageRemoved = true;
                          });
                        },
                      ),
                      const SizedBox(height: 14),

                      // Active Switch
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Category Active on Platform',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        subtitle: Text(
                          'When disabled, items in this category will be hidden from the public catalog',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                        value: _isActive,
                        activeThumbColor: const Color(0xFF8B5CF6),
                        onChanged: (val) => setState(() => _isActive = val),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    text: isEdit ? 'Update Category' : 'Create Category',
                    isLoading: _isLoading,
                    onPressed: _handleSave,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
