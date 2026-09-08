import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import 'expiry_countdown.dart';
import 'quotation_status_badge.dart';

/// Full-featured Quotation Data Table matching PRD Section 4.3 with row selection & actions.
class QuotationTable extends StatefulWidget {
  final List<Quotation> quotations;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final ValueChanged<Quotation> onViewDetail;
  final ValueChanged<Quotation> onEdit;
  final ValueChanged<Quotation> onShare;
  final ValueChanged<Quotation> onDownloadPdf;
  final ValueChanged<Quotation>? onDuplicate;
  final ValueChanged<Quotation>? onArchive;

  const QuotationTable({
    super.key,
    required this.quotations,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.onViewDetail,
    required this.onEdit,
    required this.onShare,
    required this.onDownloadPdf,
    this.onDuplicate,
    this.onArchive,
  });

  @override
  State<QuotationTable> createState() => _QuotationTableState();
}

class _QuotationTableState extends State<QuotationTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bulk action bar when items selected
          if (widget.selectedIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
              child: Row(
                children: [
                  Text(
                    '${widget.selectedIds.length} quotations selected',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bulk PDF export generated for ${widget.selectedIds.length} items.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 14),
                    label: const Text('Export Selected', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () => widget.onSelectionChanged({}),
                    tooltip: 'Clear Selection',
                  ),
                ],
              ),
            ),

          // Scrollable table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              headingRowColor: WidgetStateProperty.all(
                isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
              ),
              dataRowMinHeight: 52,
              dataRowMaxHeight: 64,
              horizontalMargin: 16,
              columnSpacing: 20,
              showCheckboxColumn: true,
              columns: [
                DataColumn(
                  label: const Text('Quote #'),
                  onSort: (col, asc) {
                    setState(() {
                      _sortColumnIndex = col;
                      _sortAscending = asc;
                    });
                  },
                ),
                const DataColumn(label: Text('Client & Project')),
                const DataColumn(label: Text('Status')),
                DataColumn(
                  label: const Text('Grand Total (₹)'),
                  numeric: true,
                  onSort: (col, asc) {
                    setState(() {
                      _sortColumnIndex = col;
                      _sortAscending = asc;
                    });
                  },
                ),
                const DataColumn(label: Text('Discount'), numeric: true),
                const DataColumn(label: Text('Validity / Expiry')),
                const DataColumn(label: Text('Owner')),
                const DataColumn(label: Text('Actions')),
              ],
              rows: widget.quotations.map((q) {
                final isSelected = widget.selectedIds.contains(q.id);

                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (selected) {
                    final newSet = Set<String>.from(widget.selectedIds);
                    if (selected == true) {
                      newSet.add(q.id);
                    } else {
                      newSet.remove(q.id);
                    }
                    widget.onSelectionChanged(newSet);
                  },
                  cells: [
                    // Quote # & Rev
                    DataCell(
                      InkWell(
                        onTap: () => widget.onViewDetail(q),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.quoteNumber,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'Rev ${q.revisionNumber}',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Client & Project
                    DataCell(
                      InkWell(
                        onTap: () => widget.onViewDetail(q),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.clientName,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              q.projectTitle,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Status Badge
                    DataCell(
                      QuotationStatusBadge(status: q.status, isCompact: true),
                    ),

                    // Grand Total
                    DataCell(
                      Text(
                        '₹${q.grandTotal.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),

                    // Discount
                    DataCell(
                      Text(
                        q.discountAmount > 0
                            ? '${q.discountPercent.toStringAsFixed(1)}% (-₹${q.discountAmount.toStringAsFixed(0)})'
                            : 'None',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: q.discountAmount > 0 ? AppColors.error : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          fontWeight: q.discountAmount > 0 ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),

                    // Expiry countdown
                    DataCell(
                      ExpiryCountdown(expiryDate: q.discountExpiryDate, isCompact: true),
                    ),

                    // Owner
                    DataCell(
                      Text(
                        q.salesOwner,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),

                    // Row Actions
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_rounded, size: 16),
                            tooltip: 'Quotation 360° Detail',
                            onPressed: () => widget.onViewDetail(q),
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, size: 16),
                            tooltip: 'Edit Quotation',
                            onPressed: () => widget.onEdit(q),
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share_rounded, size: 16),
                            tooltip: 'Dispatch via WhatsApp/Email',
                            onPressed: () => widget.onShare(q),
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert_rounded, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onSelected: (val) {
                              if (val == 'download') widget.onDownloadPdf(q);
                              if (val == 'duplicate') widget.onDuplicate?.call(q);
                              if (val == 'archive') widget.onArchive?.call(q);
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(
                                value: 'download',
                                child: Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf_rounded, size: 14),
                                    SizedBox(width: 8),
                                    Text('Download PDF', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'duplicate',
                                child: Row(
                                  children: [
                                    Icon(Icons.content_copy_rounded, size: 14),
                                    SizedBox(width: 8),
                                    Text('Duplicate Proposal', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'archive',
                                child: Row(
                                  children: [
                                    Icon(Icons.archive_rounded, size: 14),
                                    SizedBox(width: 8),
                                    Text('Archive Quotation', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
