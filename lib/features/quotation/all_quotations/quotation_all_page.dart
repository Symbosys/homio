import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import '../models/quotation_mock_data.dart';
import '../widgets/empty_state.dart';
import '../widgets/pdf_document_preview.dart';
import '../widgets/quotation_detail_modal.dart';
import '../widgets/quotation_filters_panel.dart';
import '../widgets/quotation_header.dart';
import '../widgets/quotation_metric_card.dart';
import '../widgets/quotation_share_dialog.dart';
import '../widgets/quotation_status_badge.dart';
import '../widgets/quotation_table.dart';
import '../widgets/whatsapp_urgency_dialog.dart';

/// Screen 1: Enterprise All Quotations & Estimates Dashboard.
/// Implements PRD Section 4.1 through 4.7, Section 5 (Quotation 360° Detail), and bulk workflows.
class QuotationAllPage extends StatefulWidget {
  const QuotationAllPage({super.key});

  @override
  State<QuotationAllPage> createState() => _QuotationAllPageState();
}

enum QuotationSortOption {
  newest('Newest First'),
  oldest('Oldest First'),
  highestValue('Highest Value'),
  lowestValue('Lowest Value'),
  expirySoonest('Expiry Date (Soonest)');

  final String label;
  const QuotationSortOption(this.label);
}

class _QuotationAllPageState extends State<QuotationAllPage> {
  late List<Quotation> _quotations;
  String _searchQuery = '';
  Set<QuotationStatus> _selectedStatuses = {};
  QuotationType? _selectedType;
  String? _selectedSalesOwner;
  RangeValues? _valueRange;
  DateTimeRange? _dateRange;
  QuotationSortOption _sortOption = QuotationSortOption.newest;
  final TextEditingController _searchController = TextEditingController();

  bool _showFilters = false;
  bool _isTableView = true;
  Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _loadQuotations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadQuotations() {
    setState(() {
      _quotations = List.from(QuotationMockData.quotations);
    });
  }

  List<Quotation> get _filteredQuotations {
    var list = _quotations.where((q) {
      // Status filter
      if (_selectedStatuses.isNotEmpty && !_selectedStatuses.contains(q.status)) {
        return false;
      }
      // Quotation Type filter
      if (_selectedType != null && q.quotationType != _selectedType) {
        return false;
      }
      // Sales owner filter
      if (_selectedSalesOwner != null && q.salesOwner != _selectedSalesOwner) {
        return false;
      }
      // Date range filter
      if (_dateRange != null) {
        if (q.submissionDate.isBefore(_dateRange!.start) ||
            q.submissionDate.isAfter(_dateRange!.end.add(const Duration(days: 1)))) {
          return false;
        }
      }
      // Search query filter
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchesNumber = q.quoteNumber.toLowerCase().contains(query);
        final matchesClient = q.clientName.toLowerCase().contains(query);
        final matchesEmail = q.clientEmail.toLowerCase().contains(query);
        final matchesPhone = q.clientPhone.contains(query);
        final matchesProject = q.projectTitle.toLowerCase().contains(query);
        final matchesLocation = q.projectLocation.toLowerCase().contains(query);
        final matchesDesigner = q.designerName.toLowerCase().contains(query);
        final matchesOwner = q.salesOwner.toLowerCase().contains(query);
        final matchesTags = q.tags.any((t) => t.toLowerCase().contains(query));

        if (!matchesNumber &&
            !matchesClient &&
            !matchesEmail &&
            !matchesPhone &&
            !matchesProject &&
            !matchesLocation &&
            !matchesDesigner &&
            !matchesOwner &&
            !matchesTags) {
          return false;
        }
      }
      return true;
    }).toList();

    // Sorting
    switch (_sortOption) {
      case QuotationSortOption.newest:
        list.sort((a, b) => b.submissionDate.compareTo(a.submissionDate));
        break;
      case QuotationSortOption.oldest:
        list.sort((a, b) => a.submissionDate.compareTo(b.submissionDate));
        break;
      case QuotationSortOption.highestValue:
        list.sort((a, b) => b.grandTotal.compareTo(a.grandTotal));
        break;
      case QuotationSortOption.lowestValue:
        list.sort((a, b) => a.grandTotal.compareTo(b.grandTotal));
        break;
      case QuotationSortOption.expirySoonest:
        list.sort((a, b) => a.discountExpiryDate.compareTo(b.discountExpiryDate));
        break;
    }

    return list;
  }

  void _duplicateQuotation(Quotation q) {
    final newIdNumber = 900 + _quotations.length + 1;
    final newQuoteNum = 'QUO-2026-0$newIdNumber';
    final duplicated = q.copyWith(
      id: newQuoteNum,
      quoteNumber: newQuoteNum,
      revisionNumber: 1,
      clientName: '${q.clientName} (Copy)',
      status: QuotationStatus.draft,
      submissionDate: DateTime.now(),
      discountExpiryDate: DateTime.now().add(const Duration(days: 7)),
    );

    setState(() {
      _quotations.insert(0, duplicated);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quotation duplicated as $newQuoteNum', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () => _openDetailModal(duplicated),
        ),
      ),
    );
  }

  void _archiveQuotation(Quotation q) {
    final idx = _quotations.indexWhere((item) => item.id == q.id);
    if (idx != -1) {
      setState(() {
        _quotations[idx] = q.copyWith(status: QuotationStatus.archived);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${q.quoteNumber} archived'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _openDetailModal(Quotation q) {
    showDialog(
      context: context,
      builder: (ctx) => QuotationDetailModal(
        quotation: q,
        onEdit: () {
          Navigator.of(ctx).pop();
          context.go(RouteNames.quoteBuilderPath);
        },
        onShare: () {
          Navigator.of(ctx).pop();
          _openShareDialog(q);
        },
        onDownloadPdf: () {
          _openPdfPreview(q);
        },
      ),
    );
  }

  void _openShareDialog(Quotation q) {
    showDialog(
      context: context,
      builder: (ctx) => QuotationShareDialog(
        quotation: q,
        onDispatched: () {
          setState(() {
            final idx = _quotations.indexWhere((item) => item.id == q.id);
            if (idx != -1 && _quotations[idx].status == QuotationStatus.draft) {
              _quotations[idx] = _quotations[idx].copyWith(status: QuotationStatus.sent);
            }
          });
        },
      ),
    );
  }

  void _openPdfPreview(Quotation q) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
          child: Column(
            children: [
              AppBar(
                title: Text('Proposal Preview: ${q.quoteNumber}'),
                leading: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _openShareDialog(q);
                    },
                    icon: const Icon(Icons.share_rounded, size: 14),
                    label: const Text('Share PDF'),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              Expanded(
                child: PdfDocumentPreview(quotation: q),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openWhatsAppUrgency(Quotation q) {
    showDialog(
      context: context,
      builder: (ctx) => WhatsAppUrgencyDialog(
        quotation: q,
        onDispatched: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('WhatsApp urgency alert triggered for ${q.clientName}'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredQuotations;

    // KPI Metrics calculation
    final totalCount = _quotations.length;
    final draftCount = _quotations.where((q) => q.status == QuotationStatus.draft).length;
    final underReviewCount = _quotations.where((q) => q.status == QuotationStatus.internalReview || q.status == QuotationStatus.underReview).length;
    final sentCount = _quotations.where((q) => q.status == QuotationStatus.sent || q.status == QuotationStatus.submitted || q.status == QuotationStatus.viewed).length;
    final acceptedCount = _quotations.where((q) => q.status == QuotationStatus.accepted || q.status == QuotationStatus.booked).length;
    final expiringSoonCount = _quotations.where((q) => !q.isDiscountExpired && q.timeRemaining.inHours <= 24).length;
    final expiredCount = _quotations.where((q) => q.isDiscountExpired || q.status == QuotationStatus.expired).length;
    final totalPipelineValue = _quotations.fold(0.0, (sum, q) => sum + q.grandTotal);
    final acceptedValue = _quotations.where((q) => q.status == QuotationStatus.accepted || q.status == QuotationStatus.booked).fold(0.0, (sum, q) => sum + q.grandTotal);
    final conversionRate = totalCount > 0 ? (acceptedCount / totalCount * 100.0) : 0.0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Header with Breadcrumbs & Actions
            QuotationHeader(
              title: 'Quotations & Dynamic Estimates',
              subtitle: 'Pipeline tracking, margin protection, WhatsApp closing bot & client proposals',
              icon: Icons.request_quote_rounded,
              breadcrumbs: const ['Homio CRM', 'Commercials', 'All Quotations'],
              onRefresh: _loadQuotations,
              onExport: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exporting master quotation pipeline to CSV...'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              primaryAction: FilledButton.icon(
                onPressed: () => context.go(RouteNames.quoteBuilderPath),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Create Quotation'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 10 Configurable KPI Metric Cards (PRD Section 4.2)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: QuotationMetricCard(
                      title: 'Total Quotes',
                      value: '$totalCount',
                      subtitle: 'All time pipeline',
                      icon: Icons.layers_rounded,
                      accentColor: AppColors.primary,
                      isSelected: _selectedStatuses.isEmpty,
                      onTap: () => setState(() => _selectedStatuses = {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 155,
                    child: QuotationMetricCard(
                      title: 'Drafts',
                      value: '$draftCount',
                      subtitle: 'Work in progress',
                      icon: Icons.edit_note_rounded,
                      accentColor: QuotationStatus.draft.color,
                      isSelected: _selectedStatuses.contains(QuotationStatus.draft),
                      onTap: () => setState(() => _selectedStatuses = {QuotationStatus.draft}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 155,
                    child: QuotationMetricCard(
                      title: 'In Review',
                      value: '$underReviewCount',
                      subtitle: 'Pricing sign-off',
                      icon: Icons.rate_review_rounded,
                      accentColor: QuotationStatus.internalReview.color,
                      isSelected: _selectedStatuses.contains(QuotationStatus.internalReview),
                      onTap: () => setState(() => _selectedStatuses = {QuotationStatus.internalReview, QuotationStatus.underReview}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 155,
                    child: QuotationMetricCard(
                      title: 'Sent / Viewed',
                      value: '$sentCount',
                      subtitle: 'Active negotiations',
                      icon: Icons.send_rounded,
                      accentColor: QuotationStatus.sent.color,
                      isSelected: _selectedStatuses.contains(QuotationStatus.sent) || _selectedStatuses.contains(QuotationStatus.viewed),
                      onTap: () => setState(() => _selectedStatuses = {QuotationStatus.sent, QuotationStatus.viewed, QuotationStatus.submitted}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 155,
                    child: QuotationMetricCard(
                      title: 'Accepted / Won',
                      value: '$acceptedCount',
                      subtitle: 'Booked to projects',
                      icon: Icons.check_circle_rounded,
                      accentColor: QuotationStatus.accepted.color,
                      isSelected: _selectedStatuses.contains(QuotationStatus.accepted),
                      onTap: () => setState(() => _selectedStatuses = {QuotationStatus.accepted, QuotationStatus.booked}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 165,
                    child: QuotationMetricCard(
                      title: 'Expiring Soon',
                      value: '$expiringSoonCount',
                      subtitle: '< 24 hours left',
                      icon: Icons.timer_rounded,
                      accentColor: const Color(0xFFEA580C),
                      isSelected: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 155,
                    child: QuotationMetricCard(
                      title: 'Discount Expired',
                      value: '$expiredCount',
                      subtitle: 'Opportunity to revise',
                      icon: Icons.timer_off_rounded,
                      accentColor: QuotationStatus.expired.color,
                      isSelected: _selectedStatuses.contains(QuotationStatus.expired),
                      onTap: () => setState(() => _selectedStatuses = {QuotationStatus.expired}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 165,
                    child: QuotationMetricCard(
                      title: 'Total Pipeline',
                      value: _formatCurrency(totalPipelineValue),
                      subtitle: 'Gross potential',
                      icon: Icons.account_balance_wallet_rounded,
                      accentColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 165,
                    child: QuotationMetricCard(
                      title: 'Booked Value',
                      value: _formatCurrency(acceptedValue),
                      subtitle: 'Won revenue',
                      icon: Icons.verified_rounded,
                      accentColor: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 155,
                    child: QuotationMetricCard(
                      title: 'Conversion Rate',
                      value: '${conversionRate.toStringAsFixed(1)}%',
                      subtitle: 'Lead to closure',
                      icon: Icons.trending_up_rounded,
                      accentColor: AppColors.primary,
                      changePercent: '+4.2%',
                      isPositive: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Search Bar & Filter Bar Controls
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search by quote #, client, mobile, project society, location, designer, or tags...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 18),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        border: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter Toggle
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _showFilters = !_showFilters),
                    icon: Icon(
                      Icons.tune_rounded,
                      size: 14,
                      color: _showFilters || _selectedStatuses.isNotEmpty || _selectedType != null
                          ? AppColors.primary
                          : null,
                    ),
                    label: Text(
                      'Filters',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _showFilters || _selectedStatuses.isNotEmpty || _selectedType != null
                            ? AppColors.primary
                            : null,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      side: BorderSide(
                        color: _showFilters || _selectedStatuses.isNotEmpty || _selectedType != null
                            ? AppColors.primary
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Sort Dropdown
                  DropdownButton<QuotationSortOption>(
                    value: _sortOption,
                    underline: const SizedBox.shrink(),
                    icon: const Icon(Icons.sort_rounded, size: 16),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    items: QuotationSortOption.values.map((opt) {
                      return DropdownMenuItem(value: opt, child: Text(opt.label));
                    }).toList(),
                    onChanged: (opt) {
                      if (opt != null) setState(() => _sortOption = opt);
                    },
                  ),
                  const SizedBox(width: 10),
                  // View mode toggle
                  IconButton(
                    icon: Icon(_isTableView ? Icons.grid_view_rounded : Icons.table_rows_rounded, size: 18),
                    tooltip: _isTableView ? 'Switch to Card View' : 'Switch to Table View',
                    onPressed: () => setState(() => _isTableView = !_isTableView),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Collapsible Filter Panel
            if (_showFilters) ...[
              QuotationFiltersPanel(
                selectedStatuses: _selectedStatuses,
                selectedType: _selectedType,
                selectedSalesOwner: _selectedSalesOwner,
                valueRange: _valueRange,
                dateRange: _dateRange,
                onStatusChanged: (s) => setState(() => _selectedStatuses = s),
                onTypeChanged: (t) => setState(() => _selectedType = t),
                onSalesOwnerChanged: (o) => setState(() => _selectedSalesOwner = o),
                onValueRangeChanged: (r) => setState(() => _valueRange = r),
                onDateRangeChanged: (d) => setState(() => _dateRange = d),
                onReset: () => setState(() {
                  _selectedStatuses = {};
                  _selectedType = null;
                  _selectedSalesOwner = null;
                  _valueRange = null;
                  _dateRange = null;
                }),
              ),
              const SizedBox(height: 14),
            ],

            // Active Filters Tags Row
            if (_selectedStatuses.isNotEmpty || _selectedType != null || _selectedSalesOwner != null || _dateRange != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Text('Active Filters: ', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          ..._selectedStatuses.map(
                            (s) => Chip(
                              label: Text(s.label, style: const TextStyle(fontSize: 10)),
                              onDeleted: () => setState(() => _selectedStatuses.remove(s)),
                              deleteIconColor: s.color,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          if (_selectedType != null)
                            Chip(
                              label: Text(_selectedType!.label, style: const TextStyle(fontSize: 10)),
                              onDeleted: () => setState(() => _selectedType = null),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                          if (_selectedSalesOwner != null)
                            Chip(
                              label: Text(_selectedSalesOwner!, style: const TextStyle(fontSize: 10)),
                              onDeleted: () => setState(() => _selectedSalesOwner = null),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                          if (_dateRange != null)
                            Chip(
                              label: Text('Date Range', style: const TextStyle(fontSize: 10)),
                              onDeleted: () => setState(() => _dateRange = null),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Content Area: Table vs Cards vs Empty
            if (filtered.isEmpty)
              QuotationEmptyState(
                icon: Icons.search_off_rounded,
                title: 'No quotations found',
                description: 'Try adjusting your search query, clearing filters, or create a brand new quotation.',
                actionLabel: 'Create Quotation',
                onAction: () => context.go(RouteNames.quoteBuilderPath),
              )
            else if (_isTableView)
              QuotationTable(
                quotations: filtered,
                selectedIds: _selectedIds,
                onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
                onViewDetail: _openDetailModal,
                onEdit: (_) => context.go(RouteNames.quoteBuilderPath),
                onShare: _openShareDialog,
                onDownloadPdf: _openPdfPreview,
                onDuplicate: _duplicateQuotation,
                onArchive: _archiveQuotation,
              )
            else
              // Grid of Cards
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 380,
                  mainAxisExtent: 220,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final q = filtered[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: AppRadius.md,
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(q.quoteNumber, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            QuotationStatusBadge(status: q.status, isCompact: true),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(q.clientName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(q.projectTitle, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Grand Total', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                Text('₹${q.grandTotal.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                              ],
                            ),
                            if (q.discountAmount > 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Discount', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                  Text('-₹${q.discountAmount.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error)),
                                ],
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              q.designerName,
                              style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility_rounded, size: 16),
                                  tooltip: '360° Detail',
                                  onPressed: () => _openDetailModal(q),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.share_rounded, size: 16),
                                  tooltip: 'Share',
                                  onPressed: () => _openShareDialog(q),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.flash_on_rounded, size: 16, color: Color(0xFF25D366)),
                                  tooltip: 'WhatsApp 24h Alert',
                                  onPressed: () => _openWhatsAppUrgency(q),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
