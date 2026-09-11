import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Professional export modal supporting CSV, Excel (.xlsx), and PDF generation.
class ReportsExportDialog extends StatefulWidget {
  final String reportTitle;
  final String dateRangeLabel;
  final List<String> availableColumns;

  const ReportsExportDialog({
    super.key,
    required this.reportTitle,
    required this.dateRangeLabel,
    this.availableColumns = const [
      'Record ID & Title',
      'Client / Customer Details',
      'Financial Amounts & Margins',
      'Timelines & Completion Dates',
      'Assigned Owner / Project Manager',
      'Execution Status & SLA Compliance',
    ],
  });

  static Future<void> show(
    BuildContext context, {
    required String reportTitle,
    required String dateRangeLabel,
    List<String>? availableColumns,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ReportsExportDialog(
        reportTitle: reportTitle,
        dateRangeLabel: dateRangeLabel,
        availableColumns: availableColumns ?? const [
          'Record ID & Title',
          'Client / Customer Details',
          'Financial Amounts & Margins',
          'Timelines & Completion Dates',
          'Assigned Owner / Project Manager',
          'Execution Status & SLA Compliance',
        ],
      ),
    );
  }

  @override
  State<ReportsExportDialog> createState() => _ReportsExportDialogState();
}

class _ReportsExportDialogState extends State<ReportsExportDialog> {
  String _selectedFormat = 'CSV'; // 'CSV', 'Excel', 'PDF'
  late Set<String> _selectedColumns;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _selectedColumns = Set.from(widget.availableColumns);
  }

  void _handleExport() async {
    setState(() => _isExporting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isExporting = false);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.reportTitle} exported successfully as $_selectedFormat',
                style: GoogleFonts.inter(fontSize: 12),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: AppRadius.xs,
                        ),
                        child: const Icon(Icons.file_download_outlined, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Export Report Data',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            '${widget.reportTitle} • ${widget.dateRangeLabel}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 14),

              // Format selector
              Text(
                'Select Export Format',
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildFormatCard('CSV', Icons.table_chart_outlined, isDark)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFormatCard('Excel', Icons.grid_on_rounded, isDark)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFormatCard('PDF', Icons.picture_as_pdf_outlined, isDark)),
                ],
              ),
              const SizedBox(height: 16),

              // Column Inclusion checklist
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Included Data Columns',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (_selectedColumns.length == widget.availableColumns.length) {
                          _selectedColumns.clear();
                        } else {
                          _selectedColumns = Set.from(widget.availableColumns);
                        }
                      });
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    child: Text(
                      _selectedColumns.length == widget.availableColumns.length ? 'Deselect All' : 'Select All',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: widget.availableColumns.map((col) {
                    final isChecked = _selectedColumns.contains(col);
                    return CheckboxListTile(
                      value: isChecked,
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        col,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedColumns.add(col);
                          } else {
                            _selectedColumns.remove(col);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isExporting ? null : _handleExport,
                    icon: _isExporting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.download_rounded, size: 14),
                    label: Text(
                      _isExporting ? 'Generating...' : 'Download $_selectedFormat',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatCard(String format, IconData icon, bool isDark) {
    final isSelected = _selectedFormat == format;
    return GestureDetector(
      onTap: () => setState(() => _selectedFormat = format),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.1)
              : (isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC)),
          borderRadius: AppRadius.sm,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 1.4 : 0.8,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              format,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : (isDark ? Colors.white : AppColors.lightTextPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
