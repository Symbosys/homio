// Homio CRM — Printable A4 Invoice Document Preview Studio

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/accounting_models.dart';

class InvoiceDocumentPreview extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback? onPrint;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onShareWhatsApp;

  const InvoiceDocumentPreview({
    super.key,
    required this.invoice,
    this.onPrint,
    this.onDownloadPdf,
    this.onShareWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: Container(
          width: 800,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Action Toolbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'TAX INVOICE — ${invoice.invoiceNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (onShareWhatsApp != null)
                          TextButton.icon(
                            onPressed: onShareWhatsApp,
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Color(0xFF22C55E)),
                            label: const Text('WhatsApp', style: TextStyle(color: Color(0xFF22C55E), fontSize: 12)),
                          ),
                        if (onDownloadPdf != null)
                          TextButton.icon(
                            onPressed: onDownloadPdf,
                            icon: const Icon(Icons.download_rounded, size: 14, color: Colors.white70),
                            label: const Text('Download PDF', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ),
                        if (onPrint != null)
                          TextButton.icon(
                            onPressed: onPrint,
                            icon: const Icon(Icons.print_rounded, size: 14, color: Colors.white70),
                            label: const Text('Print A4', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // A4 Document Content
              Padding(
                padding: const EdgeInsets.all(36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Homio Corporate Header
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
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4F46E5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'HOMIO',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Homio Technologies & Turnkey Interiors Pvt. Ltd.',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                            ),
                            const Text(
                              'Level 5, DLF Horizon Center, Golf Course Road, Gurugram, HR - 122002',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                            const Text(
                              'GSTIN: 06AABCH9920K1ZM | PAN: AABCH9920K',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFFC7D2FE)),
                              ),
                              child: Text(
                                invoice.invoiceType.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF4338CA),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              invoice.invoiceNumber,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Date: ${invoice.invoiceDate.day}/${invoice.invoiceDate.month}/${invoice.invoiceDate.year}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                            Text(
                              'Due Date: ${invoice.dueDate.day}/${invoice.dueDate.month}/${invoice.dueDate.year}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 36, color: Color(0xFFE2E8F0)),

                    // Billed To & Project Information
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BILLED TO (CLIENT)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                invoice.customerName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                invoice.billingAddress,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                              ),
                              Text(
                                'Phone: ${invoice.customerPhone} • Email: ${invoice.customerEmail}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                              if (invoice.customerGstin != null)
                                Text(
                                  'GSTIN: ${invoice.customerGstin}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PROJECT & EXECUTION SITE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                invoice.projectName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                invoice.siteAddress,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                              ),
                              if (invoice.referenceQuotationNo != null)
                                Text(
                                  'Ref Quotation: ${invoice.referenceQuotationNo}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              Text(
                                'Payment Terms: ${invoice.paymentTerms}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Line Items Table
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            color: const Color(0xFFF8FAFC),
                            child: const Row(
                              children: [
                                SizedBox(width: 30, child: Text('#', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF475569)))),
                                Expanded(flex: 4, child: Text('ITEM & SPECIFICATION', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF475569)))),
                                Expanded(flex: 1, child: Text('ROOM / AREA', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF475569)))),
                                SizedBox(width: 60, child: Text('QTY', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF475569)))),
                                SizedBox(width: 80, child: Text('RATE (₹)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF475569)))),
                                SizedBox(width: 90, child: Text('AMOUNT (₹)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF475569)))),
                              ],
                            ),
                          ),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          ...invoice.items.asMap().entries.map((entry) {
                            final idx = entry.key + 1;
                            final itm = entry.value;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: const Color(0xFFF1F5F9), width: 1)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 30, child: Text('$idx', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(itm.itemName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF0F172A))),
                                        Text(itm.description, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(itm.roomArea, style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Text('${itm.quantity.toStringAsFixed(0)} ${itm.unit}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A))),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text('₹${itm.rate.toStringAsFixed(0)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A))),
                                  ),
                                  SizedBox(
                                    width: 90,
                                    child: Text('₹${itm.subtotal.toStringAsFixed(0)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF0F172A))),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Summary & Tax Breakdown Box
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banking & Notes
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'BANK PAYMENT DETAILS FOR WIRE TRANSFER',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: Color(0xFF334155), letterSpacing: 0.5),
                                ),
                                const SizedBox(height: 6),
                                const Text('Account Name: Homio Technologies Pvt Ltd', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                const Text('Bank: HDFC Bank Ltd, DLF Phase 5 Branch', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                const Text('Current A/C No: 50200088192019', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                                const Text('IFSC Code: HDFC0000281', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                                const SizedBox(height: 8),
                                Text(invoice.notes, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Totals Table
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildDocRow('Subtotal', '₹${invoice.subtotal.toStringAsFixed(0)}'),
                              if (invoice.discount > 0)
                                _buildDocRow('Discount', '-₹${invoice.discount.toStringAsFixed(0)}', isDeduction: true),
                              _buildDocRow('Taxable Amount', '₹${invoice.taxableAmount.toStringAsFixed(0)}'),
                              _buildDocRow('GST (18%)', '₹${invoice.taxAmount.toStringAsFixed(0)}'),
                              if (invoice.additionalCharges > 0)
                                _buildDocRow('Other Charges', '₹${invoice.additionalCharges.toStringAsFixed(0)}'),
                              const Divider(height: 12, color: Color(0xFFCBD5E1)),
                              _buildDocRow('Grand Total', '₹${invoice.grandTotal.toStringAsFixed(0)}', isBold: true, fontSize: 14),
                              const SizedBox(height: 4),
                              _buildDocRow('Amount Paid', '₹${invoice.paidAmount.toStringAsFixed(0)}', color: const Color(0xFF10B981)),
                              _buildDocRow('Current Outstanding', '₹${invoice.outstandingAmount.toStringAsFixed(0)}', isBold: true, color: const Color(0xFFEF4444)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Signatures
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Authorized Signatory — Homio Accounts',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                        ),
                        Container(
                          width: 180,
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Container(height: 1, color: const Color(0xFF94A3B8)),
                              const SizedBox(height: 4),
                              const Text('For Homio Technologies Pvt Ltd', style: TextStyle(fontSize: 10, color: Color(0xFF475569))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocRow(String label, String value, {bool isBold = false, double fontSize = 11, bool isDeduction = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: const Color(0xFF475569))),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: color ?? (isDeduction ? Colors.red : const Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }
}
