import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import 'item_picker_dialog.dart';

/// Accordion card representing a room with dimensions, BOQ item table, and display toggle compliance.
class RoomBoqAccordion extends StatefulWidget {
  final RoomArea room;
  final bool hideRate;
  final bool hideSqft;
  final bool showAmount;
  final ValueChanged<RoomArea> onRoomChanged;
  final VoidCallback onDeleteRoom;

  const RoomBoqAccordion({
    super.key,
    required this.room,
    required this.hideRate,
    required this.hideSqft,
    required this.showAmount,
    required this.onRoomChanged,
    required this.onDeleteRoom,
  });

  @override
  State<RoomBoqAccordion> createState() => _RoomBoqAccordionState();
}

class _RoomBoqAccordionState extends State<RoomBoqAccordion> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accordion Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: _isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(10))
                : BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.meeting_room_rounded, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.room.roomName,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: isDark ? 0.2 : 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.room.tier.title,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.hideSqft
                              ? '${widget.room.items.length} items configured'
                              : 'Dims: ${widget.room.lengthFt.toStringAsFixed(1)}ft × ${widget.room.widthFt.toStringAsFixed(1)}ft × ${widget.room.heightFt.toStringAsFixed(1)}ft • Carpet: ${widget.room.carpetSqft.toStringAsFixed(0)} Sq.Ft • Wall: ${widget.room.wallSqft.toStringAsFixed(0)} Sq.Ft',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showAmount) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Subtotal',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        Text(
                          '₹${widget.room.roomSubtotal.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          if (_isExpanded) ...[
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Dimension Editor Bar (Only if Sqft is not hidden)
            if (!widget.hideSqft)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Dimensions (Ft):',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    _buildDimInput(isDark, 'L', widget.room.lengthFt, (val) {
                      widget.onRoomChanged(widget.room.copyWith(lengthFt: val));
                    }),
                    _buildDimInput(isDark, 'W', widget.room.widthFt, (val) {
                      widget.onRoomChanged(widget.room.copyWith(widthFt: val));
                    }),
                    _buildDimInput(isDark, 'H', widget.room.heightFt, (val) {
                      widget.onRoomChanged(widget.room.copyWith(heightFt: val));
                    }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Carpet: ${widget.room.carpetSqft.toStringAsFixed(0)} Sq.Ft | Wall: ${widget.room.wallSqft.toStringAsFixed(0)} Sq.Ft',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Line Items Table or Cards
            if (widget.room.items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 32,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No line items added to this room yet.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (isMobile)
              _buildMobileItemsList(isDark)
            else
              _buildDesktopItemsTable(isDark),

            // Accordion Footer with Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 0.8,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: widget.onDeleteRoom,
                    icon: const Icon(Icons.delete_outline_rounded, size: 14, color: AppColors.error),
                    label: const Text('Delete Room'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error, width: 0.8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      visualDensity: VisualDensity.compact,
                      textStyle: GoogleFonts.inter(fontSize: 11),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _openItemPicker(context),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Add Item from Master'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      visualDensity: VisualDensity.compact,
                      textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDimInput(bool isDark, String label, double initialVal, ValueChanged<double> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        SizedBox(
          width: 50,
          height: 28,
          child: TextFormField(
            initialValue: initialVal.toStringAsFixed(0),
            keyboardType: TextInputType.number,
            style: GoogleFonts.inter(fontSize: 11),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
            ),
            onChanged: (val) {
              final parsed = double.tryParse(val);
              if (parsed != null && parsed > 0) onChanged(parsed);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopItemsTable(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        horizontalMargin: 14,
        headingRowHeight: 36,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 56,
        headingTextStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        columns: [
          const DataColumn(label: Text('Item & Technical Specs')),
          if (!widget.hideSqft) const DataColumn(label: Text('UOM')),
          const DataColumn(label: Text('Quantity')),
          if (!widget.hideRate) const DataColumn(label: Text('Rate (₹)')),
          if (widget.showAmount) const DataColumn(label: Text('Amount (₹)')),
          const DataColumn(label: Text('Action')),
        ],
        rows: widget.room.items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return DataRow(
            cells: [
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.materialSpecs,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (!widget.hideSqft)
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.uom.symbol,
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
                ),
              DataCell(
                SizedBox(
                  width: 70,
                  height: 30,
                  child: TextFormField(
                    initialValue: item.quantity.toStringAsFixed(1),
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.inter(fontSize: 11),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                    onChanged: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null && parsed >= 0) {
                        _updateItemQuantity(idx, parsed);
                      }
                    },
                  ),
                ),
              ),
              if (!widget.hideRate)
                DataCell(
                  Text(
                    '₹${item.rate.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              if (widget.showAmount)
                DataCell(
                  Text(
                    '₹${item.amount.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success),
                  ),
                ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.error),
                  onPressed: () => _removeItem(idx),
                  splashRadius: 14,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileItemsList(bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: widget.room.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = widget.room.items[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
            borderRadius: AppRadius.sm,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.error),
                    onPressed: () => _removeItem(index),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                item.materialSpecs,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Qty: ', style: GoogleFonts.inter(fontSize: 11)),
                      SizedBox(
                        width: 60,
                        height: 26,
                        child: TextFormField(
                          initialValue: item.quantity.toStringAsFixed(1),
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(fontSize: 11),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                            border: OutlineInputBorder(borderRadius: AppRadius.sm),
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val);
                            if (parsed != null && parsed >= 0) {
                              _updateItemQuantity(index, parsed);
                            }
                          },
                        ),
                      ),
                      if (!widget.hideSqft) Text(' ${item.uom.symbol}', style: GoogleFonts.inter(fontSize: 11)),
                    ],
                  ),
                  if (widget.showAmount)
                    Text(
                      '₹${item.amount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openItemPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ItemPickerDialog(
        onItemSelected: (master) {
          final newItem = QuotationItem(
            id: 'QI-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
            itemMasterId: master.id,
            name: master.name,
            category: master.category,
            materialSpecs: master.technicalSpecs,
            uom: master.uom,
            quantity: 1.0,
            rate: master.sellingRate,
            marginPercent: master.marginPercent,
            imageUrl: master.imageUrl,
          );
          final updatedItems = List<QuotationItem>.from(widget.room.items)..add(newItem);
          widget.onRoomChanged(widget.room.copyWith(items: updatedItems));
        },
      ),
    );
  }

  void _updateItemQuantity(int index, double newQty) {
    final updatedItems = List<QuotationItem>.from(widget.room.items);
    updatedItems[index] = updatedItems[index].copyWith(quantity: newQty);
    widget.onRoomChanged(widget.room.copyWith(items: updatedItems));
  }

  void _removeItem(int index) {
    final updatedItems = List<QuotationItem>.from(widget.room.items)..removeAt(index);
    widget.onRoomChanged(widget.room.copyWith(items: updatedItems));
  }
}
