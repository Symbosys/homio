import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';

class PoDocumentPreview extends StatelessWidget {
  final PurchaseOrder po;
  final VoidCallback? onPrint;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onShareWhatsApp;

  const PoDocumentPreview({
    super.key,
    required this.po,
    this.onPrint,
    this.onDownloadPdf,
    this.onShareWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 820),
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.apartment_rounded,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'HOMIO',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Homio Interiors & Project Operations Pvt Ltd',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Tower B, DLF Cyber City, Phase 2, Gurugram, HR - 122002\nGSTIN: 06AABCH9910K1ZV | CIN: U74999HR2023PTC109811',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PURCHASE ORDER',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        po.poNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Date: ${_formatDate(po.poDate)}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      Text(
                        'Ref RFQ: ${po.rfqNumber}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 36),

              // Vendor & Project Context 2-column layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor Billing Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VENDOR DETAILS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          po.vendorLegalName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        Text('Code: ${po.vendorCode} • GSTIN: ${po.gstin}',
                            style: const TextStyle(fontSize: 11)),
                        Text('Attn: ${po.vendorContactPerson}',
                            style: const TextStyle(fontSize: 11)),
                        Text('Mobile: ${po.vendorMobile} | ${po.vendorEmail}',
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Project Delivery Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SHIP TO / PROJECT SITE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          po.projectName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        Text('Client: ${po.customerName}', style: const TextStyle(fontSize: 11)),
                        Text('Site: ${po.siteAddress}', style: const TextStyle(fontSize: 11)),
                        Text(
                          'Expected Delivery: ${_formatDate(po.expectedDeliveryDate)} (${po.preferredDeliveryTime})',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Line Items Table
              Table(
                border: TableBorder.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 0.8,
                ),
                columnWidths: const {
                  0: FixedColumnWidth(36),
                  1: FlexColumnWidth(4),
                  2: FlexColumnWidth(2),
                  3: FixedColumnWidth(60),
                  4: FixedColumnWidth(75),
                  5: FixedColumnWidth(85),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    ),
                    children: const [
                      _Cell('#', isHeader: true),
                      _Cell('Item & Technical Specification', isHeader: true),
                      _Cell('Brand / Code', isHeader: true),
                      _Cell('Qty', isHeader: true, alignRight: true),
                      _Cell('Rate (₹)', isHeader: true, alignRight: true),
                      _Cell('Amount (₹)', isHeader: true, alignRight: true),
                    ],
                  ),
                  ...po.items.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return TableRow(
                      children: [
                        _Cell('${idx + 1}', alignCenter: true),
                        _Cell('${item.itemName}\n${item.specification}'),
                        _Cell(item.itemCode),
                        _Cell('${item.quantity.toStringAsFixed(0)} ${item.unit}',
                            alignRight: true),
                        _Cell(item.rate.toStringAsFixed(0), alignRight: true),
                        _Cell(item.amount.toStringAsFixed(0),
                            alignRight: true, isBold: true),
                      ],
                    );
                  }),
                ],
              ),
              const SizedBox(height: 18),

              // Commercial Financial Breakdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PAYMENT & DELIVERY TERMS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(po.paymentTerms, style: const TextStyle(fontSize: 11)),
                        const SizedBox(height: 8),
                        Text(
                          'Instructions: ${po.deliveryInstructions}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Terms & Conditions:\n${po.termsAndConditions}',
                          style: TextStyle(
                            fontSize: 9,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow('Subtotal', po.grandTotal - po.tax - po.freight),
                          _SummaryRow('Freight & Transport', po.freight),
                          _SummaryRow('GST (18%)', po.tax),
                          const Divider(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Grand Total',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                              Text(
                                '₹${po.grandTotal.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          _SummaryRow('Advance Due (50%)', po.advanceAmount, isHighlight: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Signatures & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Prepared By:', style: TextStyle(fontSize: 10)),
                      const SizedBox(height: 20),
                      Text('${po.procurementOwner} (Procurement Head)',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
                      const Text('Homio Operations Private Limited', style: TextStyle(fontSize: 9)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Authorized Acceptance & Seal:', style: TextStyle(fontSize: 10)),
                      const SizedBox(height: 20),
                      Text(po.vendorLegalName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
                      const Text('Sign & Stamp with Date', style: TextStyle(fontSize: 9)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Toolbar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: onPrint,
                    icon: const Icon(Icons.print_outlined, size: 16),
                    label: const Text('Print PO'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: onShareWhatsApp,
                    icon: const Icon(Icons.send_to_mobile_rounded, size: 16),
                    label: const Text('WhatsApp to Vendor'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: onDownloadPdf,
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Download PDF'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}';
  }

  static String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isBold;
  final bool alignRight;
  final bool alignCenter;

  const _Cell(
    this.text, {
    this.isHeader = false,
    this.isBold = false,
    this.alignRight = false,
    this.alignCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text(
        text,
        textAlign: alignRight
            ? TextAlign.right
            : alignCenter
                ? TextAlign.center
                : TextAlign.left,
        style: TextStyle(
          fontSize: isHeader ? 10 : 11,
          fontWeight: isHeader
              ? FontWeight.w800
              : (isBold ? FontWeight.w700 : FontWeight.w500),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isHighlight;

  const _SummaryRow(this.label, this.amount, {this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: isHighlight ? FontWeight.w700 : FontWeight.normal,
                  color: isHighlight ? AppColors.primary : null)),
          Text('₹${amount.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
                  color: isHighlight ? AppColors.primary : null)),
        ],
      ),
    );
  }
}
