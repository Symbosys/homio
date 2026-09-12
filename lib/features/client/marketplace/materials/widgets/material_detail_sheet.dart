import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/marketplace_enums.dart';
import '../../models/material_models.dart';
import '../../services/cart_service.dart';
import '../../widgets/marketplace_bottom_sheet.dart';
import '../../widgets/price_display.dart';
import '../../widgets/quantity_selector.dart';
import '../../widgets/spec_row.dart';
import '../../widgets/verified_badge.dart';

/// Comprehensive product sheet for bulk materials with live MOQ calculation
class MaterialDetailSheet extends StatefulWidget {
  final MaterialItem material;
  final bool isTradePricingEnabled;

  const MaterialDetailSheet({
    super.key,
    required this.material,
    required this.isTradePricingEnabled,
  });

  static void show({
    required BuildContext context,
    required MaterialItem material,
    required bool isTradePricingEnabled,
  }) {
    MarketplaceBottomSheet.show(
      context: context,
      title: material.title,
      subtitle: '${material.brand} • ${material.manufacturer}',
      headerTag: const VerifiedBadge(type: VerifiedBadgeType.tradeCertified),
      body: MaterialDetailSheet(
        material: material,
        isTradePricingEnabled: isTradePricingEnabled,
      ),
      bottomBar: _MaterialBottomBar(
        material: material,
        isTradePricingEnabled: isTradePricingEnabled,
      ),
    );
  }

  @override
  State<MaterialDetailSheet> createState() => _MaterialDetailSheetState();
}

class _MaterialDetailSheetState extends State<MaterialDetailSheet> {
  @override
  Widget build(BuildContext context) {
    final mat = widget.material;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              mat.imageUrls.first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                child: const Icon(Icons.layers_rounded, size: 48, color: Colors.grey),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // MOQ and Lead time highlight row
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Minimum Order', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textMuted)),
                    const SizedBox(height: 2),
                    Text(
                      '${mat.minimumOrderQuantity} ${mat.unit.label}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Site Lead Time', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textMuted)),
                    const SizedBox(height: 2),
                    Text(
                      '${mat.leadTimeDays} Business Days',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Description
        Text(
          'Engineering Specification & Usage',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          mat.description,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: textMuted,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        // Certifications
        if (mat.certifications.isNotEmpty) ...[
          Text(
            'Quality Accreditations',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: mat.certifications
                .map((c) => Chip(
                      avatar: const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
                      label: Text(
                        c,
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Technical Specs
        Text(
          'Technical Test Parameters',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        SpecRow(label: 'HSN Tax Code', value: mat.hsnCode, icon: Icons.tag_rounded),
        SpecRow(label: 'GST Slab', value: '${mat.gstPercent.toStringAsFixed(0)}%', icon: Icons.percent_rounded),
        SpecRow(label: 'Origin Depot', value: mat.originCity, icon: Icons.pin_drop_rounded),
        SpecRow(label: 'Stock Availability', value: '${mat.stockAvailable} ${mat.unit.label}', icon: Icons.inventory_2_outlined),

        for (final entry in mat.technicalSpecs.entries)
          SpecRow(label: entry.key, value: entry.value),
      ],
    );
  }
}

class _MaterialBottomBar extends StatefulWidget {
  final MaterialItem material;
  final bool isTradePricingEnabled;

  const _MaterialBottomBar({
    required this.material,
    required this.isTradePricingEnabled,
  });

  @override
  State<_MaterialBottomBar> createState() => _MaterialBottomBarState();
}

class _MaterialBottomBarState extends State<_MaterialBottomBar> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.material.minimumOrderQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final mat = widget.material;
    final unitPrice = widget.isTradePricingEnabled ? mat.tradePrice : mat.retailPrice;
    final totalAmount = unitPrice * _quantity;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quantity Stepper Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Quantity (MOQ: ${mat.minimumOrderQuantity}):',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            QuantitySelector(
              quantity: _quantity,
              minQuantity: mat.minimumOrderQuantity,
              maxQuantity: mat.stockAvailable,
              step: mat.unit == MaterialUnit.bag || mat.unit == MaterialUnit.piece ? 10 : 50,
              unitLabel: mat.unit.symbol,
              onChanged: (val) => setState(() => _quantity = val),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Action & Pricing Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.isTradePricingEnabled ? 'Trade Batch Total' : 'Batch Total',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  PriceDisplay(
                    price: totalAmount,
                    originalPrice: widget.isTradePricingEnabled ? (mat.retailPrice * _quantity) : null,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                CartService().addItem(
                  productId: mat.id,
                  title: mat.title,
                  imageUrl: mat.imageUrls.first,
                  unitPrice: unitPrice,
                  category: MarketplaceCategory.materials,
                  variant: '${mat.brand} (${mat.unit.symbol})',
                  quantity: _quantity,
                  unit: mat.unit,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF10B981),
                    content: Text(
                      'Added $_quantity ${mat.unit.label} of ${mat.title} to order',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
              label: Text(
                'Add to Site Order',
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
        ),
      ],
    );
  }
}
