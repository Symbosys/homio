import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';

/// Modal shopping cart drawer with checkout flow
class CartSheet extends StatefulWidget {
  const CartSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CartSheet(),
    );
  }

  @override
  State<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<CartSheet> {
  final TextEditingController _addressController = TextEditingController(
    text: 'Penthouse B-1402, Embassy Boulevard, Bengaluru 560064',
  );
  String _selectedPaymentMethod = 'UPI / NetBanking';
  bool _isCheckingOut = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _handleCheckout(CartService cart) async {
    if (cart.isEmpty) return;
    setState(() => _isCheckingOut = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    final newOrder = OrderService().placeOrderFromCart(
      cart: cart,
      deliveryAddress: _addressController.text.trim(),
      paymentMethod: _selectedPaymentMethod,
    );

    setState(() => _isCheckingOut = false);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Order placed successfully! #${newOrder.orderNumber}',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () => context.go('/client/marketplace/orders'),
              child: Text(
                'VIEW',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return ListenableBuilder(
      listenable: CartService(),
      builder: (context, _) {
        final cart = CartService();
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              // Grab handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: Color(0xFF10B981), size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'Shopping Cart (${cart.itemCount})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (!cart.isEmpty)
                      TextButton(
                        onPressed: () => cart.clearCart(),
                        child: Text(
                          'Clear All',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFEF4444),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Divider(color: border, height: 1),

              // Content
              if (cart.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.remove_shopping_cart_outlined, size: 60, color: textMuted),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Discover digital guides, materials & curated home decor',
                          style: GoogleFonts.plusJakartaSans(color: textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Cart Item List
                      for (final item in cart.items)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 64,
                                    height: 64,
                                    color: border,
                                    child: const Icon(Icons.broken_image_rounded, size: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary,
                                      ),
                                    ),
                                    if (item.variant != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        item.variant!,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: textMuted,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 6),
                                    Text(
                                      item.formattedUnitPrice,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity controls
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        iconSize: 18,
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () => cart.updateQuantity(item.id, item.quantity - 1),
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        iconSize: 18,
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () => cart.updateQuantity(item.id, item.quantity + 1),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    item.formattedSubtotal,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 12),
                      // Delivery details
                      Text(
                        'Delivery Address',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _addressController,
                        maxLines: 2,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Enter complete site/residential delivery address',
                          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: textMuted),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Payment option
                      Text(
                        'Payment Method',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedPaymentMethod,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'UPI / NetBanking', child: Text('UPI / NetBanking')),
                          DropdownMenuItem(value: 'HOMIO Credit Ledger', child: Text('HOMIO Credit Ledger')),
                          DropdownMenuItem(value: 'Corporate Credit Card', child: Text('Corporate Credit Card')),
                          DropdownMenuItem(value: 'NEFT / RTGS (Trade)', child: Text('NEFT / RTGS (Trade Invoice)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedPaymentMethod = val);
                        },
                      ),

                      const SizedBox(height: 20),
                      // Cost Summary Table
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow('Items Subtotal', cart.formattedSubtotal, textMuted),
                            const SizedBox(height: 6),
                            _buildSummaryRow('GST (18%)', cart.formattedGstTax, textMuted),
                            const SizedBox(height: 6),
                            _buildSummaryRow('Shipping & Handling', cart.formattedShipping, textMuted),
                            const Divider(height: 16),
                            _buildSummaryRow('Grand Total', cart.formattedGrandTotal, textPrimary, isBold: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Bottom Checkout Action
              if (!cart.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surface,
                    border: Border(top: BorderSide(color: border)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isCheckingOut ? null : () => _handleCheckout(cart),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isCheckingOut
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'Confirm Order • ${cart.formattedGrandTotal}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, Color textColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
