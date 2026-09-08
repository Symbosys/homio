import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';

class DecorItemCard extends StatelessWidget {
  final DecorItem? decorItem;
  final MaterialItem? materialItem;
  final VoidCallback onAction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DecorItemCard.decor({
    super.key,
    required DecorItem item,
    required this.onAction,
    this.onEdit,
    this.onDelete,
  })  : decorItem = item,
        materialItem = null;

  const DecorItemCard.material({
    super.key,
    required MaterialItem item,
    required this.onAction,
    this.onEdit,
    this.onDelete,
  })  : materialItem = item,
        decorItem = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final isDecor = decorItem != null;

    final title = isDecor ? decorItem!.title : materialItem!.name;
    final brand = isDecor ? decorItem!.brand : materialItem!.brand;
    final imageUrl = isDecor ? decorItem!.imageUrl : materialItem!.imageUrl;
    final price = isDecor ? decorItem!.price : materialItem!.wholesalePrice;
    final originalPrice = isDecor ? decorItem!.originalPrice : materialItem!.retailMrp;
    final discount = isDecor ? decorItem!.discountPercent : materialItem!.savingsPercent;
    final rating = isDecor ? decorItem!.rating : materialItem!.rating;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                      child: Icon(
                        isDecor ? Icons.chair_rounded : Icons.layers_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              // Partner / Category Tag
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDecor
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isDecor ? decorItem!.affiliatePartner : materialItem!.category.label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Discount Tag
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${discount.toInt()}% ${isDecor ? 'OFF' : 'SAVINGS'}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),

                  if (isDecor) ...[
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 3),
                        Text(
                          '$rating (${decorItem!.reviewsCount})',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textPrimaryColor),
                        ),
                        const Spacer(),
                        Text(
                          '${decorItem!.leadTimeDays} Days Delivery',
                          style: TextStyle(fontSize: 11, color: textSecondaryColor),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      'Trade Unit: ${materialItem!.tradeUnit}',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondaryColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'MOQ: ${materialItem!.minOrderQuantity} • ${materialItem!.stockAvailable}',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.w600),
                    ),
                  ],

                  const Spacer(),
                  Divider(height: 1, color: borderColor),
                  const SizedBox(height: 10),

                  // Pricing & Action
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '₹${price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimaryColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '₹${originalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: textMutedColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            isDecor ? 'Affiliate Partner' : 'Wholesale B2B Rate',
                            style: TextStyle(fontSize: 10, color: textSecondaryColor),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: onAction,
                        icon: Icon(
                          isDecor ? Icons.open_in_new_rounded : Icons.request_quote_rounded,
                          size: 13,
                        ),
                        label: Text(
                          isDecor ? 'View Item' : 'Order RFQ',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDecor ? const Color(0xFF8B5CF6) : AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      if (onEdit != null || onDelete != null) ...[
                        const SizedBox(width: 4),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_rounded, size: 18, color: textSecondaryColor),
                          tooltip: 'Manage Item',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onSelected: (val) {
                            if (val == 'edit') onEdit?.call();
                            if (val == 'delete') onDelete?.call();
                          },
                          itemBuilder: (ctx) => [
                            if (onEdit != null)
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded, size: 16, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(isDecor ? 'Edit Decor Item' : 'Edit Material', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            if (onDelete != null)
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                                    const SizedBox(width: 8),
                                    Text(isDecor ? 'Delete Decor Item' : 'Delete Material', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
