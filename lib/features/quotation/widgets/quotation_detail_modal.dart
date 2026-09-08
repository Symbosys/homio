import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import 'expiry_countdown.dart';
import 'quotation_status_badge.dart';
import 'quotation_timeline.dart';
import 'revision_timeline.dart';

/// Full-screen Quotation 360° Detail Modal with 10 tabs matching PRD Section 5.
class QuotationDetailModal extends StatefulWidget {
  final Quotation quotation;
  final VoidCallback? onEdit;
  final VoidCallback? onShare;
  final VoidCallback? onDownloadPdf;

  const QuotationDetailModal({
    super.key,
    required this.quotation,
    this.onEdit,
    this.onShare,
    this.onDownloadPdf,
  });

  @override
  State<QuotationDetailModal> createState() => _QuotationDetailModalState();
}

class _QuotationDetailModalState extends State<QuotationDetailModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<String> tabTitles = [
    'Overview',
    'Items & BOQ',
    'Customer',
    'Project',
    'Documents',
    'Activity',
    'Communication',
    'Payments',
    'Revisions',
    'Audit Log',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = widget.quotation;

    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              Text(
                q.quoteNumber,
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              QuotationStatusBadge(status: q.status, isCompact: true),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  q.title.isNotEmpty ? q.title : '${q.clientName} • ${q.projectTitle}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            if (widget.onDownloadPdf != null)
              OutlinedButton.icon(
                onPressed: widget.onDownloadPdf,
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 14),
                label: const Text('PDF', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            const SizedBox(width: 8),
            if (widget.onShare != null)
              OutlinedButton.icon(
                onPressed: widget.onShare,
                icon: const Icon(Icons.share_rounded, size: 14),
                label: const Text('Share / Send', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            const SizedBox(width: 8),
            if (widget.onEdit != null)
              FilledButton.icon(
                onPressed: widget.onEdit,
                icon: const Icon(Icons.edit_rounded, size: 14),
                label: const Text('Edit BOQ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            const SizedBox(width: 16),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
            tabs: tabTitles.map((t) => Tab(text: t)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(q, isDark),
            _buildItemsBoqTab(q, isDark),
            _buildCustomerTab(q, isDark),
            _buildProjectTab(q, isDark),
            _buildDocumentsTab(q, isDark),
            _buildActivityTab(q, isDark),
            _buildCommunicationTab(q, isDark),
            _buildPaymentsTab(q, isDark),
            _buildRevisionsTab(q, isDark),
            _buildAuditLogTab(q, isDark),
          ],
        ),
      ),
    );
  }

  // 1. Overview Tab
  Widget _buildOverviewTab(Quotation q, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top KPI Banner
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildMetricTile('Grand Total', '₹${q.grandTotal.toStringAsFixed(0)}', Icons.payments_rounded, isDark),
              _buildMetricTile('Gross Subtotal', '₹${q.grossSubtotal.toStringAsFixed(0)}', Icons.receipt_rounded, isDark),
              _buildMetricTile('Discount Amount', '₹${q.discountAmount.toStringAsFixed(0)}', Icons.percent_rounded, isDark),
              _buildMetricTile('Carpet Area', '${q.totalCarpetSqft.toStringAsFixed(0)} sq.ft', Icons.square_foot_rounded, isDark),
              _buildMetricTile('Rooms Count', '${q.rooms.length} Spaces', Icons.meeting_room_rounded, isDark),
            ],
          ),
          const SizedBox(height: 20),

          // Validity Countdown
          ExpiryCountdown(expiryDate: q.discountExpiryDate),
          const SizedBox(height: 20),

          // Core Info Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client & Project summary
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quotation Information', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      _buildDetailRow('Client Name', q.clientName, isDark),
                      _buildDetailRow('Client Mobile', q.clientPhone, isDark),
                      _buildDetailRow('Client Email', q.clientEmail, isDark),
                      _buildDetailRow('Project Society', q.projectTitle, isDark),
                      _buildDetailRow('Site Location', q.projectLocation, isDark),
                      _buildDetailRow('Lead Designer', q.designerName, isDark),
                      _buildDetailRow('Sales Owner', q.salesOwner, isDark),
                      _buildDetailRow('Created By', q.createdBy, isDark),
                      _buildDetailRow('Submission Date', '${q.submissionDate.day}/${q.submissionDate.month}/${q.submissionDate.year}', isDark),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Commercial Breakdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Commercial Summary', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      _buildDetailRow('Gross BOQ Amount', '₹${q.grossSubtotal.toStringAsFixed(0)}', isDark),
                      _buildDetailRow('Discount Applied', '${q.discountPercent.toStringAsFixed(1)}% (-₹${q.discountAmount.toStringAsFixed(0)})', isDark),
                      _buildDetailRow('Taxable Base', '₹${q.taxableAmount.toStringAsFixed(0)}', isDark),
                      _buildDetailRow('GST (18%)', '₹${q.gstAmount.toStringAsFixed(0)}', isDark),
                      const Divider(height: 16),
                      _buildDetailRow('Grand Total Payable', '₹${q.grandTotal.toStringAsFixed(0)}', isDark, isBold: true),
                      _buildDetailRow('Total Paid to Date', '₹${q.amountPaid.toStringAsFixed(0)}', isDark),
                      _buildDetailRow('Balance Outstanding', '₹${q.balanceDue.toStringAsFixed(0)}', isDark, isBold: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Items & BOQ Tab
  Widget _buildItemsBoqTab(Quotation q, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: q.rooms.length,
      itemBuilder: (context, idx) {
        final room = q.rooms[idx];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(room.areaType.icon, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${room.roomName} (${room.carpetSqft.toStringAsFixed(0)} sq.ft)',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Text(
                      'Subtotal: ₹${room.roomSubtotal.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...room.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(
                              item.materialSpecs,
                              style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text('${item.quantity} ${item.uom.symbol}', style: GoogleFonts.inter(fontSize: 11)),
                      const SizedBox(width: 16),
                      Text('₹${item.rate.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 11)),
                      const SizedBox(width: 16),
                      Text(
                        '₹${item.amount.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // 3. Customer Tab
  Widget _buildCustomerTab(Quotation q, bool isDark) {
    final c = q.customerInfo;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: AppRadius.md,
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Record', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            _buildDetailRow('Name', c?.name ?? q.clientName, isDark),
            _buildDetailRow('Mobile', c?.phone ?? q.clientPhone, isDark),
            _buildDetailRow('Email', c?.email ?? q.clientEmail, isDark),
            _buildDetailRow('City', c?.city ?? 'Gurgaon', isDark),
            _buildDetailRow('Address', c?.address ?? q.projectLocation, isDark),
            _buildDetailRow('Company', c?.company ?? 'Private Individual', isDark),
            _buildDetailRow('Lead Acquisition Source', c?.leadSource ?? 'Direct Referral', isDark),
          ],
        ),
      ),
    );
  }

  // 4. Project Tab
  Widget _buildProjectTab(Quotation q, bool isDark) {
    final p = q.projectInfo;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: AppRadius.md,
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Details', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            _buildDetailRow('Project Name', p?.name ?? q.projectTitle, isDark),
            _buildDetailRow('Code', p?.code ?? 'PRJ-${q.quoteNumber}', isDark),
            _buildDetailRow('Type', p?.type ?? q.quotationType.label, isDark),
            _buildDetailRow('Site Location', p?.location ?? q.projectLocation, isDark),
            _buildDetailRow('Project Manager', p?.projectManager ?? q.projectManager, isDark),
            _buildDetailRow('Lead Designer', p?.designer ?? q.designerName, isDark),
          ],
        ),
      ),
    );
  }

  // 5. Documents Tab
  Widget _buildDocumentsTab(Quotation q, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Generated PDF Artifacts', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, size: 28, color: AppColors.error),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${q.quoteNumber}_Proposal_Rev${q.revisionNumber}.pdf', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('Generated by ${q.createdBy} • 2.4 MB', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                      ],
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: widget.onDownloadPdf,
                  icon: const Icon(Icons.download_rounded, size: 14),
                  label: const Text('Download'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 6. Activity Tab
  Widget _buildActivityTab(Quotation q, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: QuotationTimeline(activities: q.activities),
    );
  }

  // 7. Communication Tab
  Widget _buildCommunicationTab(Quotation q, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Dispatch & Client Notification Logs', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.md,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
          ),
          child: Row(
            children: [
              const Icon(Icons.mark_chat_read_rounded, size: 20, color: Color(0xFF25D366)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WhatsApp Proposal Dispatch', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    Text('Delivered & read by client on ${q.clientPhone}', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  ],
                ),
              ),
              Text('Delivered', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
            ],
          ),
        ),
      ],
    );
  }

  // 8. Payments Tab
  Widget _buildPaymentsTab(Quotation q, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Milestone Payment Drawdowns', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ...q.paymentSchedule.map((m) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${m.title} (${m.percentage.toStringAsFixed(0)}%)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(m.triggerEvent, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  ],
                ),
                Row(
                  children: [
                    Text('₹${m.amount.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: m.isPaid ? AppColors.success.withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.15),
                        borderRadius: AppRadius.sm,
                      ),
                      child: Text(
                        m.isPaid ? 'PAID' : 'PENDING',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: m.isPaid ? AppColors.success : Colors.orange),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 9. Revisions Tab
  Widget _buildRevisionsTab(Quotation q, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: RevisionTimeline(revisions: q.revisions),
    );
  }

  // 10. Audit Log Tab
  Widget _buildAuditLogTab(Quotation q, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: QuotationTimeline(activities: q.activities),
    );
  }

  Widget _buildMetricTile(String title, String value, IconData icon, bool isDark) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              Text(title, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              Icon(icon, size: 14, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
