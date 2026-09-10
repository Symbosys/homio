import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_enums.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';
import 'marketplace_status_badge.dart';
import 'order_vendor_assign_dialog.dart';

class OrderDetailWorkspaceModal extends StatefulWidget {
  final MarketplaceOrderEntity order;

  const OrderDetailWorkspaceModal({super.key, required this.order});

  static void show(BuildContext context, MarketplaceOrderEntity order) {
    showDialog(
      context: context,
      builder: (ctx) => OrderDetailWorkspaceModal(order: order),
    );
  }

  @override
  State<OrderDetailWorkspaceModal> createState() => _OrderDetailWorkspaceModalState();
}

class _OrderDetailWorkspaceModalState extends State<OrderDetailWorkspaceModal> with SingleTickerProviderStateMixin {
  final _repo = MarketplaceRepository();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showRefundDialog() {
    final amountCtrl = TextEditingController(text: widget.order.paidAmount.toString());
    final reasonCtrl = TextEditingController(text: 'Customer requested cancellation prior to site dispatch.');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Process Full Order Refund', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Refund will credit back via the original payment gateway reference ${widget.order.paymentGatewayRef}.', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
            const SizedBox(height: 12),
            TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Refund Amount (₹)', isDense: true)),
            const SizedBox(height: 12),
            TextField(controller: reasonCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Reason for Refund', isDense: true)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text) ?? widget.order.paidAmount;
              _repo.processOrderRefund(widget.order.id, amt, reasonCtrl.text.trim());
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refund successfully processed.')));
            },
            child: const Text('Confirm Refund'),
          ),
        ],
      ),
    );
  }

  void _updateStatus(OrderStatus next) {
    _repo.updateOrderStatus(
      widget.order.id,
      next,
      'Homio Logistics Hub, Bangalore',
      'Status transitioned by Operations Admin.',
    );
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order status updated to ${next.label}.')));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Get fresh order from repo
    final currentOrder = _repo.orders.firstWhere((o) => o.id == widget.order.id, orElse: () => widget.order);

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 780),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Enterprise Workspace Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Icon(Icons.shopping_bag_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  currentOrder.orderNumber,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                                ),
                                const SizedBox(width: 8),
                                MarketplaceStatusBadge.orderType(currentOrder.orderType, isSmall: true),
                                const SizedBox(width: 6),
                                MarketplaceStatusBadge.order(currentOrder.orderStatus, isSmall: true),
                                const SizedBox(width: 6),
                                MarketplaceStatusBadge.payment(currentOrder.paymentStatus, isSmall: true),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Customer: ${currentOrder.customerName} (${currentOrder.customerMobile}) • Total: ₹${currentOrder.totalAmount.toStringAsFixed(2)}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Quick Action Toolbar
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => OrderVendorAssignDialog.show(context, currentOrder),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.storefront_rounded, size: 14),
                        label: Text(
                          currentOrder.assignedVendorName != null ? 'Reassign Vendor' : 'Assign Vendor',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _updateStatus(OrderStatus.delivered),
                        style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                        icon: const Icon(Icons.check_circle_outline_rounded, size: 14),
                        label: Text('Mark Delivered', style: GoogleFonts.plusJakartaSans(fontSize: 11.5)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _showRefundDialog,
                        style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, foregroundColor: const Color(0xFFEF4444)),
                        icon: const Icon(Icons.currency_exchange_rounded, size: 14),
                        label: Text('Process Refund', style: GoogleFonts.plusJakartaSans(fontSize: 11.5)),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Official Tax Invoice generated & downloaded.')));
                        },
                        style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                        icon: const Icon(Icons.receipt_long_rounded, size: 14),
                        label: Text('Download Invoice', style: GoogleFonts.plusJakartaSans(fontSize: 11.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              indicatorColor: AppColors.primary,
              labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
              tabs: const [
                Tab(text: '1. Overview'),
                Tab(text: '2. Line Items'),
                Tab(text: '3. Vendor Allocation'),
                Tab(text: '4. Delivery & Fleet'),
                Tab(text: '5. Event Timeline'),
                Tab(text: '6. Refunds & Audit'),
              ],
            ),

            // Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(currentOrder, isDark),
                  _buildLineItemsTab(currentOrder, isDark),
                  _buildVendorTab(currentOrder, isDark),
                  _buildDeliveryTab(currentOrder, isDark),
                  _buildTimelineTab(currentOrder, isDark),
                  _buildRefundsTab(currentOrder, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(MarketplaceOrderEntity o, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer Information (Customer 360)', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      const SizedBox(height: 8),
                      _field('Customer Name', o.customerName),
                      _field('Phone Number', o.customerMobile),
                      _field('Email Address', o.customerEmail),
                      _field('Delivery Address', '${o.deliveryAddress}, ${o.city} - ${o.pinCode}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                    borderRadius: AppRadius.sm,
                    border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Commercial Accounting Summary', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                      const SizedBox(height: 8),
                      _field('Subtotal Amount', '₹${o.subtotal.toStringAsFixed(2)}'),
                      _field('Commercial Discount', '-₹${o.discountAmount.toStringAsFixed(2)}'),
                      _field('GST Tax (18%)', '₹${o.taxAmount.toStringAsFixed(2)}'),
                      const Divider(),
                      _field('Gross Paid Amount', '₹${o.paidAmount.toStringAsFixed(2)}', isBold: true),
                      _field('Payment Mode', '${o.paymentMethod} (Ref: ${o.paymentGatewayRef})'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Internal Operations Notes', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(o.internalAdminNotes.isNotEmpty ? o.internalAdminNotes : 'No internal operational flags.', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildLineItemsTab(MarketplaceOrderEntity o, bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: o.items.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        final item = o.items[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.sm,
            border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.sm,
                child: Image.network(item.productImageUrl, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, err, stack) => const Icon(Icons.inventory_2_rounded)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                    Text('SKU: ${item.productSku} • Supplier: ${item.vendorName ?? "Direct Homio"}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${item.totalPrice.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                  Text('${item.quantity} ${item.unit} @ ₹${item.unitPrice.toStringAsFixed(2)}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVendorTab(MarketplaceOrderEntity o, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Allocated Fulfillment Supplier', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
                    ElevatedButton(
                      onPressed: () => OrderVendorAssignDialog.show(context, o),
                      style: ElevatedButton.styleFrom(visualDensity: VisualDensity.compact),
                      child: const Text('Change Vendor Allocation'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _field('Assigned Vendor Name', o.assignedVendorName ?? 'No supplier currently assigned.'),
                _field('Vendor ID Link', o.assignedVendorId ?? 'None'),
                _field('Vendor Confirmation Date', o.vendorConfirmedAt != null ? '${o.vendorConfirmedAt}' : 'Pending acknowledgment'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTab(MarketplaceOrderEntity o, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Logistics & Delivery Fleet Assignment', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _field('Delivery Status', o.deliveryStatus.label),
                _field('Assigned Fleet Partner', o.assignedDeliveryPartner ?? 'Awaiting dispatch assignment'),
                _field('Driver / Dispatch Contact', o.deliveryPartnerContact ?? 'N/A'),
                _field('Estimated Site Arrival (ETA)', o.estimatedDeliveryAt != null ? '${o.estimatedDeliveryAt}' : 'Today 4:00 PM'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab(MarketplaceOrderEntity o, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: o.trackingTimeline.length,
      itemBuilder: (ctx, i) {
        final ev = o.trackingTimeline[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  ),
                  if (i < o.trackingTimeline.length - 1)
                    Container(width: 2, height: 40, color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ev.eventName, style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                        Text('${ev.timestamp.day}/${ev.timestamp.month} ${ev.timestamp.hour}:${ev.timestamp.minute.toString().padLeft(2, '0')}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8))),
                      ],
                    ),
                    Text(ev.notes, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    Text('Location: ${ev.location} • By ${ev.executedBy}', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: const Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRefundsTab(MarketplaceOrderEntity o, bool isDark) {
    if (o.refundRecord == null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_outlined, size: 48, color: Color(0xFF10B981)),
              const SizedBox(height: 12),
              Text('No refund requests or dispute claims on this transaction.', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: _showRefundDialog,
                icon: const Icon(Icons.currency_exchange_rounded, size: 16),
                label: const Text('Initiate Full Order Refund'),
              ),
            ],
          ),
        ),
      );
    }

    final r = o.refundRecord!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
          borderRadius: AppRadius.md,
          border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Order Refund Dossier', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFEF4444))),
            const SizedBox(height: 12),
            _field('Refund ID', r.refundId),
            _field('Refund Amount', '₹${r.refundAmount.toStringAsFixed(2)}'),
            _field('Reason for Refund', r.reason),
            _field('Settlement Status', r.refundStatus),
            _field('Gateway Reference', r.gatewayReference),
            _field('Approved By Lead', r.approvedBy),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF94A3B8))),
          Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
        ],
      ),
    );
  }
}
