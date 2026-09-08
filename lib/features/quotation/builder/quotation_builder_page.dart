import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/customer_selector.dart';
import '../widgets/discount_editor.dart';
import '../widgets/document_builder.dart';
import '../widgets/item_picker_dialog.dart';
import '../widgets/payment_schedule_editor.dart';
import '../widgets/pdf_document_preview.dart';
import '../widgets/pricing_summary.dart';
import '../widgets/project_selector.dart';
import '../widgets/quotation_header.dart';
import '../widgets/quotation_share_dialog.dart';
import '../widgets/quotation_stepper.dart';
import '../widgets/rate_card_manager.dart';
import '../widgets/room_builder.dart';
import '../widgets/terms_editor.dart';
import '../widgets/visibility_controls.dart';

/// Screen 2: 11-Step Multi-Stage Quotation Wizard Builder matching PRD Section 7 to 25.
class QuotationBuilderPage extends StatefulWidget {
  const QuotationBuilderPage({super.key});

  @override
  State<QuotationBuilderPage> createState() => _QuotationBuilderPageState();
}

class _QuotationBuilderPageState extends State<QuotationBuilderPage> {
  int _currentStep = 0;
  late Quotation _q;

  static const List<String> stepNames = [
    'Basic Details',
    'Customer & Project',
    'Areas / Rooms',
    'Items & BOQ',
    'Rate Card & Pricing',
    'Discount & Expiry',
    'Terms & Warranty',
    'Payment Milestones',
    'Document Design',
    'Proposal Preview',
    'Review & Send',
  ];

  // Step 0 controllers
  final _quoteNumCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final base = QuotationMockData.quotations.first;
    _q = base.copyWith(
      id: 'QUO-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      quoteNumber: 'QUO-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      title: 'New Interior Estimation Proposal',
      status: QuotationStatus.draft,
      submissionDate: DateTime.now(),
      discountExpiryDate: DateTime.now().add(const Duration(days: 7)),
    );

    _quoteNumCtrl.text = _q.quoteNumber;
    _titleCtrl.text = _q.title;
    _notesCtrl.text = _q.internalNotes ?? '';
  }

  @override
  void dispose() {
    _quoteNumCtrl.dispose();
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < stepNames.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quotation ${_q.quoteNumber} saved as draft!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _openItemPickerForRoom(int roomIndex) {
    showDialog(
      context: context,
      builder: (ctx) => ItemPickerDialog(
        onItemSelected: (master) {
          final newItem = QuotationItem(
            id: 'QI-${DateTime.now().millisecondsSinceEpoch}',
            itemMasterId: master.id,
            itemCode: master.sku,
            name: master.name,
            category: master.category,
            materialSpecs: master.technicalSpecs,
            uom: master.uom,
            quantity: 1.0,
            rate: master.sellingRate,
            marginPercent: master.marginPercent,
          );
          final updatedRooms = List<RoomArea>.from(_q.rooms);
          final updatedRoomItems = List<QuotationItem>.from(updatedRooms[roomIndex].items)..add(newItem);
          updatedRooms[roomIndex] = updatedRooms[roomIndex].copyWith(items: updatedRoomItems);

          setState(() {
            _q = _q.copyWith(rooms: updatedRooms);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Responsive Header
            QuotationHeader(
              title: 'Multi-Step Quotation & BOQ Builder',
              subtitle: '11-Step end-to-end estimation wizard, rate overrides, payment schedules & PDF designer',
              icon: Icons.architecture_rounded,
              breadcrumbs: const ['Homio CRM', 'Commercials', 'Builder'],
              primaryAction: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => context.go(RouteNames.quotationsAll),
                    icon: const Icon(Icons.arrow_back_rounded, size: 14),
                    label: const Text('All Quotes'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _saveDraft,
                    icon: const Icon(Icons.save_rounded, size: 14),
                    label: const Text('Save Draft'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal Stepper Bar
            QuotationStepper(
              currentStep: _currentStep,
              stepTitles: stepNames,
              onStepTapped: (index) => setState(() => _currentStep = index),
            ),
            const SizedBox(height: 18),

            // Main Body: Responsive Split Layout (Left: Step Content, Right: Sticky Financial Summary)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Step Content
                Expanded(
                  flex: isDesktop ? 68 : 100,
                  child: Column(
                    children: [
                      _buildCurrentStepContent(isDark),
                      const SizedBox(height: 20),

                      // Navigation Buttons Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentStep > 0)
                            OutlinedButton.icon(
                              onPressed: _prevStep,
                              icon: const Icon(Icons.arrow_back_rounded, size: 16),
                              label: Text('Back: ${stepNames[_currentStep - 1]}'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          if (_currentStep < stepNames.length - 1)
                            FilledButton.icon(
                              onPressed: _nextStep,
                              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                              label: Text('Next: ${stepNames[_currentStep + 1]}'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                              ),
                            )
                          else
                            FilledButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => QuotationShareDialog(quotation: _q),
                                );
                              },
                              icon: const Icon(Icons.send_rounded, size: 16),
                              label: const Text('Dispatch Proposal Now'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF25D366),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right Sticky Pricing Summary (on desktop)
                if (isDesktop) ...[
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 32,
                    child: PricingSummary(
                      grossSubtotal: _q.grossSubtotal,
                      discountAmount: _q.discountAmount,
                      discountPercent: _q.discountPercent,
                      taxableAmount: _q.taxableAmount,
                      gstPercent: _q.gstPercent,
                      gstAmount: _q.gstAmount,
                      grandTotal: _q.grandTotal,
                      amountPaid: _q.amountPaid,
                      actionLabel: _currentStep < stepNames.length - 1
                          ? 'Next: ${stepNames[_currentStep + 1]}'
                          : 'Review & Send Proposal',
                      onProceed: _currentStep < stepNames.length - 1
                          ? _nextStep
                          : () {
                              showDialog(
                                context: context,
                                builder: (ctx) => QuotationShareDialog(quotation: _q),
                              );
                            },
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep0BasicDetails(isDark);
      case 1:
        return _buildStep1CustomerAndProject(isDark);
      case 2:
        return _buildStep2RoomsAndAreas(isDark);
      case 3:
        return _buildStep3ItemsAndBoq(isDark);
      case 4:
        return _buildStep4RateCardsAndPricing(isDark);
      case 5:
        return _buildStep5DiscountAndExpiry(isDark);
      case 6:
        return _buildStep6TermsAndWarranty(isDark);
      case 7:
        return _buildStep7PaymentMilestones(isDark);
      case 8:
        return _buildStep8DocumentDesign(isDark);
      case 9:
        return _buildStep9ProposalPreview(isDark);
      case 10:
        return _buildStep10ReviewAndSend(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 0: Basic Details
  Widget _buildStep0BasicDetails(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Quotation Identification & Metadata', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _quoteNumCtrl,
                  decoration: InputDecoration(
                    labelText: 'Quotation Number *',
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                  onChanged: (v) => setState(() => _q = _q.copyWith(quoteNumber: v)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: DropdownButtonFormField<QuotationType>(
                  initialValue: _q.quotationType,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Quotation Category *',
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                  items: QuotationType.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                      .toList(),
                  onChanged: (t) {
                    if (t != null) setState(() => _q = _q.copyWith(quotationType: t));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              labelText: 'Proposal Title *',
              hintText: 'e.g. 4BHK Luxury Turnkey Execution Proposal',
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
            ),
            onChanged: (v) => setState(() => _q = _q.copyWith(title: v)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _q.salesOwner,
                  decoration: InputDecoration(
                    labelText: 'Commercial Owner / Sales Lead',
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                  onChanged: (v) => setState(() => _q = _q.copyWith(salesOwner: v)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextFormField(
                  initialValue: _q.designerName,
                  decoration: InputDecoration(
                    labelText: 'Principal Interior Architect',
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                  onChanged: (v) => setState(() => _q = _q.copyWith(designerName: v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _notesCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Internal CRM Notes & Discovery Context',
              hintText: 'Add remarks from site visit or client budget discussions...',
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
            ),
            onChanged: (v) => setState(() => _q = _q.copyWith(internalNotes: v)),
          ),
        ],
      ),
    );
  }

  // Step 1: Customer & Project
  Widget _buildStep1CustomerAndProject(bool isDark) {
    return Column(
      children: [
        CustomerSelector(
          selectedCustomer: _q.customerInfo,
          onCustomerSelected: (cust) {
            setState(() {
              _q = _q.copyWith(
                customerInfo: cust,
                clientName: cust.name,
                clientPhone: cust.phone,
                clientEmail: cust.email,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        ProjectSelector(
          selectedProject: _q.projectInfo,
          onProjectSelected: (prj) {
            setState(() {
              _q = _q.copyWith(
                projectInfo: prj,
                projectTitle: prj.name,
                projectLocation: prj.location,
                designerName: prj.designer,
                projectManager: prj.projectManager,
              );
            });
          },
        ),
      ],
    );
  }

  // Step 2: Rooms & Areas
  Widget _buildStep2RoomsAndAreas(bool isDark) {
    return RoomBuilder(
      rooms: _q.rooms,
      onRoomsChanged: (rooms) => setState(() => _q = _q.copyWith(rooms: rooms)),
    );
  }

  // Step 3: Items & BOQ
  Widget _buildStep3ItemsAndBoq(bool isDark) {
    if (_q.rooms.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, size: 36, color: AppColors.warning),
            const SizedBox(height: 10),
            Text('No rooms created yet. Please go back to Step 3 and add at least one room.', style: GoogleFonts.inter(fontSize: 14)),
          ],
        ),
      );
    }

    return Column(
      children: _q.rooms.asMap().entries.map((entry) {
        final roomIdx = entry.key;
        final room = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(room.areaType.icon, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('${room.roomName} (${room.items.length} items)', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  FilledButton.icon(
                    onPressed: () => _openItemPickerForRoom(roomIdx),
                    icon: const Icon(Icons.add_rounded, size: 14),
                    label: const Text('Add Line Item'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              if (room.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text('No items in this room yet. Click above to pick from catalogue.', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  ),
                )
              else
                ...room.items.asMap().entries.map((itemEntry) {
                  final itemIdx = itemEntry.key;
                  final item = itemEntry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                              Text(item.materialSpecs, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextFormField(
                            initialValue: item.quantity.toStringAsFixed(0),
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.inter(fontSize: 11),
                            decoration: InputDecoration(labelText: 'Qty', isDense: true, contentPadding: const EdgeInsets.all(6), border: OutlineInputBorder(borderRadius: AppRadius.sm)),
                            onChanged: (val) {
                              final qVal = double.tryParse(val) ?? item.quantity;
                              final updatedRooms = List<RoomArea>.from(_q.rooms);
                              final updatedItems = List<QuotationItem>.from(room.items);
                              updatedItems[itemIdx] = item.copyWith(quantity: qVal);
                              updatedRooms[roomIdx] = room.copyWith(items: updatedItems);
                              setState(() => _q = _q.copyWith(rooms: updatedRooms));
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(item.uom.symbol, style: GoogleFonts.inter(fontSize: 10)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 75,
                          child: TextFormField(
                            initialValue: item.rate.toStringAsFixed(0),
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.inter(fontSize: 11),
                            decoration: InputDecoration(labelText: 'Rate', isDense: true, contentPadding: const EdgeInsets.all(6), border: OutlineInputBorder(borderRadius: AppRadius.sm)),
                            onChanged: (val) {
                              final rVal = double.tryParse(val) ?? item.rate;
                              final updatedRooms = List<RoomArea>.from(_q.rooms);
                              final updatedItems = List<QuotationItem>.from(room.items);
                              updatedItems[itemIdx] = item.copyWith(rate: rVal);
                              updatedRooms[roomIdx] = room.copyWith(items: updatedItems);
                              setState(() => _q = _q.copyWith(rooms: updatedRooms));
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('₹${item.amount.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 14, color: AppColors.error),
                          onPressed: () {
                            final updatedRooms = List<RoomArea>.from(_q.rooms);
                            final updatedItems = List<QuotationItem>.from(room.items)..removeAt(itemIdx);
                            updatedRooms[roomIdx] = room.copyWith(items: updatedItems);
                            setState(() => _q = _q.copyWith(rooms: updatedRooms));
                          },
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Step 4: Rate Cards & Pricing
  Widget _buildStep4RateCardsAndPricing(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RateCardManager(
          rateCards: QuotationMockData.rateCards,
          onSelectRateCard: (rc) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Applied ${rc.name} markup (+${rc.markupPercent.toStringAsFixed(0)}%) to all items.'), backgroundColor: AppColors.success),
            );
          },
        ),
      ],
    );
  }

  // Step 5: Discount & Expiry
  Widget _buildStep5DiscountAndExpiry(bool isDark) {
    return DiscountEditor(
      grossSubtotal: _q.grossSubtotal,
      discountType: _q.discountType,
      discountPercent: _q.discountPercent,
      fixedDiscountAmount: _q.fixedDiscountAmount,
      discountExpiryDate: _q.discountExpiryDate,
      onDiscountChanged: ({required type, required percent, required fixedAmount, required expiryDate}) {
        setState(() {
          _q = _q.copyWith(
            discountType: type,
            discountPercent: percent,
            fixedDiscountAmount: fixedAmount,
            discountExpiryDate: expiryDate,
          );
        });
      },
    );
  }

  // Step 6: Terms & Warranty
  Widget _buildStep6TermsAndWarranty(bool isDark) {
    return TermsEditor(
      initialTerms: _q.termsAndConditions,
      onTermsChanged: (terms) => setState(() => _q = _q.copyWith(termsAndConditions: terms)),
    );
  }

  // Step 7: Payment Milestones
  Widget _buildStep7PaymentMilestones(bool isDark) {
    return PaymentScheduleEditor(
      totalPayableAmount: _q.grandTotal,
      initialSchedule: _q.paymentSchedule,
      onScheduleChanged: (schedule) => setState(() => _q = _q.copyWith(paymentSchedule: schedule)),
    );
  }

  // Step 8: Document Design & Visibility
  Widget _buildStep8DocumentDesign(bool isDark) {
    return Column(
      children: [
        DocumentBuilder(
          config: _q.documentConfig,
          onConfigChanged: (cfg) => setState(() => _q = _q.copyWith(documentConfig: cfg)),
        ),
        const SizedBox(height: 16),
        VisibilityControls(
          settings: _q.visibilitySettings,
          onChanged: (vs) => setState(() => _q = _q.copyWith(visibilitySettings: vs, hideRate: vs.hideRate, hideSqft: vs.hideSqft, showAmount: vs.showAmount)),
        ),
      ],
    );
  }

  // Step 9: Proposal Preview
  Widget _buildStep9ProposalPreview(bool isDark) {
    return Container(
      height: 850,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      child: PdfDocumentPreview(quotation: _q),
    );
  }

  // Step 10: Review & Send
  Widget _buildStep10ReviewAndSend(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded, size: 24, color: AppColors.success),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ready to Dispatch Proposal', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text('${_q.quoteNumber} • ${_q.clientName} (${_q.clientPhone})', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Review points table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
              borderRadius: AppRadius.sm,
            ),
            child: Column(
              children: [
                _buildSummaryLine('Project', _q.projectTitle, isDark),
                _buildSummaryLine('Configured Spaces', '${_q.rooms.length} Rooms (${_q.totalCarpetSqft.toStringAsFixed(0)} sq.ft)', isDark),
                _buildSummaryLine('Gross BOQ', '₹${_q.grossSubtotal.toStringAsFixed(0)}', isDark),
                _buildSummaryLine('Discount', '-₹${_q.discountAmount.toStringAsFixed(0)} (${_q.discountPercent.toStringAsFixed(1)}%)', isDark),
                _buildSummaryLine('Taxable Base', '₹${_q.taxableAmount.toStringAsFixed(0)}', isDark),
                _buildSummaryLine('GST (18%)', '₹${_q.gstAmount.toStringAsFixed(0)}', isDark),
                const Divider(height: 14),
                _buildSummaryLine('Net Grand Total', '₹${_q.grandTotal.toStringAsFixed(0)}', isDark, isBold: true),
                _buildSummaryLine('Price Lock Valid Until', '${_q.discountExpiryDate.day}/${_q.discountExpiryDate.month}/${_q.discountExpiryDate.year}', isDark),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Dispatch Options:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => QuotationShareDialog(quotation: _q),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 14),
                label: const Text('Send via WhatsApp Business'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Proposal PDF generated and downloaded as ${_q.quoteNumber}.pdf'), backgroundColor: AppColors.primary),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 14),
                label: const Text('Download High-Res PDF'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value, bool isDark, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
