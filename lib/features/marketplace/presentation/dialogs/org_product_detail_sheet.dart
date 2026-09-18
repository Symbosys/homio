import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../platform_admin/data/models/platform_marketplace_category_model.dart';
import '../../data/models/org_marketplace_models.dart';
import 'org_digital_product_dialog.dart';
import 'org_home_decor_dialog.dart';
import 'org_property_dialog.dart';
import 'org_material_dialog.dart';

enum ProductType { digital, homeDecor, property, material }

class DetailItem {
  final String label;
  final String value;
  const DetailItem(this.label, this.value);
}

class OrgProductDetailSheet extends StatelessWidget {
  final PlatformMarketplaceCategoryModel category;
  final dynamic product;
  final ProductType productType;

  const OrgProductDetailSheet({
    super.key,
    required this.category,
    required this.product,
    required this.productType,
  });

  static Future<void> showDigital(
    BuildContext context, {
    required PlatformMarketplaceCategoryModel category,
    required OrgDigitalProductModel product,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => OrgProductDetailSheet(
        category: category,
        product: product,
        productType: ProductType.digital,
      ),
    );
  }

  static Future<void> showHomeDecor(
    BuildContext context, {
    required PlatformMarketplaceCategoryModel category,
    required OrgHomeDecorProductModel product,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => OrgProductDetailSheet(
        category: category,
        product: product,
        productType: ProductType.homeDecor,
      ),
    );
  }

  static Future<void> showProperty(
    BuildContext context, {
    required PlatformMarketplaceCategoryModel category,
    required OrgPropertyListingModel product,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => OrgProductDetailSheet(
        category: category,
        product: product,
        productType: ProductType.property,
      ),
    );
  }

  static Future<void> showMaterial(
    BuildContext context, {
    required PlatformMarketplaceCategoryModel category,
    required OrgMaterialProductModel product,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => OrgProductDetailSheet(
        category: category,
        product: product,
        productType: ProductType.material,
      ),
    );
  }

  void _openEditDialog(BuildContext context) {
    Navigator.of(context).pop();
    switch (productType) {
      case ProductType.digital:
        OrgDigitalProductDialog.show(context, category: category, product: product as OrgDigitalProductModel);
        break;
      case ProductType.homeDecor:
        OrgHomeDecorDialog.show(context, category: category, product: product as OrgHomeDecorProductModel);
        break;
      case ProductType.property:
        OrgPropertyDialog.show(context, category: category, property: product as OrgPropertyListingModel);
        break;
      case ProductType.material:
        OrgMaterialDialog.show(context, category: category, material: product as OrgMaterialProductModel);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 780,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, isDark),
              const Divider(height: 24),

              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Banner & Image Section
                      _buildMediaAndPrimaryDetails(context, isDark),
                      const SizedBox(height: AppSpacing.lg),

                      // Detail Content based on product vertical
                      _buildVerticalSpecificDetails(isDark),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),

              // Footer Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _openEditDialog(context),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Product Attributes'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    String title = '';
    String? status;
    bool isFeatured = false;

    if (productType == ProductType.digital) {
      final p = product as OrgDigitalProductModel;
      title = p.name;
      status = p.status;
      isFeatured = p.isFeatured;
    } else if (productType == ProductType.homeDecor) {
      final p = product as OrgHomeDecorProductModel;
      title = p.name;
      status = p.status;
      isFeatured = p.isFeatured;
    } else if (productType == ProductType.property) {
      final p = product as OrgPropertyListingModel;
      title = p.title;
      status = p.status;
      isFeatured = p.isFeatured;
    } else if (productType == ProductType.material) {
      final p = product as OrgMaterialProductModel;
      title = p.name;
      status = p.status;
      isFeatured = p.isFeatured;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (status == 'PUBLISHED' || status == 'ACTIVE' || status == 'AVAILABLE')
                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                          : Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status ?? 'ACTIVE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: (status == 'PUBLISHED' || status == 'ACTIVE' || status == 'AVAILABLE')
                            ? const Color(0xFF10B981)
                            : Colors.orange,
                      ),
                    ),
                  ),
                  if (isFeatured) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 3),
                          Text(
                            'Featured',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          splashRadius: 20,
        ),
      ],
    );
  }

  Widget _buildMediaAndPrimaryDetails(BuildContext context, bool isDark) {
    String? coverUrl;
    List<DetailItem> kpis = [];

    switch (productType) {
      case ProductType.digital:
        final p = product as OrgDigitalProductModel;
        coverUrl = p.coverImageUrl;
        kpis = [
          DetailItem('Selling Price', '₹${p.sellingPrice.toStringAsFixed(2)}'),
          DetailItem('Rating', p.rating > 0 ? '★ ${p.rating.toStringAsFixed(1)} (${p.reviewsCount})' : '★ ${p.rating.toStringAsFixed(1)}'),
          DetailItem('File Format', p.fileFormat),
          DetailItem('Total Purchases', '${p.totalPurchases}'),
        ];
        break;
      case ProductType.homeDecor:
        final p = product as OrgHomeDecorProductModel;
        coverUrl = p.coverImageUrl;
        kpis = [
          DetailItem('Selling Price', '₹${p.sellingPrice.toStringAsFixed(2)}'),
          DetailItem('MRP', '₹${p.mrp.toStringAsFixed(2)}'),
          DetailItem('In Stock', '${p.stockCount} units'),
          DetailItem('Ownership', p.ownershipType),
        ];
        break;
      case ProductType.property:
        final p = product as OrgPropertyListingModel;
        coverUrl = p.coverImageUrl;
        kpis = [
          DetailItem('Price / Rent', '₹${p.price.toStringAsFixed(0)}'),
          DetailItem('Intent', p.intent),
          DetailItem('Type', p.propertyType),
          DetailItem('Carpet Area', '${p.carpetAreaSqft} sqft'),
        ];
        break;
      case ProductType.material:
        final p = product as OrgMaterialProductModel;
        coverUrl = p.coverImageUrl;
        kpis = [
          DetailItem('Wholesale Price', '₹${p.wholesalePrice.toStringAsFixed(2)} / ${p.unitOfMeasure}'),
          DetailItem('Min Order', '${p.minOrderQuantity} ${p.unitOfMeasure}'),
          DetailItem('Stock Available', '${p.stockAvailableUnits} units'),
          DetailItem('Ownership', p.ownershipType),
        ];
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Preview
          ClipRRect(
            borderRadius: AppRadius.sm,
            child: SizedBox(
              width: 140,
              height: 100,
              child: coverUrl != null && coverUrl.isNotEmpty
                  ? Image.network(
                      coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),

          // Primary Metas
          Expanded(
            child: _buildKpiGridRow(kpis, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF6366F1), size: 36),
      ),
    );
  }

  Widget _buildKpiGridRow(List<DetailItem> items, bool isDark) {
    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.sm,
      children: items.map((item) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildVerticalSpecificDetails(bool isDark) {
    switch (productType) {
      case ProductType.digital:
        return _buildDigitalDetails(isDark);
      case ProductType.homeDecor:
        return _buildHomeDecorDetails(isDark);
      case ProductType.property:
        return _buildPropertyDetails(isDark);
      case ProductType.material:
        return _buildMaterialDetails(isDark);
    }
  }

  Widget _buildDigitalDetails(bool isDark) {
    final p = product as OrgDigitalProductModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Digital Asset Specifications', isDark),
        _buildInfoGrid([
          DetailItem('Author / Creator', p.authorName ?? 'N/A'),
          DetailItem('File Format (Enum)', p.fileFormat),
          DetailItem('File Size', p.fileSize ?? 'N/A'),
          DetailItem('MRP / List Price', '₹${p.mrp.toStringAsFixed(2)}'),
          DetailItem('Tax / GST Rate', '${p.taxRate}%'),
          DetailItem('Rating & Reviews', '★ ${p.rating.toStringAsFixed(1)} (${p.reviewsCount} reviews)'),
          DetailItem('Total Purchases / Unlocks', '${p.totalPurchases} units'),
          DetailItem('Download Link Expiry', '${p.downloadLinkExpiryHours} hours'),
          DetailItem('Max Download Limit', '${p.maxDownloads} downloads'),
          DetailItem('Asset File Path / URL', p.fileUrl),
          DetailItem('SKU Code', p.sku),
          DetailItem('URL Slug', p.urlSlug),
        ], isDark),
        if (p.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildTagsList(p.tags, isDark),
        ],
        if (p.description != null && p.description!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildTextContent('Description', p.description!, isDark),
        ],
      ],
    );
  }

  Widget _buildHomeDecorDetails(bool isDark) {
    final p = product as OrgHomeDecorProductModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Product Specifications & Design Details', isDark),
        _buildInfoGrid([
          DetailItem('SKU Code', p.sku),
          DetailItem('Brand Name', p.brandName ?? 'N/A'),
          DetailItem('Room Placement', p.roomType ?? 'N/A'),
          DetailItem('Material', p.material ?? 'N/A'),
          DetailItem('Color / Finish', p.color ?? 'N/A'),
          DetailItem('Dimensions', p.dimensions ?? 'N/A'),
          DetailItem('Min Order Qty', '${p.minOrderQuantity} units'),
          DetailItem('GST Rate', '${p.taxRate}%'),
          DetailItem('Sample Available', p.sampleAvailable ? 'Yes (₹${p.samplePrice})' : 'No'),
          DetailItem('Affiliate Enabled', p.isAffiliateEnabled ? 'Yes (${p.affiliatePartner ?? "Direct"} @ ${p.commissionRate}%)' : 'No'),
        ], isDark),
        if (p.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildTagsList(p.tags, isDark),
        ],
        if (p.description != null && p.description!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildTextContent('Description & Care', p.description!, isDark),
        ],
      ],
    );
  }

  Widget _buildPropertyDetails(bool isDark) {
    final p = product as OrgPropertyListingModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Real Estate & Architecture Specs', isDark),
        _buildInfoGrid([
          DetailItem('BHK / Layout', p.bhk),
          DetailItem('Bedrooms / Baths', '${p.bedrooms} Beds • ${p.bathrooms} Baths • ${p.balconies} Balconies'),
          DetailItem('Super Built-up Area', p.superBuiltUpSqft != null ? '${p.superBuiltUpSqft} sqft' : 'N/A'),
          DetailItem('Furnishing Status', p.furnishingStatus),
          DetailItem('Floor', p.floorNumber != null ? 'Floor ${p.floorNumber} of ${p.totalFloors ?? "N/A"}' : 'N/A'),
          DetailItem('Parking Slots', '${p.coveredParkingSlots} slots'),
          DetailItem('Available From', p.availableFrom != null ? p.availableFrom!.toIso8601String().split('T').first : 'Immediate'),
          DetailItem('Monthly Maintenance', '₹${p.maintenanceMonthly}/mo'),
          DetailItem('Price Negotiable', p.isNegotiable ? 'Yes' : 'No'),
          DetailItem('Verification Status', p.verificationStatus),
          DetailItem('Lead Unlock Fee', '₹${p.contactUnlockFee} (valid ${p.contactUnlockDurationDays} days)'),
          DetailItem('Total Unlocks Count', '${p.totalContactUnlocks} unlocks'),
        ], isDark),
        const SizedBox(height: AppSpacing.md),
        _buildSectionHeader('Location & Property Address', isDark),
        _buildInfoGrid([
          DetailItem('Address Line', p.addressLine ?? 'N/A'),
          DetailItem('Locality', p.locality),
          DetailItem('City', p.city),
          DetailItem('State & PIN', '${p.state} - ${p.pinCode ?? ""}'),
          DetailItem('GPS Coordinates', (p.latitude != null && p.longitude != null) ? '${p.latitude}, ${p.longitude}' : 'Not Specified'),
          DetailItem('Owner Contact', '${p.ownerName} (${p.ownerPhone})'),
          DetailItem('Owner Email', p.ownerEmail ?? 'N/A'),
        ], isDark),
        if (p.amenities.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildSectionHeader('Amenities & Perks', isDark),
          _buildTagsList(p.amenities, isDark),
        ],
        if (p.description != null && p.description!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildTextContent('Property Description', p.description!, isDark),
        ],
      ],
    );
  }

  Widget _buildMaterialDetails(bool isDark) {
    final p = product as OrgMaterialProductModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Material Specifications & Industrial Specs', isDark),
        _buildInfoGrid([
          DetailItem('SKU / Code', p.sku),
          DetailItem('Brand / Mill', p.brandName ?? 'N/A'),
          DetailItem('Material Class', p.materialType ?? 'N/A'),
          DetailItem('Grade / Standard', p.grade ?? 'N/A'),
          DetailItem('Dimensions', p.dimensions ?? 'N/A'),
          DetailItem('Thickness / Gauge', p.thickness ?? 'N/A'),
          DetailItem('Application / Use', p.application ?? 'N/A'),
          DetailItem('Retail / MRP', '₹${p.retailPrice.toStringAsFixed(2)}'),
          DetailItem('GST / Tax Rate', '${p.taxRate}%'),
          DetailItem('Rating', '★ ${p.rating.toStringAsFixed(1)}'),
          DetailItem('Orders Placed', '${p.ordersCount} orders'),
          DetailItem('Commission Rate', p.ownerCommissionRate != null ? '${p.ownerCommissionRate}%' : 'N/A'),
          DetailItem('Supplier / Vendor', p.vendorId != null ? 'Vendor ID: ${p.vendorId}' : 'Direct Self Yard'),
        ], isDark),
        if (p.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildTagsList(p.tags, isDark),
        ],
        if (p.description != null && p.description!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildTextContent('Bulk Supply Terms & Description', p.description!, isDark),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildInfoGrid(List<DetailItem> items, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.sm,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 44,
          crossAxisSpacing: 16,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                item.value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTagsList(List<String> tags, bool isDark) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.map((t) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            t,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextContent(String label, String content, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
        borderRadius: AppRadius.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 1.5,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
