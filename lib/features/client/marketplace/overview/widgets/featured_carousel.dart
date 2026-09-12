import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../models/digital_product_models.dart';
import '../../models/home_decor_models.dart';
import '../../models/property_models.dart';
import '../../widgets/product_card.dart';

/// Horizontal showcase of trending items across the marketplace
class FeaturedCarousel extends StatelessWidget {
  final List<DigitalProductItem> digitalItems;
  final List<HomeDecorItem> decorItems;
  final List<PropertyItem> propertyItems;

  const FeaturedCarousel({
    super.key,
    required this.digitalItems,
    required this.decorItems,
    required this.propertyItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B), size: 22),
                const SizedBox(width: 8),
                Text(
                  'Featured & Trending Now',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => context.go('/client/marketplace/digital-products'),
              icon: const Icon(Icons.arrow_forward_rounded, size: 14),
              label: Text(
                'View All',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF10B981),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 330,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Digital items
              for (final d in digitalItems.take(2))
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 270,
                    child: ProductCard(
                      id: d.id,
                      title: d.title,
                      subtitle: d.category.label,
                      imageUrl: d.previewImages.first,
                      price: d.price,
                      originalPrice: d.originalPrice,
                      rating: d.rating,
                      reviewCount: d.reviewCount,
                      tag: 'Digital Pack',
                      tagColor: const Color(0xFF10B981),
                      onTap: () => context.go('/client/marketplace/digital-products'),
                    ),
                  ),
                ),

              // Home decor items
              for (final h in decorItems.take(2))
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 270,
                    child: ProductCard(
                      id: h.id,
                      title: h.title,
                      subtitle: h.brand,
                      imageUrl: h.imageUrls.first,
                      price: h.price,
                      originalPrice: h.originalPrice,
                      rating: h.rating,
                      reviewCount: h.reviewCount,
                      tag: h.isAffiliate ? h.affiliatePlatform.displayName : 'HOMIO Curated',
                      tagColor: h.isAffiliate ? const Color(0xFF8B5CF6) : const Color(0xFF10B981),
                      onTap: () => context.go('/client/marketplace/home-decor'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
