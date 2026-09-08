import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/pdf_document_preview.dart';
import '../widgets/quotation_header.dart';
import '../widgets/quotation_share_dialog.dart';
import '../widgets/visibility_controls.dart';

/// Screen 4: Quotation Documents & Dynamic PDF Presentation Studio (PRD Section 31).
/// 3 Tabs: Generated Documents, Reusable Document Templates, and Split Live PDF Studio.
class QuotationDocumentsPage extends StatefulWidget {
  const QuotationDocumentsPage({super.key});

  @override
  State<QuotationDocumentsPage> createState() => _QuotationDocumentsPageState();
}

class _QuotationDocumentsPageState extends State<QuotationDocumentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Quotation> _quotations;
  late List<QuotationTemplate> _templates;
  late Quotation _selectedQuotation;

  // Studio toggles
  bool _includeCoverPage = true;
  bool _includeSummaryPage = true;
  bool _includeBoqPages = true;
  bool _includeEndPages = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _quotations = List.from(QuotationMockData.quotations);
    _templates = List.from(QuotationMockData.documentTemplates);
    _selectedQuotation = _quotations.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openShareDialog(Quotation q) {
    showDialog(
      context: context,
      builder: (ctx) => QuotationShareDialog(quotation: q),
    );
  }

  void _openNewTemplateModal() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Create Proposal Template', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Template Name *', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Description / Aesthetic Theme', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _templates.add(
                    QuotationTemplate(
                      id: 'tmpl_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      type: QuotationType.residentialInterior,
                      footerNote: 'Custom Template Document',
                      termsAndConditions: 'Standard Terms & Conditions',
                      includedSections: const [
                        DocumentSectionType.coverPage,
                        DocumentSectionType.executiveSummary,
                        DocumentSectionType.boqItemized,
                      ],
                    ),
                  );
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Template ${nameCtrl.text} created!'), backgroundColor: AppColors.success),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Create Template'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Header with Breadcrumbs & Action
            QuotationHeader(
              title: 'Quotation Documents & Proposal Studio',
              subtitle: 'Multi-page branded architectural PDF compiler, executive summaries, terms & digital signoff',
              icon: Icons.picture_as_pdf_rounded,
              breadcrumbs: const ['Homio CRM', 'Commercials', 'Documents & PDFs'],
              primaryAction: FilledButton.icon(
                onPressed: _openNewTemplateModal,
                icon: const Icon(Icons.note_add_rounded, size: 16),
                label: const Text('Create Template'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tabs Selector
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: AppRadius.md,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'All Generated Documents'),
                  Tab(text: 'Document Templates (4)'),
                  Tab(text: 'Live PDF Presentation Studio'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Views
            SizedBox(
              height: 920,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllDocumentsTab(isDark),
                  _buildTemplatesTab(isDark),
                  _buildStudioTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab 1: All Generated Documents Table
  Widget _buildAllDocumentsTab(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50),
            dataRowMinHeight: 56,
            dataRowMaxHeight: 68,
            columns: const [
              DataColumn(label: Text('Document Title')),
              DataColumn(label: Text('Quotation #')),
              DataColumn(label: Text('Client Name')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('File Size')),
              DataColumn(label: Text('Generated By')),
              DataColumn(label: Text('Date Generated')),
              DataColumn(label: Text('Client Signed')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _quotations.map((q) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, size: 20, color: AppColors.error),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${q.quoteNumber}_Proposal_Rev${q.revisionNumber}.pdf', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(q.projectTitle, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(q.quoteNumber, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary))),
                  DataCell(Text(q.clientName, style: GoogleFonts.inter(fontSize: 12))),
                  DataCell(Text(q.quotationType.label, style: GoogleFonts.inter(fontSize: 11))),
                  DataCell(const Text('2.4 MB', style: TextStyle(fontSize: 11))),
                  DataCell(Text(q.createdBy, style: GoogleFonts.inter(fontSize: 11))),
                  DataCell(Text('${q.submissionDate.day}/${q.submissionDate.month}/${q.submissionDate.year}', style: const TextStyle(fontSize: 11))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: q.status == QuotationStatus.accepted ? AppColors.success.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
                        borderRadius: AppRadius.sm,
                      ),
                      child: Text(
                        q.status == QuotationStatus.accepted ? 'SIGNED' : 'PENDING',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: q.status == QuotationStatus.accepted ? AppColors.success : Colors.grey),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_rounded, size: 16),
                          tooltip: 'Open Studio Preview',
                          onPressed: () {
                            setState(() {
                              _selectedQuotation = q;
                              _tabController.animateTo(2); // Jump to studio tab
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_rounded, size: 16),
                          tooltip: 'Share Document',
                          onPressed: () => _openShareDialog(q),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download_rounded, size: 16),
                          tooltip: 'Download PDF',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Downloading ${q.quoteNumber}_Proposal.pdf...'), backgroundColor: AppColors.primary),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Tab 2: Document Templates Grid
  Widget _buildTemplatesTab(bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 420,
        mainAxisExtent: 260,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final tmpl = _templates[index];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: tmpl.isDefault ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: tmpl.isDefault ? 1.5 : 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tmpl.name,
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (tmpl.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: AppRadius.sm),
                      child: Text('DEFAULT', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                ],
              ),
              Text(
                tmpl.description,
                style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: tmpl.includedSections.take(4).map((s) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100, borderRadius: AppRadius.sm),
                    child: Text(s.label, style: const TextStyle(fontSize: 10)),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Theme: ${tmpl.coverTheme}', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Applied template: ${tmpl.name}'), backgroundColor: AppColors.success),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    child: const Text('Use Template', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Tab 3: Split Studio Live Preview
  Widget _buildStudioTab(bool isDark) {
    final isDesktop = MediaQuery.of(context).size.width >= 1080;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Studio Control Panel (30%)
        SizedBox(
          width: isDesktop ? 340 : 280,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quotation Switcher
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Active Quotation Dossier', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedQuotation.id,
                        isExpanded: true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(borderRadius: AppRadius.sm),
                        ),
                        items: _quotations.map((q) {
                          return DropdownMenuItem<String>(
                            value: q.id,
                            child: Text('${q.quoteNumber} (${q.clientName})', style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (id) {
                          if (id != null) {
                            setState(() => _selectedQuotation = _quotations.firstWhere((q) => q.id == id));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Pages inclusion toggles
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Compiler Page Inclusions', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: _includeCoverPage,
                        title: const Text('Cover Page', style: TextStyle(fontSize: 12)),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => _includeCoverPage = v ?? true),
                      ),
                      CheckboxListTile(
                        value: _includeSummaryPage,
                        title: const Text('Executive Scope Summary', style: TextStyle(fontSize: 12)),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => _includeSummaryPage = v ?? true),
                      ),
                      CheckboxListTile(
                        value: _includeBoqPages,
                        title: const Text('Itemized BOQ Schedule', style: TextStyle(fontSize: 12)),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => _includeBoqPages = v ?? true),
                      ),
                      CheckboxListTile(
                        value: _includeEndPages,
                        title: const Text('Warranty & Signature Page', style: TextStyle(fontSize: 12)),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => _includeEndPages = v ?? true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Visibility IP Protection Controls
                VisibilityControls(
                  settings: _selectedQuotation.visibilitySettings,
                  onChanged: (vs) {
                    setState(() {
                      _selectedQuotation = _selectedQuotation.copyWith(
                        visibilitySettings: vs,
                        hideRate: vs.hideRate,
                        hideSqft: vs.hideSqft,
                        showAmount: vs.showAmount,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Right Live PDF Preview (70%)
        Expanded(
          child: Container(
            height: 900,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
            ),
            child: PdfDocumentPreview(
              quotation: _selectedQuotation,
              showCoverPage: _includeCoverPage,
              showSummaryPage: _includeSummaryPage,
              showBoqPages: _includeBoqPages,
              showEndPages: _includeEndPages,
            ),
          ),
        ),
      ],
    );
  }
}
