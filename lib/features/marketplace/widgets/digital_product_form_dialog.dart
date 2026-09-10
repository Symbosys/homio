import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_enums.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';

class DigitalProductFormDialog extends StatefulWidget {
  final DigitalProductEntity? productToEdit;

  const DigitalProductFormDialog({super.key, this.productToEdit});

  static Future<void> show(BuildContext context, {DigitalProductEntity? productToEdit}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DigitalProductFormDialog(productToEdit: productToEdit),
    );
  }

  @override
  State<DigitalProductFormDialog> createState() => _DigitalProductFormDialogState();
}

class _DigitalProductFormDialogState extends State<DigitalProductFormDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _repo = MarketplaceRepository();
  late TabController _tabController;

  // Section A: Product Identity
  late TextEditingController _nameCtrl;
  late TextEditingController _skuCtrl;
  late TextEditingController _productCodeCtrl;
  late TextEditingController _shortTitleCtrl;
  late TextEditingController _subtitleCtrl;
  late TextEditingController _shortDescCtrl;
  late TextEditingController _fullDescCtrl;
  late TextEditingController _tagsCtrl;
  String _selectedCategory = 'CAT-DIGITAL';
  String _subcategory = 'Vastu & Spatial Harmony';
  bool _isFeatured = false;
  bool _isBestseller = false;

  // Section B: Author
  late TextEditingController _authorNameCtrl;
  late TextEditingController _authorTitleCtrl;
  late TextEditingController _authorBioCtrl;
  late TextEditingController _authorOrgCtrl;
  late TextEditingController _authorCredCtrl;
  late TextEditingController _authorWebCtrl;

  // Section C: Digital Content
  late TextEditingController _fileUrlCtrl;
  DigitalFileFormat _fileFormat = DigitalFileFormat.pdf;
  late TextEditingController _fileSizeCtrl;
  late TextEditingController _pageCountCtrl;
  late TextEditingController _versionCtrl;
  late TextEditingController _coverImageCtrl;
  late TextEditingController _copyrightCtrl;

  // Section D: Pricing
  late TextEditingController _mrpCtrl;
  late TextEditingController _sellingPriceCtrl;
  late TextEditingController _taxRateCtrl;

  // Section E: Security & DRM
  bool _secureDownloadEnabled = true;
  int _downloadLinkExpiryHours = 48;
  int _maxDownloads = 5;
  bool _watermarkEnabled = true;

  // Section F: SEO
  late TextEditingController _seoTitleCtrl;
  late TextEditingController _metaDescCtrl;
  late TextEditingController _slugCtrl;

  // Section G: Publishing
  ProductPublicationStatus _publicationStatus = ProductPublicationStatus.published;
  ProductVisibility _visibility = ProductVisibility.public;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    final p = widget.productToEdit;

    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? 'PUB-DIG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
    _productCodeCtrl = TextEditingController(text: p?.productCode ?? 'HOMIO-BK-0${_repo.digitalProducts.length + 1}');
    _shortTitleCtrl = TextEditingController(text: p?.shortTitle ?? '');
    _subtitleCtrl = TextEditingController(text: p?.subtitle ?? '');
    _shortDescCtrl = TextEditingController(text: p?.shortDescription ?? '');
    _fullDescCtrl = TextEditingController(text: p?.fullDescription ?? '');
    _tagsCtrl = TextEditingController(text: p?.tags.join(', ') ?? 'Architecture, Handbook, Homio');
    _selectedCategory = p?.categoryId ?? 'CAT-DIGITAL';
    _subcategory = p?.subcategory ?? 'Vastu & Spatial Harmony';
    _isFeatured = p?.isFeatured ?? false;
    _isBestseller = p?.isBestseller ?? false;

    _authorNameCtrl = TextEditingController(text: p?.authorName ?? 'Acharya Dr. Radheshyam Joshi');
    _authorTitleCtrl = TextEditingController(text: p?.authorTitle ?? 'Principal Vastu Architect');
    _authorBioCtrl = TextEditingController(text: p?.authorBio ?? '25+ years experience in spatial energy architecture.');
    _authorOrgCtrl = TextEditingController(text: p?.authorOrganization ?? 'Homio Design Labs');
    _authorCredCtrl = TextEditingController(text: p?.authorCredentials ?? 'Ph.D. Vedic Sciences, BHU');
    _authorWebCtrl = TextEditingController(text: p?.authorWebsite ?? 'https://homio.in');

    _fileUrlCtrl = TextEditingController(text: p?.primaryFileUrl ?? 'https://cdn.homio.in/publications/manual.pdf');
    _fileFormat = p?.fileFormat ?? DigitalFileFormat.pdf;
    _fileSizeCtrl = TextEditingController(text: p?.fileSize ?? '45.0 MB');
    _pageCountCtrl = TextEditingController(text: p?.pageCount.toString() ?? '150');
    _versionCtrl = TextEditingController(text: p?.version ?? 'v1.0');
    _coverImageCtrl = TextEditingController(text: p?.coverImageUrl ?? 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600');
    _copyrightCtrl = TextEditingController(text: p?.copyrightInfo ?? '© 2026 Homio Technologies Pvt. Ltd.');

    _mrpCtrl = TextEditingController(text: p?.mrp.toString() ?? '1499.0');
    _sellingPriceCtrl = TextEditingController(text: p?.sellingPrice.toString() ?? '499.0');
    _taxRateCtrl = TextEditingController(text: p?.taxRate.toString() ?? '18.0');

    _secureDownloadEnabled = p?.secureDownloadEnabled ?? true;
    _downloadLinkExpiryHours = p?.downloadLinkExpiryHours ?? 48;
    _maxDownloads = p?.maxDownloads ?? 5;
    _watermarkEnabled = p?.watermarkEnabled ?? true;

    _seoTitleCtrl = TextEditingController(text: p?.seoTitle ?? '');
    _metaDescCtrl = TextEditingController(text: p?.metaDescription ?? '');
    _slugCtrl = TextEditingController(text: p?.urlSlug ?? '');

    _publicationStatus = p?.publicationStatus ?? ProductPublicationStatus.published;
    _visibility = p?.visibility ?? ProductVisibility.public;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _productCodeCtrl.dispose();
    _shortTitleCtrl.dispose();
    _subtitleCtrl.dispose();
    _shortDescCtrl.dispose();
    _fullDescCtrl.dispose();
    _tagsCtrl.dispose();
    _authorNameCtrl.dispose();
    _authorTitleCtrl.dispose();
    _authorBioCtrl.dispose();
    _authorOrgCtrl.dispose();
    _authorCredCtrl.dispose();
    _authorWebCtrl.dispose();
    _fileUrlCtrl.dispose();
    _fileSizeCtrl.dispose();
    _pageCountCtrl.dispose();
    _versionCtrl.dispose();
    _coverImageCtrl.dispose();
    _copyrightCtrl.dispose();
    _mrpCtrl.dispose();
    _sellingPriceCtrl.dispose();
    _taxRateCtrl.dispose();
    _seoTitleCtrl.dispose();
    _metaDescCtrl.dispose();
    _slugCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete required fields marked with *')),
      );
      return;
    }

    final product = DigitalProductEntity(
      id: widget.productToEdit?.id ?? 'DIG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: _nameCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      productCode: _productCodeCtrl.text.trim(),
      categoryId: _selectedCategory,
      categoryName: 'Digital Guides & Manuals',
      subcategory: _subcategory,
      shortTitle: _shortTitleCtrl.text.trim(),
      subtitle: _subtitleCtrl.text.trim(),
      shortDescription: _shortDescCtrl.text.trim(),
      fullDescription: _fullDescCtrl.text.trim(),
      tags: _tagsCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      keywords: ['vastu', 'homio manual', 'blueprint'],
      authorName: _authorNameCtrl.text.trim(),
      authorTitle: _authorTitleCtrl.text.trim(),
      authorBio: _authorBioCtrl.text.trim(),
      authorPhotoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      authorOrganization: _authorOrgCtrl.text.trim(),
      authorCredentials: _authorCredCtrl.text.trim(),
      authorWebsite: _authorWebCtrl.text.trim(),
      primaryFileUrl: _fileUrlCtrl.text.trim(),
      fileFormat: _fileFormat,
      fileSize: _fileSizeCtrl.text.trim(),
      pageCount: int.tryParse(_pageCountCtrl.text) ?? 100,
      version: _versionCtrl.text.trim(),
      tableOfContents: ['Overview', 'Key Principles', 'Checklists', 'Remedies'],
      previewExcerpt: _shortDescCtrl.text.trim(),
      coverImageUrl: _coverImageCtrl.text.trim(),
      previewImageUrls: [_coverImageCtrl.text.trim()],
      copyrightInfo: _copyrightCtrl.text.trim(),
      licenseInfo: 'Single Organization Digital License',
      mrp: double.tryParse(_mrpCtrl.text) ?? 999.0,
      sellingPrice: double.tryParse(_sellingPriceCtrl.text) ?? 499.0,
      discountType: 'Percentage',
      discountValue: 50.0,
      taxRate: double.tryParse(_taxRateCtrl.text) ?? 18.0,
      secureDownloadEnabled: _secureDownloadEnabled,
      downloadLinkExpiryHours: _downloadLinkExpiryHours,
      maxDownloads: _maxDownloads,
      seoTitle: _seoTitleCtrl.text.trim().isNotEmpty ? _seoTitleCtrl.text.trim() : _nameCtrl.text.trim(),
      metaDescription: _metaDescCtrl.text.trim(),
      urlSlug: _slugCtrl.text.trim().isNotEmpty ? _slugCtrl.text.trim() : _nameCtrl.text.trim().toLowerCase().replaceAll(' ', '-'),
      canonicalUrl: 'https://homio.in/marketplace/digital/${_slugCtrl.text.trim()}',
      publicationStatus: _publicationStatus,
      visibility: _visibility,
      isFeatured: _isFeatured,
      isBestseller: _isBestseller,
      createdAt: widget.productToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      publishedAt: _publicationStatus == ProductPublicationStatus.published ? DateTime.now() : widget.productToEdit?.publishedAt,
      totalPurchases: widget.productToEdit?.totalPurchases ?? 0,
      totalDownloads: widget.productToEdit?.totalDownloads ?? 0,
      failedDownloads: widget.productToEdit?.failedDownloads ?? 0,
      grossRevenue: widget.productToEdit?.grossRevenue ?? 0.0,
    );

    if (widget.productToEdit != null) {
      _repo.updateDigitalProduct(product);
    } else {
      _repo.addDigitalProduct(product);
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Digital product "${product.name}" successfully saved.')),
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
              // Dialog Header
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
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                        borderRadius: AppRadius.sm,
                      ),
                      child: const Icon(Icons.cloud_download_rounded, color: Color(0xFF3B82F6), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productToEdit != null ? 'Edit Digital Publication' : 'Create New Digital Product',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Structured 7-Section Form: Identity, Author, Files, Commercials, DRM & SEO',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Tab Bar (7 Sections A through G)
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                indicatorColor: AppColors.primary,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'A. Identity'),
                  Tab(text: 'B. Author'),
                  Tab(text: 'C. Content & Files'),
                  Tab(text: 'D. Pricing'),
                  Tab(text: 'E. DRM Security'),
                  Tab(text: 'F. SEO'),
                  Tab(text: 'G. Publishing'),
                ],
              ),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSectionA(isDark),
                    _buildSectionB(isDark),
                    _buildSectionC(isDark),
                    _buildSectionD(isDark),
                    _buildSectionE(isDark),
                    _buildSectionF(isDark),
                    _buildSectionG(isDark),
                  ],
                ),
              ),

              // Footer Actions
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontSize: 12.5)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: Text(
                        widget.productToEdit != null ? 'Update Publication' : 'Create & Publish Product',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                      ),
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

  Widget _buildSectionA(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Product Full Title *'),
          TextFormField(
            controller: _nameCtrl,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: _inputDeco('e.g. Complete Vastu Shastra Architectural Blueprint 2026', isDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('SKU Code *'),
                    TextFormField(
                      controller: _skuCtrl,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      decoration: _inputDeco('PUB-VASTU-2026', isDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Product Internal Code'),
                    TextFormField(
                      controller: _productCodeCtrl,
                      decoration: _inputDeco('HOMIO-BK-01', isDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Subtitle / Tagline'),
          TextFormField(
            controller: _subtitleCtrl,
            decoration: _inputDeco('Directional energy mapping & non-demolition remedies', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Short Description (Catalog Cards)'),
          TextFormField(
            controller: _shortDescCtrl,
            maxLines: 2,
            decoration: _inputDeco('The definitive architectural guide to compliant residential layout...', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Full Description (Product Page)'),
          TextFormField(
            controller: _fullDescCtrl,
            maxLines: 4,
            decoration: _inputDeco('Comprehensive breakdown of chapters, architectural drawings...', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Search Tags (Comma separated)'),
          TextFormField(
            controller: _tagsCtrl,
            decoration: _inputDeco('Vastu, Architecture, Interior Design, Blueprints', isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionB(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Author / Creator Name *'),
          TextFormField(
            controller: _authorNameCtrl,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: _inputDeco('e.g. Acharya Dr. Radheshyam Joshi', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Author Professional Title'),
          TextFormField(
            controller: _authorTitleCtrl,
            decoration: _inputDeco('Chief Vastu & Spatial Wellness Consultant', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Organization / Studio Affiliation'),
          TextFormField(
            controller: _authorOrgCtrl,
            decoration: _inputDeco('Homio Vedic Design Institute', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Author Academic Credentials'),
          TextFormField(
            controller: _authorCredCtrl,
            decoration: _inputDeco('Ph.D. Architectural Vedic Sciences, BHU Varanasi', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Author Biography'),
          TextFormField(
            controller: _authorBioCtrl,
            maxLines: 3,
            decoration: _inputDeco('Over 28 years of institutional consultancy for 1,400+ luxury villa projects...', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Author Website / Profile URL'),
          TextFormField(
            controller: _authorWebCtrl,
            decoration: _inputDeco('https://homio.in/vastu-institute', isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionC(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Primary File Storage URL / S3 Path *'),
          TextFormField(
            controller: _fileUrlCtrl,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            decoration: _inputDeco('https://cdn.homio.in/publications/complete-vastu-shastra-2026.pdf', isDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('File Format'),
                    DropdownButtonFormField<DigitalFileFormat>(
                      initialValue: _fileFormat,
                      decoration: _inputDeco('', isDark),
                      items: DigitalFileFormat.values.map((f) => DropdownMenuItem(value: f, child: Text(f.label))).toList(),
                      onChanged: (v) => setState(() => _fileFormat = v ?? DigitalFileFormat.pdf),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('File Size'),
                    TextFormField(
                      controller: _fileSizeCtrl,
                      decoration: _inputDeco('42.8 MB', isDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Page Count'),
                    TextFormField(
                      controller: _pageCountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('164', isDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Cover Image CDN URL'),
          TextFormField(
            controller: _coverImageCtrl,
            decoration: _inputDeco('https://images.unsplash.com/...', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Copyright & License Notice'),
          TextFormField(
            controller: _copyrightCtrl,
            decoration: _inputDeco('© 2026 Homio Technologies Pvt. Ltd. All Rights Reserved.', isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionD(bool isDark) {
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
                    _fieldLabel('MRP (Maximum Retail Price) ₹ *'),
                    TextFormField(
                      controller: _mrpCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      decoration: _inputDeco('1499.00', isDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Selling Price ₹ *'),
                    TextFormField(
                      controller: _sellingPriceCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      decoration: _inputDeco('499.00', isDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('GST Rate (%)'),
                    TextFormField(
                      controller: _taxRateCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('18.0', isDark),
                    ),
                  ],
                ),
              ),
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
                const Icon(Icons.price_check_rounded, color: Color(0xFF10B981)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Instant Digital Checkout Enabled: Customers complete payment and receive immediate DRM-tokenized download links via WhatsApp & Email.',
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

  Widget _buildSectionE(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Secure Expiring Downloads Enabled', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: Text('Restricts file access behind HMAC-SHA256 authenticated short-lived tokens', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
            value: _secureDownloadEnabled,
            onChanged: (v) => setState(() => _secureDownloadEnabled = v),
          ),
          const Divider(),
          ListTile(
            title: Text('Download Link Expiry Duration', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: Text('$_downloadLinkExpiryHours Hours after successful payment checkout', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
            trailing: DropdownButton<int>(
              value: _downloadLinkExpiryHours,
              items: const [
                DropdownMenuItem(value: 24, child: Text('24 Hours')),
                DropdownMenuItem(value: 48, child: Text('48 Hours (Default)')),
                DropdownMenuItem(value: 72, child: Text('72 Hours')),
                DropdownMenuItem(value: 168, child: Text('7 Days')),
              ],
              onChanged: (v) => setState(() => _downloadLinkExpiryHours = v ?? 48),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text('Maximum Allowed Download Attempts', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: Text('$_maxDownloads total download attempts per customer license', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
            trailing: DropdownButton<int>(
              value: _maxDownloads,
              items: const [
                DropdownMenuItem(value: 3, child: Text('3 Downloads')),
                DropdownMenuItem(value: 5, child: Text('5 Downloads (Default)')),
                DropdownMenuItem(value: 10, child: Text('10 Downloads')),
              ],
              onChanged: (v) => setState(() => _maxDownloads = v ?? 5),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: Text('Dynamic PDF Watermarking', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: Text('Stamps customer name, email & license transaction ID on every page margin', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
            value: _watermarkEnabled,
            onChanged: (v) => setState(() => _watermarkEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionF(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('SEO Meta Title'),
          TextFormField(
            controller: _seoTitleCtrl,
            decoration: _inputDeco('Complete Vastu Shastra Architectural Blueprint | Homio Digital Guides', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('SEO Meta Description'),
          TextFormField(
            controller: _metaDescCtrl,
            maxLines: 2,
            decoration: _inputDeco('Download the comprehensive 164-page Vastu Shastra architectural guide with floor plans and zone remedies.', isDark),
          ),
          const SizedBox(height: 12),
          _fieldLabel('URL Slug'),
          TextFormField(
            controller: _slugCtrl,
            decoration: _inputDeco('complete-vastu-shastra-guide', isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionG(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Publication Lifecycle Status'),
          DropdownButtonFormField<ProductPublicationStatus>(
            initialValue: _publicationStatus,
            decoration: _inputDeco('', isDark),
            items: ProductPublicationStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
            onChanged: (v) => setState(() => _publicationStatus = v ?? ProductPublicationStatus.published),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Catalog Visibility Scope'),
          DropdownButtonFormField<ProductVisibility>(
            initialValue: _visibility,
            decoration: _inputDeco('', isDark),
            items: ProductVisibility.values.map((v) => DropdownMenuItem(value: v, child: Text(v.label))).toList(),
            onChanged: (v) => setState(() => _visibility = v ?? ProductVisibility.public),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: Text('Mark as Featured Product', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: Text('Promotes product to top carousel in Homio Digital Store', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
            value: _isFeatured,
            onChanged: (v) => setState(() => _isFeatured = v ?? false),
          ),
          CheckboxListTile(
            title: Text('Mark as Bestseller', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: Text('Displays orange bestseller ribbon badge', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
            value: _isBestseller,
            onChanged: (v) => setState(() => _isBestseller = v ?? false),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12.5,
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
      ),
      isDense: true,
      filled: true,
      fillColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: AppRadius.sm,
        borderSide: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.sm,
        borderSide: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.sm,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
