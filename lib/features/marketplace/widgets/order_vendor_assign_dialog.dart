import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';

class OrderVendorAssignDialog extends StatefulWidget {
  final MarketplaceOrderEntity order;

  const OrderVendorAssignDialog({super.key, required this.order});

  static void show(BuildContext context, MarketplaceOrderEntity order) {
    showDialog(
      context: context,
      builder: (ctx) => OrderVendorAssignDialog(order: order),
    );
  }

  @override
  State<OrderVendorAssignDialog> createState() => _OrderVendorAssignDialogState();
}

class _OrderVendorAssignDialogState extends State<OrderVendorAssignDialog> {
  final _repo = MarketplaceRepository();

  final List<Map<String, dynamic>> _eligibleVendors = [
    {
      'id': 'VND-001',
      'name': 'Karnataka Plywood & Timber Distributors Ltd.',
      'region': 'Bangalore South Hub (8.2 km)',
      'rating': 4.88,
      'avgResponse': '12 mins',
      'inStock': true,
      'status': 'Preferred Primary Supplier',
    },
    {
      'id': 'VND-002',
      'name': 'Sri Balaji Wood Works Wholesale',
      'region': 'Bangalore North Hub (14.5 km)',
      'rating': 4.65,
      'avgResponse': '24 mins',
      'inStock': true,
      'status': 'Secondary Supplier',
    },
    {
      'id': 'VND-004',
      'name': 'Apex Building Solutions LLP',
      'region': 'Electronic City Hub (11.0 km)',
      'rating': 4.72,
      'avgResponse': '18 mins',
      'inStock': true,
      'status': 'Registered Vendor',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 580),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: AppRadius.sm),
                    child: Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fulfillment Vendor Assignment Workspace', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                        Text('Order: ${widget.order.orderNumber} • Destination: ${widget.order.city}', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Eligible Regional Registered Suppliers', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
              const SizedBox(height: 8),

              Expanded(
                child: ListView.separated(
                  itemCount: _eligibleVendors.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final v = _eligibleVendors[i];
                    final isCurrent = widget.order.assignedVendorId == v['id'];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.sm,
                        border: Border.all(
                          color: isCurrent ? AppColors.primary : (isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                          width: isCurrent ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(v['name'], style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                                    if (isCurrent) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: AppRadius.sm),
                                        child: Text('CURRENT', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text('${v['region']} • Rating: ★ ${v['rating']} • Avg Response: ${v['avgResponse']}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                                Text(v['status'], style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _repo.assignOrderVendor(widget.order.id, v['id'], v['name']);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order allocated to ${v['name']}.')));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCurrent ? Colors.grey : AppColors.primary,
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(isCurrent ? 'Reassign' : 'Allocate Order', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
