import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';
import 'procurement_status_badge.dart';

class SiteReceiptModal extends StatefulWidget {
  final MaterialDispatch dispatch;
  final ValueChanged<List<SiteReceiptItem>> onSaveReceipt;

  const SiteReceiptModal({
    super.key,
    required this.dispatch,
    required this.onSaveReceipt,
  });

  @override
  State<SiteReceiptModal> createState() => _SiteReceiptModalState();
}

class _SiteReceiptModalState extends State<SiteReceiptModal> {
  late List<SiteReceiptItem> _checklist;
  final TextEditingController _deliveryNoteCtrl =
      TextEditingController(text: 'DN-2026-8812');
  final TextEditingController _receivedByCtrl =
      TextEditingController(text: 'Rajesh Verma (Site Engg)');
  final TextEditingController _remarksCtrl =
      TextEditingController(text: 'Verified at site staging area.');
  bool _hasPhotoProof = true;

  @override
  void initState() {
    super.initState();
    if (widget.dispatch.receiptChecklist != null &&
        widget.dispatch.receiptChecklist!.isNotEmpty) {
      _checklist = List.from(widget.dispatch.receiptChecklist!);
    } else {
      _checklist = widget.dispatch.items.map((item) {
        return SiteReceiptItem(
          itemName: item.itemName,
          dispatchedQuantity: item.currentDispatchQuantity,
          quantityReceived: item.currentDispatchQuantity,
          quantityAccepted: item.currentDispatchQuantity,
          quantityRejected: 0,
          shortQuantity: 0,
          damagedQuantity: 0,
          condition: MaterialItemCondition.good,
          remarks: 'Inspected on arrival.',
        );
      }).toList();
    }
  }

  @override
  void dispose() {
    _deliveryNoteCtrl.dispose();
    _receivedByCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  void _updateItem(int index, SiteReceiptItem updated) {
    setState(() {
      _checklist[index] = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 820,
        constraints: const BoxConstraints(maxHeight: 720),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fact_check_rounded,
                        color: AppColors.success, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Site Material Delivery & QA Inspection',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Dispatch: ${widget.dispatch.dispatchNumber} • PO: ${widget.dispatch.poNumber} • ${widget.dispatch.projectName}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Details Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _receivedByCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Received & Inspected By *',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _deliveryNoteCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Delivery Note / Challan # *',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, size: 16),
                              const SizedBox(width: 6),
                              Text(widget.dispatch.vehicleNumber,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Material Item Checklist
                    Text(
                      'Material Arrival Checklist (${_checklist.length} Items)',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _checklist.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _checklist[index];
                        return _buildItemInspectionCard(context, index, item, isDark, theme);
                      },
                    ),
                    const SizedBox(height: 20),

                    // General Remarks & Site Photos
                    TextFormField(
                      controller: _remarksCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Site Inspection Notes & Snag Observations',
                        hintText: 'e.g. Verified waterproof seal, 1 box transit damage noted.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Photo Proof and Signature Row
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _hasPhotoProof ? Icons.check_circle_rounded : Icons.photo_camera_outlined,
                            color: _hasPhotoProof ? AppColors.success : AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Delivery Challan Photo & Unloading Proof',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                                Text(
                                  _hasPhotoProof
                                      ? 'Photo proof attached (CAM-DSP-RECEIPT-IMG-01.jpg)'
                                      : 'Tap to upload site photo or physical challan copy',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() => _hasPhotoProof = !_hasPhotoProof);
                            },
                            icon: Icon(_hasPhotoProof ? Icons.delete_outline : Icons.upload_rounded,
                                size: 14),
                            label: Text(_hasPhotoProof ? 'Remove' : 'Upload Photo',
                                style: const TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () {
                      widget.onSaveReceipt(_checklist);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.verified_rounded, size: 16),
                    label: const Text('Confirm Site Acceptance & Save'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemInspectionCard(
    BuildContext context,
    int index,
    SiteReceiptItem item,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.itemName,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
              ProcurementStatusBadge.itemCondition(item.condition),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Dispatched: ${item.dispatchedQuantity.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 110,
                child: TextFormField(
                  initialValue: item.quantityAccepted.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'Accepted Qty',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    final acc = double.tryParse(val) ?? item.quantityAccepted;
                    _updateItem(index, SiteReceiptItem(
                      itemName: item.itemName,
                      dispatchedQuantity: item.dispatchedQuantity,
                      quantityReceived: item.quantityReceived,
                      quantityAccepted: acc,
                      quantityRejected: item.quantityRejected,
                      shortQuantity: item.shortQuantity,
                      damagedQuantity: item.damagedQuantity,
                      condition: item.condition,
                      remarks: item.remarks,
                    ));
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 110,
                child: TextFormField(
                  initialValue: item.damagedQuantity.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w700, fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'Damaged Qty',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    final dam = double.tryParse(val) ?? item.damagedQuantity;
                    _updateItem(index, SiteReceiptItem(
                      itemName: item.itemName,
                      dispatchedQuantity: item.dispatchedQuantity,
                      quantityReceived: item.quantityReceived,
                      quantityAccepted: item.quantityAccepted,
                      quantityRejected: item.quantityRejected,
                      shortQuantity: item.shortQuantity,
                      damagedQuantity: dam,
                      condition: dam > 0 ? MaterialItemCondition.damaged : item.condition,
                      remarks: item.remarks,
                    ));
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Condition selector
              DropdownButton<MaterialItemCondition>(
                value: item.condition,
                isDense: true,
                items: MaterialItemCondition.values.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c.label, style: const TextStyle(fontSize: 12)));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    _updateItem(index, SiteReceiptItem(
                      itemName: item.itemName,
                      dispatchedQuantity: item.dispatchedQuantity,
                      quantityReceived: item.quantityReceived,
                      quantityAccepted: item.quantityAccepted,
                      quantityRejected: item.quantityRejected,
                      shortQuantity: item.shortQuantity,
                      damagedQuantity: item.damagedQuantity,
                      condition: val,
                      remarks: item.remarks,
                    ));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
