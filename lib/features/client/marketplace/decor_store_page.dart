import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

/// Home Decor & Material Catalog Page with Contractor Trade Discounts.
class ClientDecorStorePage extends StatefulWidget {
  const ClientDecorStorePage({super.key});

  @override
  State<ClientDecorStorePage> createState() => _ClientDecorStorePageState();
}

class _ClientDecorStorePageState extends State<ClientDecorStorePage> {
  DecorCategory _selectedCategory = DecorCategory.all;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    final products = globalMarketplaceState.decorProducts.where((p) {
      final matchesCat = _selectedCategory == DecorCategory.all || p.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();

    final sampleItems = globalMarketplaceState.decorProducts.where((p) => p.inSampleCart).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page Title & Subtitle Banner
              _buildStoreBanner(isDark, isMobile),
              const SizedBox(height: 18),

              // Search and Category Tabs
              _buildFilterBar(isDark, isMobile),
              const SizedBox(height: 18),

              // Sample Requests Tray (if any items requested)
              if (sampleItems.isNotEmpty) ...[
                _buildSampleTray(sampleItems, isDark, isMobile),
                const SizedBox(height: 20),
              ],

              // Products Section Title
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MATERIALS & FINISHES (${products.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0284C7),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Direct B2B Contractor Pricing for Villa 402',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Text(
                      'MATERIALS & FINISHES (${products.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0284C7),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Direct B2B Contractor Pricing for Villa 402',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),

              // Products Grid
              if (products.isEmpty)
                _buildEmptyState(isDark)
              else
                _buildProductsGrid(products, isDark, isMobile),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreBanner(bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  color: Color(0xFF0284C7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wholesale Interior Decor & Materials Catalog',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Direct manufacturer trade discounts (15% to 32% below retail) on verified tiles, veneers, lighting, and bathware.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 11.5 : 13,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search Bar
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'Search materials by brand, finish, or category (e.g. Marble, Kohler, Louvers)...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 18,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: DecorCategory.values.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat.icon,
                        size: 14,
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      ),
                      const SizedBox(width: 6),
                      Text(cat.label),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                  selectedColor: const Color(0xFF0284C7),
                  backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.full,
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF0284C7)
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSampleTray(List<DecorProduct> sampleItems, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0284C7).withValues(alpha: 0.08),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFF0284C7).withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.inventory_2_rounded, color: Color(0xFF0284C7), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ACTIVE SAMPLES REQUESTED FOR VILLA 402 (${sampleItems.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0284C7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Free Site Delivery in 48 hrs',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.inventory_2_rounded, color: Color(0xFF0284C7), size: 18),
                const SizedBox(width: 8),
                Text(
                  'ACTIVE SAMPLES REQUESTED FOR VILLA 402 (${sampleItems.length})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0284C7),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'Free Site Delivery in 48 hrs',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          ...sampleItems.map((p) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${p.title} • Brand: ${p.brand}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          p.inSampleCart = false;
                        });
                      },
                      child: Text(
                        'Remove',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<DecorProduct> products, bool isDark, bool isMobile) {
    return Column(
      children: products.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _buildProductCard(p, isDark, isMobile),
        );
      }).toList(),
    );
  }

  Widget _buildProductCard(DecorProduct product, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand pill + Discount tag
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  product.brand.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0284C7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: AppRadius.sm,
                ),
                child: Text(
                  '${product.discountPercent}% OFF TRADE DISCOUNT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text(
                    'Dispatch in ${product.leadTimeDays}d',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            product.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Dimensions & Finish Chips
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildSpecChip(Icons.straighten_rounded, product.dimensions, isDark),
              _buildSpecChip(Icons.auto_awesome_rounded, 'Finish: ${product.finish}', isDark),
              if (product.sampleAvailable)
                _buildSpecChip(Icons.inventory_2_rounded, 'Site Sample Available', isDark, isHighlight: true),
            ],
          ),
          const SizedBox(height: 14),

          const Divider(height: 1),
          const SizedBox(height: 12),

          // Bottom Price & Action Row
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPriceSection(product, isDark),
                const SizedBox(height: 10),
                _buildActionButtons(product, isDark),
              ],
            )
          else
            Row(
              children: [
                _buildPriceSection(product, isDark),
                const Spacer(),
                _buildActionButtons(product, isDark),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSpecChip(IconData icon, String label, bool isDark, {bool isHighlight = false}) {
    final color = isHighlight ? const Color(0xFF10B981) : const Color(0xFF64748B);
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlight
            ? const Color(0xFF10B981).withValues(alpha: 0.1)
            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isHighlight
              ? const Color(0xFF10B981).withValues(alpha: 0.3)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: isHighlight ? const Color(0xFF10B981) : (isDark ? Colors.white70 : const Color(0xFF334155)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(DecorProduct product, bool isDark) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        Text(
          '₹${product.mrpPrice.toInt()}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.lineThrough,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        Text(
          '₹${product.tradePrice.toInt()}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0284C7),
          ),
        ),
        Text(
          '/ unit / sq.ft',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(DecorProduct product, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => _showSpecSheetModal(context, product, isDark),
          icon: const Icon(Icons.info_outline_rounded, size: 16),
          label: const Text('Spec Sheet'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
        ),
        if (product.sampleAvailable)
          ElevatedButton.icon(
            onPressed: () => _handleSampleRequest(product),
            icon: Icon(
              product.inSampleCart ? Icons.check_circle_rounded : Icons.inventory_2_rounded,
              size: 16,
            ),
            label: Text(product.inSampleCart ? 'Sample Requested' : 'Order Site Sample'),
            style: ElevatedButton.styleFrom(
              backgroundColor: product.inSampleCart ? const Color(0xFF10B981) : const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            ),
          ),
      ],
    );
  }

  void _handleSampleRequest(DecorProduct product) {
    setState(() {
      product.inSampleCart = !product.inSampleCart;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: product.inSampleCart ? const Color(0xFF0284C7) : const Color(0xFF64748B),
        content: Text(
          product.inSampleCart
              ? 'Sample for "${product.title}" scheduled for delivery to Palm Heights Villa 402!'
              : 'Removed sample for "${product.title}".',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showSpecSheetModal(BuildContext context, DecorProduct product, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                  borderRadius: AppRadius.md,
                ),
                child: const Icon(Icons.layers_rounded, color: Color(0xFF0284C7), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Brand: ${product.brand} • Category: ${product.category.label}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 16),
                  _buildSpecRow('Dimensions', product.dimensions, isDark),
                  _buildSpecRow('Surface Finish', product.finish, isDark),
                  _buildSpecRow('Retail MRP', '₹${product.mrpPrice.toInt()} per unit', isDark),
                  _buildSpecRow('Homio Trade Price', '₹${product.tradePrice.toInt()} per unit (Save ${product.discountPercent}%)', isDark, isHighlight: true),
                  _buildSpecRow('Factory Lead Time', '${product.leadTimeDays} business days to site', isDark),
                  _buildSpecRow('Partner Store', product.affiliateUrl, isDark),
                  const SizedBox(height: 12),
                  Text(
                    'ARCHITECTURAL APPLICATION NOTES',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0284C7),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
            if (product.sampleAvailable && !product.inSampleCart)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _handleSampleRequest(product);
                },
                icon: const Icon(Icons.inventory_2_rounded, size: 16),
                label: const Text('Request Site Sample'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
                color: isHighlight
                    ? const Color(0xFF0284C7)
                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 36, color: Color(0xFF94A3B8)),
            const SizedBox(height: 10),
            Text(
              'No materials found matching your search',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try changing the category or search keywords.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
