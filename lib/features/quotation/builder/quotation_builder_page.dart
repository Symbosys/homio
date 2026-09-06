import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/quotation_header.dart';
import '../widgets/room_boq_accordion.dart';
import '../widgets/pdf_document_preview.dart';
import '../widgets/whatsapp_urgency_dialog.dart';

/// Screen 1: Production-grade Quotation Builder with Room Grouping & Display Toggles.
class QuotationBuilderPage extends StatefulWidget {
  const QuotationBuilderPage({super.key});

  @override
  State<QuotationBuilderPage> createState() => _QuotationBuilderPageState();
}

class _QuotationBuilderPageState extends State<QuotationBuilderPage> {
  late Quotation _activeQuotation;

  @override
  void initState() {
    super.initState();
    _activeQuotation = QuotationMockData.quotations.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            QuotationHeader(
              title: 'Quotation Builder & Estimation Engine',
              subtitle: 'Dynamic room breakdown, technical BOQ items & granular IP protection toggles',
              icon: Icons.calculate_rounded,
              additionalFilters: [
                _buildQuotationDropdown(isDark),
              ],
              primaryAction: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    onPressed: _openPdfPreviewModal,
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 16, color: AppColors.error),
                    label: const Text('Preview PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _saveQuotation,
                    icon: const Icon(Icons.save_rounded, size: 16),
                    label: const Text('Save Draft'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            // Metadata Card (Client & Project Information)
            _buildMetadataCard(isDark),
            const SizedBox(height: 16),

            // Display Toggles Control Bar (Granular Display Visibility - PRD Section 9.2)
            _buildDisplayTogglesBar(isDark),
            const SizedBox(height: 16),

            // Main Content Area: Responsive Split on Desktop, Stacked on Mobile
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left 68%: Room BOQ Accordions
                  Expanded(
                    flex: 68,
                    child: _buildRoomListSection(isDark),
                  ),
                  const SizedBox(width: 16),
                  // Right 32%: Sticky Financial Breakdown Summary
                  Expanded(
                    flex: 32,
                    child: _buildStickyFinancialSummary(isDark),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildRoomListSection(isDark),
                  const SizedBox(height: 16),
                  _buildStickyFinancialSummary(isDark),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotationDropdown(bool isDark) {
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
          value: _activeQuotation.id,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          items: QuotationMockData.quotations.map((q) {
            return DropdownMenuItem(
              value: q.id,
              child: Text('${q.quoteNumber} (${q.clientName})'),
            );
          }).toList(),
          onChanged: (newId) {
            if (newId != null) {
              setState(() {
                _activeQuotation = QuotationMockData.quotations.firstWhere((q) => q.id == newId);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildMetadataCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildMetaField(isDark, 'PROJECT', _activeQuotation.projectTitle, Icons.home_work_rounded),
          _buildMetaField(isDark, 'CLIENT', '${_activeQuotation.clientName} (${_activeQuotation.clientPhone})', Icons.person_rounded),
          _buildMetaField(isDark, 'DESIGNER', _activeQuotation.designerName, Icons.draw_rounded),
          _buildMetaField(isDark, 'REVISION', 'R-${_activeQuotation.revisionNumber}', Icons.history_rounded),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _activeQuotation.status.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _activeQuotation.status.color.withValues(alpha: 0.4), width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_activeQuotation.status.icon, size: 14, color: _activeQuotation.status.color),
                const SizedBox(width: 4),
                Text(
                  _activeQuotation.status.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _activeQuotation.status.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaField(bool isDark, String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Granular Display Visibility Toggles (PRD Section 9.2 & docs/requirmenet.md)
  Widget _buildDisplayTogglesBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.2),
          width: 0.8,
        ),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.visibility_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Client Proposal Visibility Controls:',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          // Toggle 1: Hide Unit Rate
          FilterChip(
            avatar: Icon(
              _activeQuotation.hideRate ? Icons.lock_rounded : Icons.lock_open_rounded,
              size: 14,
              color: _activeQuotation.hideRate ? AppColors.warning : AppColors.primary,
            ),
            label: Text(_activeQuotation.hideRate ? 'Unit Rate Hidden' : 'Hide Unit Rate'),
            selected: _activeQuotation.hideRate,
            onSelected: (val) {
              setState(() => _activeQuotation = _activeQuotation.copyWith(hideRate: val));
            },
            selectedColor: AppColors.warning.withValues(alpha: 0.2),
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            labelStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _activeQuotation.hideRate ? AppColors.warning : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
          // Toggle 2: Hide Sq.Ft & Dimensions
          FilterChip(
            avatar: Icon(
              _activeQuotation.hideSqft ? Icons.shield_rounded : Icons.square_foot_rounded,
              size: 14,
              color: _activeQuotation.hideSqft ? AppColors.secondaryLight : AppColors.primary,
            ),
            label: Text(_activeQuotation.hideSqft ? 'Dimensions / SqFt Hidden (Anti-Poaching)' : 'Hide Sq.Ft / Dims'),
            selected: _activeQuotation.hideSqft,
            onSelected: (val) {
              setState(() => _activeQuotation = _activeQuotation.copyWith(hideSqft: val));
            },
            selectedColor: AppColors.secondary.withValues(alpha: 0.2),
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            labelStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _activeQuotation.hideSqft ? AppColors.secondaryLight : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
          // Toggle 3: Show Amount
          FilterChip(
            avatar: Icon(
              _activeQuotation.showAmount ? Icons.payments_rounded : Icons.money_off_rounded,
              size: 14,
              color: _activeQuotation.showAmount ? AppColors.success : AppColors.error,
            ),
            label: Text(_activeQuotation.showAmount ? 'Show Lump Sum Amounts' : 'Hide Amounts'),
            selected: _activeQuotation.showAmount,
            onSelected: (val) {
              setState(() => _activeQuotation = _activeQuotation.copyWith(showAmount: val));
            },
            selectedColor: AppColors.success.withValues(alpha: 0.2),
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            labelStyle: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _activeQuotation.showAmount ? AppColors.success : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomListSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Configured Rooms & Areas',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_activeQuotation.rooms.length} Areas',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _openAddRoomDialog,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add Room / Area'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Room Accordion Cards
        ..._activeQuotation.rooms.asMap().entries.map((entry) {
          final idx = entry.key;
          final room = entry.value;
          return RoomBoqAccordion(
            room: room,
            hideRate: _activeQuotation.hideRate,
            hideSqft: _activeQuotation.hideSqft,
            showAmount: _activeQuotation.showAmount,
            onRoomChanged: (updatedRoom) {
              final newRooms = List<RoomArea>.from(_activeQuotation.rooms);
              newRooms[idx] = updatedRoom;
              setState(() => _activeQuotation = _activeQuotation.copyWith(rooms: newRooms));
            },
            onDeleteRoom: () {
              final newRooms = List<RoomArea>.from(_activeQuotation.rooms)..removeAt(idx);
              setState(() => _activeQuotation = _activeQuotation.copyWith(rooms: newRooms));
            },
          );
        }),
      ],
    );
  }

  Widget _buildStickyFinancialSummary(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Financial Costing Engine',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const Icon(Icons.analytics_rounded, size: 18, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Live calculations with GST & early bird discount enforcement',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const Divider(height: 24),

          // Total Carpet Sqft
          _buildSummaryRow(isDark, 'Total Carpet Area', '${_activeQuotation.totalCarpetSqft.toStringAsFixed(0)} Sq.Ft'),
          const SizedBox(height: 8),

          // Room wise summary breakdown
          ..._activeQuotation.rooms.map((r) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '• ${r.roomName}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '₹${r.roomSubtotal.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 20),

          // Gross Subtotal
          _buildSummaryRow(isDark, 'Gross Subtotal', '₹${_activeQuotation.grossSubtotal.toStringAsFixed(0)}', isBold: true),
          const SizedBox(height: 12),

          // Early Bird Discount % slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Early Bird Discount:',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${_activeQuotation.discountPercent.toStringAsFixed(0)}% (-₹${_activeQuotation.discountAmount.toStringAsFixed(0)})',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          Slider(
            value: _activeQuotation.discountPercent,
            min: 0.0,
            max: 20.0,
            divisions: 20,
            activeColor: AppColors.error,
            onChanged: (val) {
              setState(() => _activeQuotation = _activeQuotation.copyWith(discountPercent: val));
            },
          ),

          // Taxable Amount
          _buildSummaryRow(isDark, 'Taxable Amount', '₹${_activeQuotation.taxableAmount.toStringAsFixed(0)}'),
          const SizedBox(height: 8),

          // GST 18%
          _buildSummaryRow(isDark, 'GST (${_activeQuotation.gstPercent.toStringAsFixed(0)}%)', '₹${_activeQuotation.gstAmount.toStringAsFixed(0)}'),
          const Divider(height: 24),

          // Grand Total
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: AppRadius.sm,
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grand Total (All-Inclusive)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      'Turnkey Supply & Installation',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${_activeQuotation.grandTotal.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.success,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Quick Actions
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openPdfPreviewModal,
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
              label: const Text('Generate & Export Proposal PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openWhatsAppUrgencyModal,
              icon: const Icon(Icons.chat_bubble_rounded, size: 16, color: Color(0xFF25D366)),
              label: const Text('Dispatch via WhatsApp Cloud API'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF25D366),
                side: const BorderSide(color: Color(0xFF25D366), width: 0.8),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(bool isDark, String label, String val, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isBold ? 13 : 11,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          val,
          style: GoogleFonts.inter(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  void _openAddRoomDialog() {
    final nameController = TextEditingController(text: 'Kids Bedroom');
    final lengthController = TextEditingController(text: '14');
    final widthController = TextEditingController(text: '12');
    final heightController = TextEditingController(text: '10');
    MaterialTier selectedTier = MaterialTier.premium;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Dialog(
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add New Room / Area', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 14),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Room Name (e.g., Kids Bedroom, Pooja Room)'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: lengthController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Length (Ft)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: widthController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Width (Ft)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Height (Ft)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<MaterialTier>(
                      initialValue: selectedTier,
                      items: MaterialTier.values.map((tier) {
                        return DropdownMenuItem(value: tier, child: Text(tier.title, style: GoogleFonts.inter(fontSize: 12)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedTier = val);
                      },
                      decoration: const InputDecoration(labelText: 'Specification Finish Tier'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final newRoom = RoomArea(
                              id: 'RM-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                              roomName: nameController.text.trim(),
                              lengthFt: double.tryParse(lengthController.text) ?? 12.0,
                              widthFt: double.tryParse(widthController.text) ?? 10.0,
                              heightFt: double.tryParse(heightController.text) ?? 10.0,
                              tier: selectedTier,
                              items: [],
                            );
                            setState(() {
                              _activeQuotation = _activeQuotation.copyWith(
                                rooms: [..._activeQuotation.rooms, newRoom],
                              );
                            });
                            Navigator.of(ctx).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Add Area'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openPdfPreviewModal() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860, maxHeight: 900),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppRadius.lg,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live Client Proposal PDF Preview (Dossier View)',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: PdfDocumentPreview(quotation: _activeQuotation),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openWhatsAppUrgencyModal() {
    showDialog(
      context: context,
      builder: (ctx) => WhatsAppUrgencyDialog(
        quotation: _activeQuotation,
        onDispatched: () {},
      ),
    );
  }

  void _saveQuotation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quotation ${_activeQuotation.quoteNumber} draft saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
