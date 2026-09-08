import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/operations_models.dart';
import '../models/operations_mock_data.dart';
import '../widgets/procurement_header.dart';
import '../widgets/procurement_kpi_card.dart';
import '../widgets/procurement_context_bar.dart';
import '../widgets/procurement_status_badge.dart';
import '../widgets/vendor_comparison_workspace.dart';
import '../widgets/vendor_rating_modal.dart';
import '../widgets/customer_operations_summary_modal.dart';

class VendorQuotationsPage extends StatefulWidget {
  final ValueChanged<VendorQuotation>? onGeneratePoFromQuote;

  const VendorQuotationsPage({super.key, this.onGeneratePoFromQuote});

  @override
  State<VendorQuotationsPage> createState() => _VendorQuotationsPageState();
}

class _VendorQuotationsPageState extends State<VendorQuotationsPage> {
  late List<VendorQuotation> _quotations;
  String _searchQuery = '';
  VendorQuotationStatus? _statusFilter;
  bool _showComparisonWorkspace = true;
  VendorQuotation? _selectedQuote;

  @override
  void initState() {
    super.initState();
    _quotations = List.from(OperationsMockData.vendorQuotations);
    if (_quotations.isNotEmpty) {
      _selectedQuote = _quotations.first;
    }
  }

  List<VendorQuotation> get _filteredQuotations {
    return _quotations.where((q) {
      final matchesSearch = _searchQuery.isEmpty ||
          q.vendorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          q.vendorQuoteNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          q.rfqNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          q.projectName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == null || q.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  // KPIs
  int get _totalQuotes => _quotations.length;
  int get _shortlistedCount =>
      _quotations.where((q) => q.status == VendorQuotationStatus.shortlisted).length;
  int get _recommendedCount =>
      _quotations.where((q) => q.status == VendorQuotationStatus.recommended).length;
  int get _approvedCount =>
      _quotations.where((q) => q.status == VendorQuotationStatus.approved).length;

  void _openRecordQuoteModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _RecordVendorQuotationModal(
        onRecorded: (newQuote) {
          setState(() {
            _quotations.insert(0, newQuote);
            _selectedQuote = newQuote;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Quotation ${newQuote.vendorQuoteNumber} recorded successfully!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openDetailModal(VendorQuotation quote) {
    showDialog(
      context: context,
      builder: (ctx) => _VendorQuotationDetailModal(
        quote: quote,
        onSelectVendor: () {
          Navigator.of(ctx).pop();
          if (widget.onGeneratePoFromQuote != null) {
            widget.onGeneratePoFromQuote!(quote);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected ${quote.vendorName}. Ready to create PO!'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
      ),
    );
  }

  void _openRatingModal(VendorQuotation quote) {
    showDialog(
      context: context,
      builder: (ctx) => VendorRatingModal(
        vendorName: quote.vendorName,
        projectName: quote.projectName,
        onSaveScorecard: (newScorecard) {
          setState(() {
            final idx = _quotations.indexWhere((q) => q.id == quote.id);
            if (idx != -1) {
              _quotations[idx] = VendorQuotation(
                id: quote.id,
                vendorQuoteNumber: quote.vendorQuoteNumber,
                rfqId: quote.rfqId,
                rfqNumber: quote.rfqNumber,
                vendorId: quote.vendorId,
                vendorName: quote.vendorName,
                vendorCode: quote.vendorCode,
                projectId: quote.projectId,
                projectName: quote.projectName,
                quoteDate: quote.quoteDate,
                validUntil: quote.validUntil,
                contactPerson: quote.contactPerson,
                contactNumber: quote.contactNumber,
                contactEmail: quote.contactEmail,
                subtotal: quote.subtotal,
                discount: quote.discount,
                tax: quote.tax,
                freight: quote.freight,
                deliveryCharges: quote.deliveryCharges,
                installationCharges: quote.installationCharges,
                packagingCharges: quote.packagingCharges,
                insurance: quote.insurance,
                grandTotal: quote.grandTotal,
                paymentTerms: quote.paymentTerms,
                advancePercent: quote.advancePercent,
                creditPeriod: quote.creditPeriod,
                deliveryTimeline: quote.deliveryTimeline,
                warrantyPeriod: quote.warrantyPeriod,
                quoteValidity: quote.quoteValidity,
                scorecard: newScorecard,
                items: quote.items,
                status: quote.status,
                recommendationRationale: quote.recommendationRationale,
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vendor scorecard updated!')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // 1. Header
          ProcurementPageHeader(
            title: 'Vendor Quotations & Comparison',
            subtitle:
                'Compare multi-vendor bids across Rate, Quality, Trust, Timeline & Warranty to select optimal partners.',
            icon: Icons.compare_arrows_rounded,
            primaryActionLabel: 'Record Vendor Quote',
            primaryActionIcon: Icons.post_add_rounded,
            onPrimaryAction: _openRecordQuoteModal,
            onRefresh: () => setState(() {}),
            secondaryAction: FilterChip(
              selected: _showComparisonWorkspace,
              avatar: const Icon(Icons.table_chart_outlined, size: 14),
              label: const Text('Side-by-Side Matrix', style: TextStyle(fontSize: 12)),
              onSelected: (val) => setState(() => _showComparisonWorkspace = val),
            ),
          ),

          // 2. Global Context Bar
          if (_selectedQuote != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: ProcurementContextBar(
                projectName: _selectedQuote!.projectName,
                siteAddress: 'The Camellias, Golf Course Road, Gurugram',
                clientName: 'Rahul Sharma',
                projectManager: 'Amit Kumar',
                projectStatus: 'Vendor Evaluation & Comparison Phase',
                procurementStatus: '${_quotations.length} Competing Vendor Quotes',
                onViewCustomerSummary: () {
                  final summary = OperationsMockData.customerSummaries.first;
                  showDialog(
                    context: context,
                    builder: (_) => CustomerOperationsSummaryModal(summary: summary),
                  );
                },
              ),
            ),

          // 3. Scrollable Dashboard Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Grid (4 Cards)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cols = constraints.maxWidth > 1100 ? 4 : 2;
                      return GridView.count(
                        crossAxisCount: cols,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 2.2,
                        children: [
                          ProcurementKpiCard(
                            title: 'Quotations Received',
                            value: '$_totalQuotes',
                            subtitle: 'Multi-vendor bids recorded',
                            icon: Icons.receipt_long_rounded,
                            color: AppColors.primary,
                            isSelected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          ProcurementKpiCard(
                            title: 'Recommended Vendor',
                            value: '$_recommendedCount',
                            subtitle: 'Best rate + quality + warranty',
                            icon: Icons.thumb_up_alt_rounded,
                            color: AppColors.success,
                            isSelected: _statusFilter == VendorQuotationStatus.recommended,
                            onTap: () => setState(
                                () => _statusFilter = VendorQuotationStatus.recommended),
                          ),
                          ProcurementKpiCard(
                            title: 'Shortlisted Bids',
                            value: '$_shortlistedCount',
                            subtitle: 'Viable alternatives',
                            icon: Icons.star_border_rounded,
                            color: const Color(0xFF06B6D4),
                            isSelected: _statusFilter == VendorQuotationStatus.shortlisted,
                            onTap: () => setState(
                                () => _statusFilter = VendorQuotationStatus.shortlisted),
                          ),
                          ProcurementKpiCard(
                            title: 'Approved for PO',
                            value: '$_approvedCount',
                            subtitle: 'Ready for Purchase Order',
                            icon: Icons.check_circle_outline_rounded,
                            color: const Color(0xFF10B981),
                            isSelected: _statusFilter == VendorQuotationStatus.approved,
                            onTap: () => setState(
                                () => _statusFilter = VendorQuotationStatus.approved),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Side-by-Side Comparison Workspace
                  if (_showComparisonWorkspace) ...[
                    VendorComparisonWorkspace(
                      quotations: _filteredQuotations,
                      rfqTitle: 'Plywood & Hardware Requisition • The Camellias #1402',
                      onSelectVendor: (q) => _openDetailModal(q),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Quotations List Table
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Recorded Vendor Quotations (${_filteredQuotations.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search vendor, quote #, RFQ...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 18),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _buildQuotationsTable(isDark, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationsTable(bool isDark, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
          ),
          columnSpacing: 20,
          horizontalMargin: 16,
          columns: const [
            DataColumn(label: Text('VENDOR', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('QUOTE NUMBER', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('REF RFQ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('TOTAL VALUE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('TIMELINE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('WARRANTY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('SCORE / RATING', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          ],
          rows: _filteredQuotations.map((quote) {
            final isSelected = quote.id == _selectedQuote?.id;
            return DataRow(
              selected: isSelected,
              onSelectChanged: (_) => setState(() => _selectedQuote = quote),
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(quote.vendorName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      Text('Attn: ${quote.contactPerson}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                DataCell(Text(quote.vendorQuoteNumber,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataCell(Text(quote.rfqNumber, style: const TextStyle(fontSize: 12))),
                DataCell(
                  Text(
                    '₹${quote.grandTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
                DataCell(Text(quote.deliveryTimeline, style: const TextStyle(fontSize: 12))),
                DataCell(Text(quote.warrantyPeriod, style: const TextStyle(fontSize: 12))),
                DataCell(
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text(
                        '${quote.scorecard.overallRating} ★',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                DataCell(ProcurementStatusBadge.vendorQuotation(quote.status)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.rate_review_outlined, size: 18),
                        tooltip: 'Evaluate / Score Vendor',
                        onPressed: () => _openRatingModal(quote),
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        tooltip: 'View Full Quote & Commercials',
                        onPressed: () => _openDetailModal(quote),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// ============================================================================
/// RECORD VENDOR QUOTATION MODAL
/// ============================================================================
class _RecordVendorQuotationModal extends StatefulWidget {
  final ValueChanged<VendorQuotation> onRecorded;

  const _RecordVendorQuotationModal({required this.onRecorded});

  @override
  State<_RecordVendorQuotationModal> createState() =>
      _RecordVendorQuotationModalState();
}

class _RecordVendorQuotationModalState
    extends State<_RecordVendorQuotationModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vendorNameCtrl =
      TextEditingController(text: 'Century Wholesale Hub');
  final TextEditingController _quoteNumberCtrl =
      TextEditingController(text: 'QT-CEN-2026-992');
  final TextEditingController _amountCtrl =
      TextEditingController(text: '216080');
  final TextEditingController _deliveryTimelineCtrl =
      TextEditingController(text: '2 Days');
  final TextEditingController _warrantyCtrl =
      TextEditingController(text: '25 Years (IS:710)');
  final TextEditingController _contactCtrl =
      TextEditingController(text: 'Sunil Aggarwal');

  @override
  void dispose() {
    _vendorNameCtrl.dispose();
    _quoteNumberCtrl.dispose();
    _amountCtrl.dispose();
    _deliveryTimelineCtrl.dispose();
    _warrantyCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final total = double.tryParse(_amountCtrl.text) ?? 200000;
    final newQuote = VendorQuotation(
      id: 'vq_${DateTime.now().millisecondsSinceEpoch}',
      vendorQuoteNumber: _quoteNumberCtrl.text,
      rfqId: 'rfq-001',
      rfqNumber: 'RFQ-2026-00084',
      vendorId: 'VND-001',
      vendorName: _vendorNameCtrl.text,
      vendorCode: 'VND-CEN-01',
      projectId: 'PRJ-CAM-01',
      projectName: 'The Camellias Villa Interior #1402',
      quoteDate: DateTime.now(),
      validUntil: DateTime.now().add(const Duration(days: 15)),
      contactPerson: _contactCtrl.text,
      contactNumber: '+91 98101 33412',
      contactEmail: 'quotes@centuryhub.in',
      subtotal: total * 0.85,
      tax: total * 0.15,
      grandTotal: total,
      deliveryTimeline: _deliveryTimelineCtrl.text,
      warrantyPeriod: _warrantyCtrl.text,
      scorecard: VendorScorecard(
        rateScore: 8.5,
        qualityScore: 9.0,
        trustScore: 8.8,
        timelineScore: 9.0,
        warrantyScore: 9.5,
        overallRating: 4.8,
        evaluatedDate: DateTime.now(),
      ),
      items: const [
        VendorQuotationItem(
          itemName: 'Century Club Prime BWP Marine Plywood 19mm',
          materialSpecification: 'IS:710 Calibrated 19mm',
          brand: 'Century Club Prime',
          quantity: 45,
          unit: 'Sheets (8x4)',
          unitRate: 2820,
          total: 126900,
          deliveryDays: '2 Days',
          warrantyPeriod: '25 Years',
        ),
      ],
      status: VendorQuotationStatus.received,
    );
    widget.onRecorded(newQuote);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 640,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.post_add_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Record Vendor Quotation',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            )),
                        Text('Record supplier quotation received via email, portal, or physical bid.',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _vendorNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Vendor Name *',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _quoteNumberCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Vendor Quote # *',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Grand Total Amount (₹) *',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _deliveryTimelineCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Timeline (e.g. 2 Days) *',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _warrantyCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Warranty Period *',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _contactCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Contact Person',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text('Save Quotation'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
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
}

/// ============================================================================
/// VENDOR QUOTATION DETAIL MODAL
/// ============================================================================
class _VendorQuotationDetailModal extends StatelessWidget {
  final VendorQuotation quote;
  final VoidCallback onSelectVendor;

  const _VendorQuotationDetailModal({
    required this.quote,
    required this.onSelectVendor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 820,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(quote.vendorName,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                          const SizedBox(width: 10),
                          ProcurementStatusBadge.vendorQuotation(quote.status),
                        ],
                      ),
                      Text('Quote Ref: ${quote.vendorQuoteNumber} • For RFQ: ${quote.rfqNumber}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),

            // Commercial breakdown card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('Total Value', '₹${quote.grandTotal.toStringAsFixed(0)}', AppColors.primary),
                  _buildMetric('Lead Time', quote.deliveryTimeline, AppColors.info),
                  _buildMetric('Warranty', quote.warrantyPeriod, AppColors.success),
                  _buildMetric('Rating', '${quote.scorecard.overallRating} ★', AppColors.gold),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scorecard breakdown
            Text('Evaluation Scorecard',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Rate: ${quote.scorecard.rateScore}/10 • Quality: ${quote.scorecard.qualityScore}/10 • Trust: ${quote.scorecard.trustScore}/10 • Timeline: ${quote.scorecard.timelineScore}/10 • Warranty: ${quote.scorecard.warrantyScore}/10',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text('Evaluator Feedback: "${quote.scorecard.feedback}"',
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextSecondary,
                )),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onSelectVendor,
                  icon: const Icon(Icons.check_circle_rounded, size: 16),
                  label: const Text('Approve & Generate Purchase Order'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: color)),
      ],
    );
  }
}
