import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/payment_claim_modal.dart';

class LabourWagePaymentsPage extends StatefulWidget {
  const LabourWagePaymentsPage({super.key});

  @override
  State<LabourWagePaymentsPage> createState() => _LabourWagePaymentsPageState();
}

class _LabourWagePaymentsPageState extends State<LabourWagePaymentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<LabourPaymentRecord> _payments = List.from(LabourMockData.paymentRecords);
  final List<PaymentClaim> _claims = List.from(LabourMockData.paymentClaims);
  String _searchQuery = '';
  String _statusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final totalPaid = _payments.fold<double>(0.0, (sum, p) => sum + p.amountPaid);
    final totalDue = _payments.fold<double>(0.0, (sum, p) => sum + p.amountDue);
    final totalGross = _payments.fold<double>(0.0, (sum, p) => sum + p.grossAmount);
    final totalCommission = _payments.fold<double>(0.0, (sum, p) => sum + p.platformCommission);

    var filteredPayments = _payments.where((p) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = p.workerName.toLowerCase().contains(q) ||
            p.bookingNumber.toLowerCase().contains(q) ||
            p.projectName.toLowerCase().contains(q) ||
            p.transactionRef.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_statusFilter != 'All' && p.status != _statusFilter) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Labour Wage Ledger & Financial Settlements',
              subtitle: 'Transparent accounting integration for tradesperson daily wage claims, platform commissions, deductions, and banking settlements.',
              activeTab: 'Labour Payments',
              trailing: ElevatedButton.icon(
                onPressed: () => _openNewClaimModal(context),
                icon: const Icon(Icons.add_card_rounded, size: 16),
                label: const Text('Submit Payment Claim'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Financial KPIs
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildFinanceCard('Total Gross Billed', '₹${(totalGross / 1000).toStringAsFixed(1)}k', 'Across all trade orders', Icons.receipt_long_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildFinanceCard('Amount Disbursed', '₹${(totalPaid / 1000).toStringAsFixed(1)}k', 'Direct IMPS/UPI transfers', Icons.check_circle_outline_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildFinanceCard('Outstanding Dues', '₹${(totalDue / 1000).toStringAsFixed(1)}k', 'Pending supervisor verify', Icons.hourglass_top_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildFinanceCard('Platform Margin (10%)', '₹${(totalCommission / 1000).toStringAsFixed(1)}k', 'Platform commission', Icons.pie_chart_outline_rounded, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildFinanceCard('Total Gross Billed', '₹${(totalGross / 1000).toStringAsFixed(1)}k', 'Across all trade orders', Icons.receipt_long_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildFinanceCard('Amount Disbursed', '₹${(totalPaid / 1000).toStringAsFixed(1)}k', 'Direct IMPS/UPI transfers', Icons.check_circle_outline_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildFinanceCard('Outstanding Dues', '₹${(totalDue / 1000).toStringAsFixed(1)}k', 'Pending supervisor verify', Icons.hourglass_top_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildFinanceCard('Platform Margin (10%)', '₹${(totalCommission / 1000).toStringAsFixed(1)}k', 'Platform commission', Icons.pie_chart_outline_rounded, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Filter Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search payments by worker name, booking #, project or txn ID...',
                              prefixIcon: const Icon(Icons.search, size: 18),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: _statusFilter,
                            decoration: InputDecoration(
                              labelText: 'Payment Status',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'All', child: Text('All Payments')),
                              DropdownMenuItem(value: 'Settled', child: Text('Settled')),
                              DropdownMenuItem(value: 'Pending Verification', child: Text('Pending Verification')),
                              DropdownMenuItem(value: 'Flagged', child: Text('Flagged')),
                            ],
                            onChanged: (val) => setState(() => _statusFilter = val ?? 'All'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tabs: Payment Records vs Claims Queue
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: textSecondaryColor,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      tabs: [
                        Tab(text: 'Settled & Pending Payments (${_payments.length})'),
                        Tab(text: 'Incoming Labour Claims Queue (${_claims.length})'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tab Views
                  SizedBox(
                    height: 520,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Payment Records Ledger
                        _buildPaymentLedger(filteredPayments, surfaceColor, borderColor, textPrimaryColor, textSecondaryColor),

                        // Tab 2: Claims Review Queue
                        _buildClaimsQueue(_claims, surfaceColor, borderColor, textPrimaryColor, textSecondaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceCard(String title, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, color: textMuted)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentLedger(List<LabourPaymentRecord> records, Color surfaceColor, Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          horizontalMargin: 20,
          columnSpacing: 22,
          headingRowColor: WidgetStatePropertyAll(surfaceColor),
          columns: const [
            DataColumn(label: Text('Payment Ref / Booking', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Tradesman', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Project / Milestone', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Gross Billed', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Deductions / Commission', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Net Payable', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Disbursed', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Dues', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.w700))),
          ],
          rows: records.map((p) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(p.id, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: textPrimary)),
                      Text(p.bookingNumber, style: TextStyle(fontSize: 11, color: textSecondary)),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(p.workerName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimary)),
                      Text(p.workerId, style: TextStyle(fontSize: 10, color: textSecondary)),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(p.projectName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textPrimary)),
                      Text(p.billingPeriod, style: TextStyle(fontSize: 10, color: textSecondary)),
                    ],
                  ),
                ),
                DataCell(Text('₹${p.grossAmount.toInt()}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimary))),
                DataCell(
                  Text('Comm: ₹${p.platformCommission.toInt()} • Ded: ₹${p.deductions.toInt()}', style: TextStyle(fontSize: 11, color: textSecondary)),
                ),
                DataCell(
                  Text('₹${p.netPayable.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFF10B981))),
                ),
                DataCell(
                  Text('₹${p.amountPaid.toInt()}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimary)),
                ),
                DataCell(
                  Text(
                    p.amountDue > 0 ? '₹${p.amountDue.toInt()}' : '₹0 (Settled)',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: p.amountDue > 0 ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (p.status == 'Settled' || p.status == 'Paid' ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      p.status,
                      style: TextStyle(
                        color: p.status == 'Settled' || p.status == 'Paid' ? const Color(0xFF059669) : Colors.amber.shade800,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  IconButton(
                    tooltip: 'View Receipt',
                    icon: const Icon(Icons.receipt_outlined, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Viewing bank reference ${p.transactionRef}')),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildClaimsQueue(List<PaymentClaim> claims, Color surfaceColor, Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: claims.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: borderColor),
        itemBuilder: (context, index) {
          final claim = claims[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.description_outlined, color: Color(0xFF10B981), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(claim.workerName, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textPrimary)),
                          const SizedBox(width: 8),
                          Text('Booking: ${claim.bookingNumber}', style: TextStyle(fontSize: 11, color: textSecondary)),
                          const Spacer(),
                          Text('Claimed: ₹${claim.amountClaimed.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(claim.workSummary, style: TextStyle(fontSize: 11, color: textSecondary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.verified_outlined, size: 13, color: textSecondary),
                          const SizedBox(width: 4),
                          Text(claim.supervisorConfirmation, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textSecondary)),
                          const SizedBox(width: 14),
                          Text('Submitted: ${claim.submittedDate.day}/${claim.submittedDate.month}/${claim.submittedDate.year}', style: TextStyle(fontSize: 10, color: textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      claims.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment Claim ${claim.id} approved and queued for NEFT release.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Authorize Payout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openNewClaimModal(BuildContext context) {
    if (LabourMockData.activeBookings.isNotEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => PaymentClaimModal(
          booking: LabourMockData.activeBookings.first,
          onClaimSubmitted: (newClaim) {
            setState(() {
              _claims.insert(0, newClaim);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment Claim ${newClaim.id} submitted for supervisor review.')),
            );
          },
        ),
      );
    }
  }
}
