import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/marketplace_enums.dart';
import '../../models/digital_product_models.dart';
import '../../services/cart_service.dart';
import '../../widgets/marketplace_bottom_sheet.dart';
import '../../widgets/price_display.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/spec_row.dart';
import 'software_badge.dart';

/// Comprehensive product detail modal for downloadable digital assets
class DigitalProductDetailSheet extends StatelessWidget {
  final DigitalProductItem product;

  const DigitalProductDetailSheet({super.key, required this.product});

  static void show(BuildContext context, DigitalProductItem product) {
    MarketplaceBottomSheet.show(
      context: context,
      title: product.title,
      subtitle: product.subtitle,
      headerTag: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          product.category.label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF10B981),
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: DigitalProductDetailSheet(product: product),
      bottomBar: _DigitalProductBottomBar(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Preview Image Showcase
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              product.previewImages.first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                child: const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Rating, Downloads & Author Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingStars(rating: product.rating, reviewCount: product.reviewCount),
            Row(
              children: [
                Icon(Icons.download_rounded, size: 14, color: textMuted),
                const SizedBox(width: 4),
                Text(
                  '${product.downloadCount} Downloads',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Author Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                child: const Icon(Icons.person_rounded, color: Color(0xFF10B981), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.authorName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    product.authorRole,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Description
        Text(
          'Overview & Description',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          product.description,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: textMuted,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        // Compatible Software
        Text(
          'Compatible Applications',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.compatibleSoftware.map((s) => SoftwareBadge(softwareName: s)).toList(),
        ),

        const SizedBox(height: 20),

        // Technical File Specifications
        Text(
          'File Specifications',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        SpecRow(label: 'Format', value: product.fileFormat, icon: Icons.folder_zip_rounded),
        SpecRow(label: 'Download Size', value: product.fileSize, icon: Icons.cloud_download_rounded),
        SpecRow(label: 'Delivery Method', value: 'Instant Access to Designs Vault', icon: Icons.bolt_rounded),

        const SizedBox(height: 20),

        // Package Inclusions
        if (product.inclusions.isNotEmpty) ...[
          Text(
            'What\'s Included in this Download',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          for (final inc in product.inclusions)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      inc,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _DigitalProductBottomBar extends StatelessWidget {
  final DigitalProductItem product;

  const _DigitalProductBottomBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Price display
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Instant Download License',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              PriceDisplay(
                price: product.price,
                originalPrice: product.originalPrice,
                fontSize: 20,
              ),
            ],
          ),
        ),

        // Add to cart
        ElevatedButton.icon(
          onPressed: () {
            CartService().addItem(
              productId: product.id,
              title: product.title,
              imageUrl: product.previewImages.first,
              unitPrice: product.price,
              category: MarketplaceCategory.digitalProducts,
              variant: product.fileFormat,
            );
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF10B981),
                content: Text(
                  'Added to cart: ${product.title}',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
          label: Text(
            'Add to Cart',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
