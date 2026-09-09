import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';

class ServiceEstimatePaymentModal extends StatefulWidget {
  final ServiceRequest request;
  final ValueChanged<ServiceEstimate> onEstimateSaved;

  const ServiceEstimatePaymentModal({
    super.key,
    required this.request,
    required this.onEstimateSaved,
  });

  @override
  State<ServiceEstimatePaymentModal> createState() => _ServiceEstimatePaymentModalState();
}

class _ServiceEstimatePaymentModalState extends State<ServiceEstimatePaymentModal> {
  final List<EstimateItem> _items = [
    const EstimateItem(
      description: 'Site Inspection & Problem Diagnosis',
      quantity: 1,
      unit: 'Visit',
      rate: 500.0,
      labourCost: 0,
      materialCost: 0,
      isWarrantyWaived: true, // Waived
    ),
    const EstimateItem(
      description: 'OEM Replacement Hardware Part',
      quantity: 1,
      unit: 'Set',
      rate: 1800.0,
      labourCost: 800.0,
      materialCost: 1000.0,
      isWarrantyWaived: false,
    ),
  ];

  final double _discount = 200.0;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    final gross = _items.fold(0.0, (sum, i) => sum + i.billableAmount);
    final net = (gross - _discount).clamp(0.0, double.infinity);
    final gst = net * 0.18;
    final total = net + gst;

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 700,
        height: 640,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.receipt_long_rounded, color: Colors.green, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Commercial Estimate & WhatsApp Payment Link', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                        Text('${widget.request.requestNumber} • ${widget.request.customerName} (${widget.request.projectName})', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                      ],
                    ),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Itemization Table
                    Text('Billable Line Items & Warranty Waivers', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _items.length,
                        separatorBuilder: (context, index) => Divider(height: 1, color: borderColor),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.description, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimaryColor)),
                                      Text('Qty: ${item.quantity} ${item.unit} @ ₹${item.rate}', style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                                    ],
                                  ),
                                ),
                                if (item.isWarrantyWaived)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('WARRANTY WAIVED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.green)),
                                  ),
                                const SizedBox(width: 14),
                                Text(
                                  item.isWarrantyWaived ? '₹0.00' : '₹${item.billableAmount.toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: item.isWarrantyWaived ? Colors.green : textPrimaryColor),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Financial Summary Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('Gross Billable Subtotal', '₹${gross.toStringAsFixed(2)}', textPrimaryColor, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Customer Goodwill Discount', '-₹${_discount.toStringAsFixed(2)}', Colors.green, textSecondaryColor),
                          const SizedBox(height: 8),
                          _buildSummaryRow('GST (18% Applicable Tax)', '₹${gst.toStringAsFixed(2)}', textPrimaryColor, textSecondaryColor),
                          const Divider(height: 16),
                          _buildSummaryRow('Total Customer Payable', '₹${total.toStringAsFixed(2)}', AppColors.primary, textPrimaryColor, isBold: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // WhatsApp Payment Link Generator
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.qr_code_rounded, color: Color(0xFF25D366), size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Instant Razorpay/UPI Payment Link Active', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFF047857))),
                                Text(
                                  'https://pay.homio.in/srv/${widget.request.requestNumber.toLowerCase()}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF065F46)),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Payment link dispatched via WhatsApp to ${widget.request.customerPhone}')),
                              );
                            },
                            icon: const Icon(Icons.send_rounded, size: 14),
                            label: const Text('Send via WhatsApp'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isProcessing
                      ? null
                      : () {
                          final nav = Navigator.of(context);
                          setState(() => _isProcessing = true);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            final est = ServiceEstimate(
                              id: 'EST-${DateTime.now().millisecondsSinceEpoch}',
                              estimateNumber: 'EST-${widget.request.requestNumber}',
                              serviceRequestId: widget.request.id,
                              customerName: widget.request.customerName,
                              projectName: widget.request.projectName,
                              items: _items,
                              discount: _discount,
                              taxRate: 0.18,
                              generatedDate: DateTime.now(),
                              validityDate: DateTime.now().add(const Duration(days: 14)),
                              isApprovedByCustomer: true,
                              paymentLink: 'https://pay.homio.in/srv/${widget.request.requestNumber.toLowerCase()}',
                            );
                            widget.onEstimateSaved(est);
                            nav.pop();
                          });
                        },
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('AUTHORIZE ESTIMATE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valColor, Color labelColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.w800 : FontWeight.w500, color: labelColor)),
        Text(value, style: TextStyle(fontSize: isBold ? 14 : 12, fontWeight: isBold ? FontWeight.w900 : FontWeight.w700, color: valColor)),
      ],
    );
  }
}
