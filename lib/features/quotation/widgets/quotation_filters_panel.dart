import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Comprehensive filter panel for Quotations table matching PRD Section 4.6.
class QuotationFiltersPanel extends StatefulWidget {
  final Set<QuotationStatus> selectedStatuses;
  final QuotationType? selectedType;
  final String? selectedSalesOwner;
  final RangeValues? valueRange;
  final DateTimeRange? dateRange;
  final ValueChanged<Set<QuotationStatus>> onStatusChanged;
  final ValueChanged<QuotationType?> onTypeChanged;
  final ValueChanged<String?> onSalesOwnerChanged;
  final ValueChanged<RangeValues?> onValueRangeChanged;
  final ValueChanged<DateTimeRange?> onDateRangeChanged;
  final VoidCallback onReset;

  const QuotationFiltersPanel({
    super.key,
    required this.selectedStatuses,
    this.selectedType,
    this.selectedSalesOwner,
    this.valueRange,
    this.dateRange,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onSalesOwnerChanged,
    required this.onValueRangeChanged,
    required this.onDateRangeChanged,
    required this.onReset,
  });

  @override
  State<QuotationFiltersPanel> createState() => _QuotationFiltersPanelState();
}

class _QuotationFiltersPanelState extends State<QuotationFiltersPanel> {
  static const List<String> salesOwners = [
    'Vikram Malhotra',
    'Kunal Kapoor',
    'Rahul Sen',
    'Devika Nair',
    'Ananya Roy',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.tune_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Filter Quotations',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: widget.onReset,
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: Text(
                  'Reset All',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Status Multi-select Chips
          Text(
            'LIFECYCLE STATUS',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: QuotationStatus.values.map((status) {
              final isSelected = widget.selectedStatuses.contains(status);
              return FilterChip(
                label: Text(
                  status.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.primary)
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final newSet = Set<QuotationStatus>.from(widget.selectedStatuses);
                  if (selected) {
                    newSet.add(status);
                  } else {
                    newSet.remove(status);
                  }
                  widget.onStatusChanged(newSet);
                },
                avatar: Icon(
                  status.icon,
                  size: 13,
                  color: isSelected ? AppColors.primary : status.color,
                ),
                backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                selectedColor: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.sm,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: 0.8,
                  ),
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Dropdowns row: Type, Sales Owner, Date Range
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Quotation Type
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<QuotationType?>(
                  initialValue: widget.selectedType,
                  decoration: InputDecoration(
                    labelText: 'Quotation Type',
                    labelStyle: GoogleFonts.inter(fontSize: 12),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.sm,
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Types', style: TextStyle(fontSize: 12)),
                    ),
                    ...QuotationType.values.map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Row(
                          children: [
                            Icon(t.icon, size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(t.label, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: widget.onTypeChanged,
                ),
              ),

              // Sales Owner
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String?>(
                  initialValue: widget.selectedSalesOwner,
                  decoration: InputDecoration(
                    labelText: 'Sales Owner',
                    labelStyle: GoogleFonts.inter(fontSize: 12),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.sm,
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Owners', style: TextStyle(fontSize: 12)),
                    ),
                    ...salesOwners.map(
                      (owner) => DropdownMenuItem(
                        value: owner,
                        child: Text(owner, style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                  onChanged: widget.onSalesOwnerChanged,
                ),
              ),

              // Date Range Button
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2028),
                    initialDateRange: widget.dateRange,
                  );
                  if (picked != null) {
                    widget.onDateRangeChanged(picked);
                  }
                },
                icon: const Icon(Icons.date_range_rounded, size: 14),
                label: Text(
                  widget.dateRange != null
                      ? '${widget.dateRange!.start.day}/${widget.dateRange!.start.month} - ${widget.dateRange!.end.day}/${widget.dateRange!.end.month}'
                      : 'Date Range',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  side: BorderSide(
                    color: widget.dateRange != null
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
              if (widget.dateRange != null)
                IconButton(
                  onPressed: () => widget.onDateRangeChanged(null),
                  icon: const Icon(Icons.close_rounded, size: 14),
                  tooltip: 'Clear Date Filter',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
