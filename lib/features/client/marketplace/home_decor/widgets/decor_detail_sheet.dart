import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/marketplace_enums.dart';
import '../../models/home_decor_models.dart';
import '../../services/cart_service.dart';
import '../../widgets/marketplace_bottom_sheet.dart';
import '../../widgets/price_display.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/spec_row.dart';
import 'affiliate_badge.dart';

/// Modal detail sheet for curated home decor pieces
class DecorDetailSheet extends StatefulWidget {
  final HomeDecorItem item;

  const DecorDetailSheet({super.key, required this.item});

  static void show(BuildContext context, HomeDecorItem item) {
    MarketplaceBottomSheet.show(
      context: context,
      title: item.title,
      subtitle: '${item.brand} • ${item.designStyle}',
      headerTag: AffiliateBadge(
        platform: item.affiliatePlatform,
        isAffiliate: item.isAffiliate,
      ),
      body: DecorDetailSheet(item: item),
      bottomBar: _DecorBottomBar(item: item),
    );
  }

  @override
  State<DecorDetailSheet> createState() => _DecorDetailSheetState();
}

class _DecorDetailSheetState extends State<DecorDetailSheet> {
  int _selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Main Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              item.imageUrls.first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                child: const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Brand, Rating & In-Stock Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingStars(rating: item.rating, reviewCount: item.reviewCount),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item.inStock
                    ? const Color(0xFF10B981).withValues(alpha: 0.12)
                    : const Color(0xFFEF4444).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    item.inStock ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
                    size: 13,
                    color: item.inStock ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.inStock ? 'In Stock (${item.stockCount} left)' : 'Out of Stock',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: item.inStock ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Color / Finish Options
        if (item.colorOptions.isNotEmpty) ...[
          Text(
            'Finishes & Colorways',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(item.colorOptions.length, (index) {
              final colorName = item.colorOptions[index];
              final isSelected = index == _selectedColorIndex;
              return ChoiceChip(
                label: Text(
                  colorName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                onSelected: (val) {
                  if (val) setState(() => _selectedColorIndex = index);
                },
              );
            }),
          ),
          const SizedBox(height: 16),
        ],

        // Description
        Text(
          'Product Story & Design',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.description,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: textMuted,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        // Specifications
        Text(
          'Dimensions & Build Specs',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        SpecRow(label: 'Dimensions', value: item.dimensions, icon: Icons.straighten_rounded),
        SpecRow(label: 'Primary Material', value: item.material, icon: Icons.layers_rounded),
        SpecRow(label: 'Style Aesthetic', value: item.designStyle, icon: Icons.palette_outlined),
        SpecRow(label: 'Estimated Delivery', value: '${item.estimatedDeliveryDays} Business Days', icon: Icons.local_shipping_outlined),
        SpecRow(label: 'Warranty / Returns', value: item.returnPolicy, icon: Icons.verified_outlined),

        for (final entry in item.specifications.entries)
          SpecRow(label: entry.key, value: entry.value),

        const SizedBox(height: 20),

        // Platform Fulfillment Notice
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(item.affiliatePlatform.icon, color: const Color(0xFF10B981), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.affiliatePlatform.displayName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      item.affiliatePlatform.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DecorBottomBar extends StatelessWidget {
  final HomeDecorItem item;

  const _DecorBottomBar({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Price
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Price (Incl. all taxes)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              PriceDisplay(
                price: item.price,
                originalPrice: item.originalPrice,
                fontSize: 20,
              ),
            ],
          ),
        ),

        // Action CTA (Direct add to cart or affiliate partner)
        if (item.isAffiliate && item.affiliateUrl != null) ...[
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF8B5CF6),
                  content: Text(
                    'Opening partner link on ${item.affiliatePlatform.displayName}...',
                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: Text(
              'Buy on ${item.affiliatePlatform.displayName}',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: () {
              CartService().addItem(
                productId: item.id,
                title: item.title,
                imageUrl: item.imageUrls.first,
                unitPrice: item.price,
                category: MarketplaceCategory.homeDecor,
                variant: item.colorOptions.isNotEmpty ? item.colorOptions.first : null,
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF10B981),
                  content: Text(
                    'Added to cart: ${item.title}',
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
      ],
    );
  }
}
