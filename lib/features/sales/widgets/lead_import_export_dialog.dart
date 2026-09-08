import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// CSV/Excel Lead Ingestion & Export Wizard Dialog
class LeadImportExportDialog extends StatefulWidget {
  final bool isExport;
  final dynamic currentLeads;
  final VoidCallback? onImportComplete;

  const LeadImportExportDialog({
    super.key,
    this.isExport = false,
    this.currentLeads,
    this.onImportComplete,
  });

  static Future<void> show(BuildContext context, {bool isExport = false, dynamic currentLeads, VoidCallback? onImportComplete}) {
    return showDialog(
      context: context,
      builder: (context) => LeadImportExportDialog(
        isExport: isExport,
        currentLeads: currentLeads,
        onImportComplete: onImportComplete,
      ),
    );
  }

  @override
  State<LeadImportExportDialog> createState() => _LeadImportExportDialogState();
}

class _LeadImportExportDialogState extends State<LeadImportExportDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _importStep = 1;
  final String _selectedFileName = 'Meta_Leads_Sept_2026.xlsx';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isExport ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _runImport() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _importStep = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      titlePadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.import_export_rounded, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                'Lead Import & Data Export Center',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
        ],
      ),
      content: SizedBox(
        width: 540,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Import CSV / Excel'),
                Tab(text: 'Export Filtered Leads'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildImportTab(isDark),
                  _buildExportTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportTab(bool isDark) {
    if (_importStep == 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded, size: 48, color: Color(0xFF10B981)),
          const SizedBox(height: 12),
          Text('Import Completed Successfully!', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            '• 48 Leads Imported\n• 3 Duplicates Merged\n• 0 Invalidation Errors',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Done'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.sm,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, style: BorderStyle.solid),
          ),
          child: Row(
            children: [
              const Icon(Icons.file_present_rounded, size: 32, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedFileName, style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    Text('Excel Spreadsheet  •  51 Rows detected', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Change File'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text('Column Auto-Mapping:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
          '✓ "Full Name" -> clientName\n✓ "Mobile" -> phone\n✓ "PIN" -> pincode & auto-qualification\n✓ "Project" -> projectType',
          style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF10B981)),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _runImport,
              icon: _isProcessing
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.upload_file_rounded, size: 16),
              label: Text(_isProcessing ? 'Validating...' : 'Validate & Ingest Leads'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExportTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Export Format:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Row(
          children: [
            ChoiceChip(label: const Text('Microsoft Excel (.XLSX)'), selected: true, onSelected: (_) {}),
            const SizedBox(width: 8),
            ChoiceChip(label: const Text('Comma Separated (.CSV)'), selected: false, onSelected: (_) {}),
          ],
        ),
        const SizedBox(height: 14),
        Text('Scope:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
          'Exporting all active filtered leads (124 records) including contact info, qualification tags, timeline notes, and quotation metadata.',
          style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Downloading CRM_Leads_Export_Sept2026.xlsx...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 16),
              label: const Text('Generate Export File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
