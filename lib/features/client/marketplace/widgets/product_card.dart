import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../services/marketplace_service.dart';
import 'price_display.dart';
import 'rating_stars.dart';

/// Universal card for Digital Products and Home Decor items
class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final double? rating;
  final int? reviewCount;
  final String? tag;
  final Color? tagColor;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;
  final String actionLabel;
  final IconData actionIcon;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    this.tag,
    this.tagColor,
    required this.onTap,
    this.onAddToCart,
    this.actionLabel = 'View Details',
    this.actionIcon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final accent = tagColor ?? const Color(0xFF10B981);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                      child: const Center(
                        child: Icon(Icons.image_outlined, size: 36, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // Tag Pill
                if (tag != null) ...[
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: accent.withValues(alpha: 0.6)),
                      ),
                      child: Text(
                        tag!.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: accent,
                        ),
                      ),
                    ),
                  ),
                ],

                // Wishlist Toggle
                Positioned(
                  top: 10,
                  right: 10,
                  child: ListenableBuilder(
                    listenable: MarketplaceService(),
                    builder: (context, _) {
                      final isWish = MarketplaceService().isWishlisted(id);
                      return Material(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => MarketplaceService().toggleWishlist(id),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              isWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 16,
                              color: isWish ? const Color(0xFFEF4444) : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subtitle / Brand
                  if (subtitle != null) ...[
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],

                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  if (rating != null) ...[
                    RatingStars(rating: rating!, reviewCount: reviewCount),
                    const SizedBox(height: 8),
                  ],

                  // Price
                  PriceDisplay(
                    price: price,
                    originalPrice: originalPrice,
                    fontSize: 16,
                  ),

                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTap,
                          icon: Icon(actionIcon, size: 14),
                          label: Text(
                            actionLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textPrimary,
                            side: BorderSide(color: border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      if (onAddToCart != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.12),
                            foregroundColor: const Color(0xFF10B981),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ],
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
}
