import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/quotation_header.dart';
import '../widgets/pdf_document_preview.dart';
import '../widgets/whatsapp_urgency_dialog.dart';

/// Screen 3: Quotation Documents & Dynamic PDF Presentation Studio (PRD Section 9.3).
class QuotationDocumentsPage extends StatefulWidget {
  const QuotationDocumentsPage({super.key});

  @override
  State<QuotationDocumentsPage> createState() => _QuotationDocumentsPageState();
}

class _QuotationDocumentsPageState extends State<QuotationDocumentsPage> {
  late Quotation _selectedQuotation;
  bool _includeCoverPage = true;
  bool _includeSummaryPage = true;
  bool _includeBoqPages = true;
  bool _includeEndPages = true;

  @override
  void initState() {
    super.initState();
    _selectedQuotation = QuotationMockData.quotations.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            QuotationHeader(
              title: 'Quotation Documents & Client Presentation Studio',
              subtitle: 'Multi-page branded architectural PDF compiler, executive summaries & digital signoff',
              icon: Icons.picture_as_pdf_rounded,
              additionalFilters: [
                _buildQuotationPicker(isDark),
              ],
              primaryAction: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _openWhatsAppShare,
                    icon: const Icon(Icons.chat_bubble_rounded, size: 16, color: Color(0xFF25D366)),
                    label: const Text('Share on WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF25D366),
                      side: const BorderSide(color: Color(0xFF25D366), width: 0.8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _downloadPdf,
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Download PDF Dossier'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            // Studio Layout: Left Sidebar Controls & Right Live Preview
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Control Sidebar (28%)
                  SizedBox(
                    width: 320,
                    child: _buildControlsSidebar(isDark),
                  ),
                  const SizedBox(width: 16),
                  // Right PDF Preview (72%)
                  Expanded(
                    child: SizedBox(
                      height: 960,
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
              )
            else
              Column(
                children: [
                  _buildControlsSidebar(isDark),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 800,
                    child: PdfDocumentPreview(
                      quotation: _selectedQuotation,
                      showCoverPage: _includeCoverPage,
                      showSummaryPage: _includeSummaryPage,
                      showBoqPages: _includeBoqPages,
                      showEndPages: _includeEndPages,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotationPicker(bool isDark) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedQuotation.id,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: QuotationMockData.quotations.map((q) {
            return DropdownMenuItem(value: q.id, child: Text('${q.quoteNumber} - ${q.clientName}'));
          }).toList(),
          onChanged: (newId) {
            if (newId != null) {
              setState(() {
                _selectedQuotation = QuotationMockData.quotations.firstWhere((q) => q.id == newId);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildControlsSidebar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Document Section Controls',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Toggle sections to compile customized presentation tiers',
            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const Divider(height: 24),

          // Section Toggles
          _buildCheckboxTile(
            isDark,
            title: '01. Branded Cover Page',
            subtitle: 'Hero 3D render preview, client info & designer bio',
            value: _includeCoverPage,
            onChanged: (val) => setState(() => _includeCoverPage = val ?? true),
          ),
          _buildCheckboxTile(
            isDark,
            title: '02. Executive Cost Summary',
            subtitle: 'Room-wise allocation charts & net financial table',
            value: _includeSummaryPage,
            onChanged: (val) => setState(() => _includeSummaryPage = val ?? true),
          ),
          _buildCheckboxTile(
            isDark,
            title: '03. Detailed BOQ Pages',
            subtitle: 'Room item specifications, measurements & rates',
            value: _includeBoqPages,
            onChanged: (val) => setState(() => _includeBoqPages = val ?? true),
          ),
          _buildCheckboxTile(
            isDark,
            title: '04. Terms, Warranty & Signoff',
            subtitle: 'Payment schedule milestones & digital signature blocks',
            value: _includeEndPages,
            onChanged: (val) => setState(() => _includeEndPages = val ?? true),
          ),
          const Divider(height: 24),

          // Display Visibility Toggles
          Text(
            'Confidentiality & IP Toggles',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text('Hide Unit Rates', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            subtitle: Text('Only show room subtotals', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
            value: _selectedQuotation.hideRate,
            activeThumbColor: AppColors.warning,
            onChanged: (val) {
              setState(() => _selectedQuotation = _selectedQuotation.copyWith(hideRate: val));
            },
          ),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text('Hide Sq.Ft / Dimensions', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            subtitle: Text('Prevent external contractor poaching', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
            value: _selectedQuotation.hideSqft,
            activeThumbColor: AppColors.secondary,
            onChanged: (val) {
              setState(() => _selectedQuotation = _selectedQuotation.copyWith(hideSqft: val));
            },
          ),
          const Divider(height: 24),

          // Client Sharing Actions
          Text('Digital Sign-off & Delivery', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _copyApprovalLink,
              icon: const Icon(Icons.link_rounded, size: 16),
              label: const Text('Copy Client Sign-off Link'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _emailProposal,
              icon: const Icon(Icons.email_outlined, size: 16),
              label: const Text('Email PDF to Client'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(bool isDark, {required String title, required String subtitle, required bool value, required ValueChanged<bool?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  void _openWhatsAppShare() {
    showDialog(
      context: context,
      builder: (ctx) => WhatsAppUrgencyDialog(
        quotation: _selectedQuotation,
        onDispatched: () {},
      ),
    );
  }

  void _downloadPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compiling ${_selectedQuotation.quoteNumber} PDF presentation... Download ready!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _copyApprovalLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Client signoff link copied: https://homio.design/approve/${_selectedQuotation.quoteNumber}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _emailProposal() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proposal email dispatched to ${_selectedQuotation.clientEmail} with attached PDF.'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
