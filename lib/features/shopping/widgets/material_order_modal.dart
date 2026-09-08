import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';

class MaterialOrderModal extends StatefulWidget {
  final MaterialItem item;

  const MaterialOrderModal({
    super.key,
    required this.item,
  });

  @override
  State<MaterialOrderModal> createState() => _MaterialOrderModalState();
}

class _MaterialOrderModalState extends State<MaterialOrderModal> {
  final _formKey = GlobalKey<FormState>();
  late int _quantity;
  final _siteAddressController = TextEditingController(text: 'DLF The Crest, Tower 3, Apt 1402, Sector 54, Gurugram');
  final _contactPersonController = TextEditingController(text: 'Ar. Devika Nair (Site Supervisor)');
  final _contactPhoneController = TextEditingController(text: '+91 98119 44321');
  bool _requestSampleFirst = false;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.minOrderQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final bgColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);
    final textMuted = AppColors.getTextMuted(context);
    final mat = widget.item;

    final totalWholesale = _quantity * mat.wholesalePrice;
    final totalRetail = _quantity * mat.retailMrp;
    final totalSavings = totalRetail - totalWholesale;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 620,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.request_quote_rounded, color: Color(0xFF3B82F6), size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSubmitted ? 'Wholesale Order RFQ Dispatched!' : 'Direct Wholesale Material Procurement RFQ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          'Direct Distributor Pricing • Tax Invoice with Input Credit',
                          style: TextStyle(fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: textSecondary),
                  ),
                ],
              ),
            ),

            // Modal Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _isSubmitted
                    ? _buildSubmittedResult(context, textPrimary, textSecondary, borderColor, bgColor)
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Material Overview Card
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      mat.imageUrl,
                                      width: 65,
                                      height: 65,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 65,
                                        height: 65,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.layers),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mat.brand.toUpperCase(),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary),
                                        ),
                                        Text(
                                          mat.name,
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Supplier: ${mat.supplierName} (${mat.supplierCity})',
                                          style: TextStyle(fontSize: 11, color: textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Quantity Stepper
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Order Quantity (${mat.tradeUnit})', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                                    Text('Minimum Order: ${mat.minOrderQuantity} Units', style: TextStyle(fontSize: 11, color: textSecondary)),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: borderColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: _quantity > mat.minOrderQuantity
                                            ? () => setState(() => _quantity -= 5)
                                            : null,
                                        icon: const Icon(Icons.remove, size: 16),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                        child: Text(
                                          '$_quantity',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => setState(() => _quantity += 5),
                                        icon: const Icon(Icons.add, size: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // Real-time Calculation Breakdown
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Wholesale B2B Rate ($_quantity x ₹${mat.wholesalePrice.toStringAsFixed(0)})', style: TextStyle(fontSize: 11, color: textSecondary)),
                                      Text('₹${totalWholesale.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Retail Market Estimate', style: TextStyle(fontSize: 11, color: textMuted)),
                                      Text('₹${totalRetail.toStringAsFixed(0)}', style: TextStyle(fontSize: 11, decoration: TextDecoration.lineThrough, color: textMuted)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Divider(height: 1, color: borderColor),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Contractor Margin Savings', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                                      Text('Save ₹${totalSavings.toStringAsFixed(0)} (${mat.savingsPercent.toInt()}%)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Site Delivery Info
                            Text(
                              'Project Site Delivery Information',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                            ),
                            const SizedBox(height: 10),

                            TextFormField(
                              controller: _siteAddressController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: 'Site Delivery Address *',
                                prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _contactPersonController,
                                    decoration: InputDecoration(
                                      labelText: 'Receiving Supervisor *',
                                      prefixIcon: const Icon(Icons.person_outline, size: 18),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      filled: true,
                                      fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _contactPhoneController,
                                    decoration: InputDecoration(
                                      labelText: 'Supervisor Mobile *',
                                      prefixIcon: const Icon(Icons.phone_outlined, size: 18),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      filled: true,
                                      fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            CheckboxListTile(
                              value: _requestSampleFirst,
                              onChanged: (v) => setState(() => _requestSampleFirst = v ?? false),
                              title: const Text('Dispatch Physical Material Sample Kit First (Free Courier)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: _isSubmitted
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Done'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estimated Bill', style: TextStyle(fontSize: 11, color: textMuted)),
                            Text(
                              '₹${totalWholesale.toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () => setState(() => _isSubmitted = true),
                              icon: const Icon(Icons.send_rounded, size: 16),
                              label: const Text('Submit Wholesale RFQ', style: TextStyle(fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }

  Widget _buildSubmittedResult(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color bgColor,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.fact_check_rounded, color: Color(0xFF3B82F6), size: 50),
        ),
        const SizedBox(height: 14),
        Text(
          'Procurement RFQ Dispatched!',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Reference ID: HOMIO-RFQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Material', style: TextStyle(fontSize: 12, color: textSecondary)),
                  Text(widget.item.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quantity', style: TextStyle(fontSize: 12, color: textSecondary)),
                  Text('$_quantity Units (${widget.item.tradeUnit})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Assigned Supplier', style: TextStyle(fontSize: 12, color: textSecondary)),
                  Text(widget.item.supplierName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
