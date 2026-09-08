import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Simulated high-fidelity multi-page PDF presentation previewer.
class PdfDocumentPreview extends StatefulWidget {
  final Quotation quotation;
  final bool showCoverPage;
  final bool showSummaryPage;
  final bool showBoqPages;
  final bool showEndPages;

  const PdfDocumentPreview({
    super.key,
    required this.quotation,
    this.showCoverPage = true,
    this.showSummaryPage = true,
    this.showBoqPages = true,
    this.showEndPages = true,
  });

  @override
  State<PdfDocumentPreview> createState() => _PdfDocumentPreviewState();
}

class _PdfDocumentPreviewState extends State<PdfDocumentPreview> {
  int _activePageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = <Widget>[];
    if (widget.showCoverPage) pages.add(_buildCoverPage());
    if (widget.showSummaryPage) pages.add(_buildSummaryPage());
    if (widget.showBoqPages) pages.add(_buildBoqPage());
    if (widget.showEndPages) pages.add(_buildEndPage());

    if (pages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'No pages selected for preview',
            style: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ),
      );
    }

    final safeIndex = _activePageIndex.clamp(0, pages.length - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isHeightBounded = constraints.maxHeight.isFinite;

        final sheet = SingleChildScrollView(
          child: Center(
            child: Container(
              width: 780,
              constraints: const BoxConstraints(minHeight: 1000),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: DefaultTextStyle(
                style: GoogleFonts.inter(color: const Color(0xFF0F172A)),
                child: pages[safeIndex],
              ),
            ),
          ),
        );

        return Column(
          children: [
            // Page Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: AppRadius.sm,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, size: 18, color: AppColors.error),
                      const SizedBox(width: 8),
                      Text(
                        'Page ${safeIndex + 1} of ${pages.length}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getPageTitle(safeIndex),
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded, size: 20),
                        onPressed: safeIndex > 0 ? () => setState(() => _activePageIndex = safeIndex - 1) : null,
                        tooltip: 'Previous Page',
                        splashRadius: 16,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded, size: 20),
                        onPressed: safeIndex < pages.length - 1
                            ? () => setState(() => _activePageIndex = safeIndex + 1)
                            : null,
                        tooltip: 'Next Page',
                        splashRadius: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Simulated A4 Document Page Sheet
            if (isHeightBounded)
              Expanded(child: sheet)
            else
              SizedBox(
                height: 750,
                child: sheet,
              ),
          ],
        );
      },
    );
  }

  String _getPageTitle(int index) {
    final titles = <String>[];
    if (widget.showCoverPage) titles.add('Cover Page');
    if (widget.showSummaryPage) titles.add('Executive Summary & Room Breakdown');
    if (widget.showBoqPages) titles.add('Detailed Bill of Quantities (BOQ)');
    if (widget.showEndPages) titles.add('Payment Milestones & Warranties');

    if (index >= 0 && index < titles.length) {
      return titles[index];
    }
    return 'Document Page';
  }

  // ---------------------------------------------------------------------------
  // Page 1: Branded Cover Page
  // ---------------------------------------------------------------------------
  Widget _buildCoverPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text('H', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'HOMIO STUDIO',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'ESTIMATE & SPECIFICATION DOSSIER',
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: const Color(0xFF64748B)),
                ),
                Text(
                  widget.quotation.quoteNumber,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF4F46E5)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 36),

        // Hero 3D Render
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            widget.quotation.coverImageUrl,
            height: 360,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 360,
              color: const Color(0xFFE2E8F0),
              child: const Center(child: Icon(Icons.apartment_rounded, size: 64, color: Color(0xFF94A3B8))),
            ),
          ),
        ),
        const SizedBox(height: 36),

        Text(
          'INTERIOR DESIGN & TURNKEY FITOUT PROPOSAL',
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: const Color(0xFF4F46E5)),
        ),
        const SizedBox(height: 6),
        Text(
          widget.quotation.projectTitle,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.quotation.projectLocation,
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 32),

        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PREPARED FOR:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                  const SizedBox(height: 2),
                  Text(widget.quotation.clientName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                  Text('${widget.quotation.clientPhone} • ${widget.quotation.clientEmail}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('PRINCIPAL DESIGNER:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                  const SizedBox(height: 2),
                  Text(widget.quotation.designerName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5)), overflow: TextOverflow.ellipsis),
                  Text('Revision: R-${widget.quotation.revisionNumber} • Valid for 14 Days', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Page 2: Executive Summary & Room Breakdown
  // ---------------------------------------------------------------------------
  Widget _buildSummaryPage() {
    final gross = widget.quotation.grossSubtotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocHeader('01. EXECUTIVE COST SUMMARY & ROOM ALLOCATION'),
        const SizedBox(height: 24),

        Text(
          'Project Financial Overview',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 6),
        const Text(
          'All figures include premium material supply, precision factory fabrication, and on-site turnkey installation with dedicated project supervision.',
          style: TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.4),
        ),
        const SizedBox(height: 24),

        // Room breakdown distribution
        ...widget.quotation.rooms.map((room) {
          final share = gross > 0 ? (room.roomSubtotal / gross) : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      room.roomName,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                    ),
                    if (widget.quotation.showAmount)
                      Text(
                        '₹${room.roomSubtotal.toStringAsFixed(0)} (${(share * 100).toStringAsFixed(1)}%)',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                if (!widget.quotation.hideSqft)
                  Text(
                    'Carpet: ${room.carpetSqft.toStringAsFixed(0)} Sq.Ft • Finish Tier: ${room.tier.title}',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: share,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF4F46E5)),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 32),
        // Total summary table
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Gross Subtotal', '₹${widget.quotation.grossSubtotal.toStringAsFixed(0)}'),
              if (widget.quotation.discountPercent > 0)
                _buildSummaryRow(
                  'Early Bird Booking Privilege (${widget.quotation.discountPercent.toStringAsFixed(0)}%)',
                  '- ₹${widget.quotation.discountAmount.toStringAsFixed(0)}',
                  isDiscount: true,
                ),
              _buildSummaryRow('Taxable Total', '₹${widget.quotation.taxableAmount.toStringAsFixed(0)}'),
              _buildSummaryRow('Goods & Services Tax (GST 18%)', '₹${widget.quotation.gstAmount.toStringAsFixed(0)}'),
              const Divider(color: Color(0xFFCBD5E1)),
              _buildSummaryRow(
                'Grand Total (Turnkey All-Inclusive)',
                '₹${widget.quotation.grandTotal.toStringAsFixed(0)}',
                isGrand: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false, bool isGrand = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isGrand ? 13 : 11,
              fontWeight: isGrand ? FontWeight.w800 : FontWeight.w500,
              color: isGrand ? const Color(0xFF0F172A) : const Color(0xFF475569),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isGrand ? 16 : 12,
              fontWeight: FontWeight.w800,
              color: isDiscount
                  ? const Color(0xFFEF4444)
                  : isGrand
                      ? const Color(0xFF10B981)
                      : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Page 3: Detailed BOQ
  // ---------------------------------------------------------------------------
  Widget _buildBoqPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocHeader('02. DETAILED BILL OF QUANTITIES (BOQ)'),
        const SizedBox(height: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int rIdx = 0; rIdx < widget.quotation.rooms.length; rIdx++) ...[
              if (rIdx > 0) const SizedBox(height: 20),
              Builder(
                builder: (context) {
                  final room = widget.quotation.rooms[rIdx];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${rIdx + 1}. ${room.roomName.toUpperCase()}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF4F46E5)),
                            ),
                            if (widget.quotation.showAmount)
                              Text(
                                '₹${room.roomSubtotal.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      Table(
                        border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 0.8),
                        columnWidths: {
                          0: const FlexColumnWidth(4),
                          if (!widget.quotation.hideSqft) 1: const FlexColumnWidth(1.2),
                          2: const FlexColumnWidth(1.2),
                          if (!widget.quotation.hideRate) 3: const FlexColumnWidth(1.6),
                          if (widget.quotation.showAmount) 4: const FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                            children: [
                              _tableCell('Item & Specification', isHeader: true),
                              if (!widget.quotation.hideSqft) _tableCell('UOM', isHeader: true),
                              _tableCell('Qty', isHeader: true),
                              if (!widget.quotation.hideRate) _tableCell('Rate (₹)', isHeader: true),
                              if (widget.quotation.showAmount) _tableCell('Amount (₹)', isHeader: true),
                            ],
                          ),
                          ...room.items.map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                                      Text(item.materialSpecs, style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                if (!widget.quotation.hideSqft) _tableCell(item.uom.symbol),
                                _tableCell(item.quantity.toStringAsFixed(1)),
                                if (!widget.quotation.hideRate) _tableCell('₹${item.rate.toStringAsFixed(0)}'),
                                if (widget.quotation.showAmount)
                                  _tableCell('₹${item.amount.toStringAsFixed(0)}', isBold: true),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _tableCell(String text, {bool isHeader = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        textAlign: isHeader ? TextAlign.left : TextAlign.center,
        style: TextStyle(
          fontSize: isHeader ? 9 : 9,
          fontWeight: isHeader || isBold ? FontWeight.w700 : FontWeight.w500,
          color: isHeader ? const Color(0xFF475569) : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Page 4: End Pages (Terms, Warranties, Brand Standards, Signatures)
  // ---------------------------------------------------------------------------
  Widget _buildEndPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocHeader('03. COMMERCIAL TERMS, WARRANTIES & DIGITAL SIGNOFF'),
        const SizedBox(height: 20),

        Text('Milestone Payment Schedule', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        _buildMilestoneRow('Stage 1: Booking Advance', '10% on design freeze and 3D signoff'),
        _buildMilestoneRow('Stage 2: Carcass & Civil Start', '40% upon procurement of BWP plywood & civil work'),
        _buildMilestoneRow('Stage 3: Surface Finishes', '40% upon laminate/acrylic pressing and fittings installation'),
        _buildMilestoneRow('Stage 4: Handover & QC Checklist', '10% upon snags resolution and key handover'),
        const SizedBox(height: 18),

        Text('10-Year Warranty & Brand Standards', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text(
          '• Plywood: CenturyPly Club Prime / Greenply 710 with lifetime borer-proof certification.\n'
          '• Hardware: 5-Year German functional warranty by Hafele India & Blum Austria.\n'
          '• Finishes: High-grade scratch-resistant 1.0mm Merino / High-Gloss UV Acrylic.',
          style: TextStyle(fontSize: 10, color: Color(0xFF475569), height: 1.5),
        ),
        const SizedBox(height: 32),

        // Signature Blocks
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 48,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF0F172A), width: 1.5)),
                  ),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Ananya Roy', style: TextStyle(fontFamily: 'Cursive', fontSize: 18, color: Color(0xFF4F46E5))),
                  ),
                ),
                const SizedBox(height: 6),
                const Text('HOMIO DESIGN STUDIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                const Text('Authorized Design Director', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 48,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF0F172A), width: 1.5, style: BorderStyle.solid)),
                  ),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Click-to-Sign Portal', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ),
                ),
                const SizedBox(height: 6),
                Text(widget.quotation.clientName.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                const Text('Homeowner / Authorized Client Signatory', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDocHeader(String sectionTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sectionTitle,
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: const Color(0xFF4F46E5)),
        ),
        Text(
          '${widget.quotation.quoteNumber} | R-${widget.quotation.revisionNumber}',
          style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildMilestoneRow(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF10B981)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF0F172A)),
                children: [
                  TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(text: desc, style: const TextStyle(color: Color(0xFF475569))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
