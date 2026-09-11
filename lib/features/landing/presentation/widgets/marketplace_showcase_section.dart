import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/adaptive_container.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/theme_controller.dart';

class MarketplaceShowcaseSection extends StatefulWidget {
  const MarketplaceShowcaseSection({super.key});

  @override
  State<MarketplaceShowcaseSection> createState() => _MarketplaceShowcaseSectionState();
}

class _MarketplaceShowcaseSectionState extends State<MarketplaceShowcaseSection> {
  int _activeCategoryIndex = 0;

  final List<String> _categories = [
    'All Categories',
    'Home Décor',
    'Premium Properties',
    'Materials & Finishes',
    'Digital Store',
  ];

  final List<Map<String, dynamic>> _items = [
    {
      'category': 'Home Décor',
      'title': 'Bespoke Curvature Bouclé Sectional',
      'subtitle': 'Italian Solid Beech Frame & Textured Wool Bouclé',
      'tag': 'CURATED FURNITURE',
      'spec': 'Handcrafted in Milan • Lead Time: 4 Weeks',
      'imageUrl': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&auto=format&fit=crop&q=80',
    },
    {
      'category': 'Premium Properties',
      'title': 'The Azure Horizon Cliffside Villa',
      'subtitle': 'Private Oceanfront Estate • 8,400 Sq.Ft Built-Up',
      'tag': 'ARCHITECTURAL RESIDENCE',
      'spec': 'Alibaug Coast • Infinity Lap Pool • Helipad',
      'imageUrl': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&auto=format&fit=crop&q=80',
    },
    {
      'category': 'Materials & Finishes',
      'title': 'Calacatta Gold Extra Bookmatch Slab',
      'subtitle': 'Quarried in Carrara, Italy • 20mm Honed Texture',
      'tag': 'NATURAL STONE',
      'spec': 'Lot #842 • Density 2.71 g/cm³ • In Stock',
      'imageUrl': 'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=800&auto=format&fit=crop&q=80',
    },
    {
      'category': 'Home Décor',
      'title': 'Flos Arco Floor Luminaire Reproduction',
      'subtitle': 'Solid White Carrara Marble Base & Polished Aluminum',
      'tag': 'ARCHITECTURAL LIGHTING',
      'spec': 'Dimmable 2700K Warm LED • Certified CE',
      'imageUrl': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&auto=format&fit=crop&q=80',
    },
    {
      'category': 'Digital Store',
      'title': 'BIM Parametric Villa Model & 3D Shaders',
      'subtitle': 'Autodesk Revit 2026 + SketchUp + Corona Render Ready',
      'tag': 'DIGITAL ASSETS',
      'spec': '148 Parametric Families • Complete Detail Library',
      'imageUrl': 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800&auto=format&fit=crop&q=80',
    },
    {
      'category': 'Premium Properties',
      'title': 'The Glass House Sky Penthouse',
      'subtitle': 'Full-Floor Penthouse with 360° Skyline Vista',
      'tag': 'LUXURY REAL ESTATE',
      'spec': 'Worli Seaface • 6,200 Sq.Ft • Private Elevator',
      'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&auto=format&fit=crop&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode(context);
    final isCompact = context.isCompact;

    final filteredItems = _activeCategoryIndex == 0
        ? _items
        : _items.where((i) => i['category'] == _categories[_activeCategoryIndex]).toList();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isCompact ? 50 : 90,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
      ),
      child: AdaptiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Eyebrow
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFFD97706).withValues(alpha: 0.15) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFFD97706).withValues(alpha: 0.5) : const Color(0xFFFDE68A),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storefront_outlined, size: 14, color: Color(0xFFD97706)),
                  const SizedBox(width: 8),
                  Text(
                    'HOMIO CURATED MARKETPLACE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: const Color(0xFFD97706),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Heading
            Text(
              'Discover Spaces, Products & Possibilities',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: context.responsiveValue<double>(
                  compact: 28,
                  medium: 38,
                  expanded: 44,
                  large: 48,
                ),
                fontWeight: FontWeight.w800,
                letterSpacing: -1.4,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 16),

            // Supporting
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                'Explore a curated ecosystem for digital assets, home décor, materials, and premium properties.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isCompact ? 15 : 17,
                  height: 1.6,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 36),

            // Category Filter Pills (Presentation Only)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_categories.length, (index) {
                  final cat = _categories[index];
                  final isSelected = _activeCategoryIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => setState(() => _activeCategoryIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                              : (isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 40),

            // Editorial Showcase Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width > 1000 ? 3 : (width > 640 ? 2 : 1);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.84,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _MarketplaceCard(item: item, isDark: isDark);
                  },
                );
              },
            ),

            const SizedBox(height: 36),

            // Showcase Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_outlined, size: 18, color: Color(0xFF10B981)),
                  const SizedBox(width: 10),
                  Text(
                    'Direct Pre-Negotiated Developer & Supplier Pricing Synchronized in BOQ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                    ),
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

class _MarketplaceCard extends StatelessWidget {
  const _MarketplaceCard({required this.item, required this.isDark});

  final Map<String, dynamic> item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item['imageUrl'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, err, stack) => Container(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      child: const Center(child: Icon(Icons.image_outlined, size: 36)),
                    ),
                  ),
                  // Tag Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['tag'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 12, color: Color(0xFF10B981)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item['spec'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
