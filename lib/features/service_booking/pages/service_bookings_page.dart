import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/booking_card.dart';
import '../widgets/hire_labour_modal.dart';
import '../widgets/daily_checklist_modal.dart';

class ServiceBookingsPage extends StatefulWidget {
  const ServiceBookingsPage({super.key});

  @override
  State<ServiceBookingsPage> createState() => _ServiceBookingsPageState();
}

class _ServiceBookingsPageState extends State<ServiceBookingsPage> {
  final List<ServiceBooking> _bookings = List.from(LabourMockData.activeBookings);
  String _searchQuery = '';
  TradeType? _selectedTrade;
  BookingStatus? _selectedStatus;
  String _viewMode = 'Cards'; // 'Cards' or 'Table'

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    // Filter bookings
    var filtered = _bookings.where((b) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = b.bookingNumber.toLowerCase().contains(q) ||
            b.projectName.toLowerCase().contains(q) ||
            b.clientName.toLowerCase().contains(q) ||
            b.tradesmanName.toLowerCase().contains(q) ||
            b.workTitle.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedTrade != null && b.trade != _selectedTrade) return false;
      if (_selectedStatus != null && b.status != _selectedStatus) return false;
      return true;
    }).toList();

    final totalValue = _bookings.fold<double>(0.0, (sum, b) => sum + b.dealValue);
    final totalAdvances = _bookings.fold<double>(0.0, (sum, b) => sum + b.advancePaid);
    final inProgressCount = _bookings.where((b) => b.status == BookingStatus.inProgress).length;
    final completedCount = _bookings.where((b) => b.status == BookingStatus.completed).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Central Service Bookings & Dispatch Hub',
              subtitle: 'Customer & project-linked work orders, multi-tradesperson allocation, terms acknowledgement, and checklist tracking.',
              activeTab: 'Service Bookings',
              trailing: ElevatedButton.icon(
                onPressed: () => _openCreateBookingModal(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Service Booking'),
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
                  // KPI Scoreboard
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildKpiCard('Total Deal Value', '₹${(totalValue / 1000).toStringAsFixed(1)}k', 'Across ${_bookings.length} Bookings', Icons.monetization_on_outlined, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiCard('In Execution', '$inProgressCount Jobs', 'Live field workforce', Icons.engineering_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiCard('Completed & Signed', '$completedCount Orders', 'Supervisor verified', Icons.task_alt_rounded, const Color(0xFF059669), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiCard('Advance Collected', '₹${(totalAdvances / 1000).toStringAsFixed(1)}k', 'Safe escrow deposit', Icons.account_balance_wallet_outlined, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildKpiCard('Total Deal Value', '₹${(totalValue / 1000).toStringAsFixed(1)}k', 'Across ${_bookings.length} Bookings', Icons.monetization_on_outlined, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiCard('In Execution', '$inProgressCount Jobs', 'Live field workforce', Icons.engineering_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiCard('Completed & Signed', '$completedCount Orders', 'Supervisor verified', Icons.task_alt_rounded, const Color(0xFF059669), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiCard('Advance Collected', '₹${(totalAdvances / 1000).toStringAsFixed(1)}k', 'Safe escrow deposit', Icons.account_balance_wallet_outlined, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Filter & Search Toolbar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Search by booking ID, customer, project, worker name, or work scope...',
                                  prefixIcon: const Icon(Icons.search, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<BookingStatus?>(
                                initialValue: _selectedStatus,
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Statuses')),
                                  ...BookingStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))),
                                ],
                                onChanged: (val) => setState(() => _selectedStatus = val),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<TradeType?>(
                                initialValue: _selectedTrade,
                                decoration: InputDecoration(
                                  labelText: 'Trade',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Trades')),
                                  ...TradeType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))),
                                ],
                                onChanged: (val) => setState(() => _selectedTrade = val),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // View Mode Toggle
                            Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Cards View',
                                    icon: Icon(Icons.grid_view_rounded, size: 20, color: _viewMode == 'Cards' ? AppColors.primary : textSecondaryColor),
                                    onPressed: () => setState(() => _viewMode = 'Cards'),
                                  ),
                                  IconButton(
                                    tooltip: 'Table View',
                                    icon: Icon(Icons.table_rows_rounded, size: 20, color: _viewMode == 'Table' ? AppColors.primary : textSecondaryColor),
                                    onPressed: () => setState(() => _viewMode = 'Table'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Results Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${filtered.length} Service Bookings',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      const Text(
                        'Terms & Conditions Acknowledged at Dispatch',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content Display
                  if (filtered.isEmpty)
                    _buildEmptyState(surfaceColor, borderColor, textPrimaryColor, textSecondaryColor)
                  else if (_viewMode == 'Cards')
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final booking = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: BookingCard(
                            booking: booking,
                            onOpenChecklist: () => _openChecklistModal(context, booking),
                            onSettlePayment: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Settling payment for ${booking.bookingNumber}')),
                              );
                            },
                            onRaiseDispute: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening dispute file for ${booking.bookingNumber}')),
                              );
                            },
                          ),
                        );
                      },
                    )
                  else
                    _buildBookingsTable(filtered, surfaceColor, borderColor, textPrimaryColor, textSecondaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
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

  Widget _buildBookingsTable(List<ServiceBooking> bookings, Color surfaceColor, Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          horizontalMargin: 20,
          columnSpacing: 24,
          headingRowColor: WidgetStatePropertyAll(surfaceColor),
          columns: const [
            DataColumn(label: Text('Booking ID', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Customer & Project', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Tradesman', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Trade', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Deal Value', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Advance / Dues', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Dates', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
          ],
          rows: bookings.map((b) {
            return DataRow(
              cells: [
                DataCell(Text(b.bookingNumber, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary))),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(b.clientName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textPrimary)),
                      Text(b.projectName, style: TextStyle(fontSize: 10, color: textSecondary)),
                    ],
                  ),
                ),
                DataCell(
                  Text('${b.tradesmanName} (${b.tradesmenCount} workers)', style: TextStyle(fontSize: 12, color: textPrimary)),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(b.trade.icon, size: 14, color: b.trade.color),
                      const SizedBox(width: 6),
                      Text(b.trade.label.split('&').first.trim(), style: TextStyle(fontSize: 12, color: textPrimary)),
                    ],
                  ),
                ),
                DataCell(Text('₹${b.dealValue.toInt()}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimary))),
                DataCell(
                  Text('Paid ₹${b.advancePaid.toInt()} • Due ₹${b.balanceDue.toInt()}', style: TextStyle(fontSize: 11, color: textSecondary)),
                ),
                DataCell(
                  Text('${b.startDate.day}/${b.startDate.month} - ${b.endDate.day}/${b.endDate.month}', style: TextStyle(fontSize: 11, color: textSecondary)),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: b.status.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      b.status.label,
                      style: TextStyle(color: b.status.color, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Checklist',
                        icon: const Icon(Icons.checklist_rounded, size: 18, color: AppColors.primary),
                        onPressed: () => _openChecklistModal(context, b),
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

  Widget _buildEmptyState(Color bg, Color border, Color textPrimary, Color textSecondary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          const Icon(Icons.book_online_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 14),
          Text('No Service Bookings Found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 6),
          Text('Create a new booking or clear existing filters.', style: TextStyle(fontSize: 12, color: textSecondary)),
        ],
      ),
    );
  }

  void _openCreateBookingModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => HireLabourModal(
        onBookingCreated: (newBooking) {
          setState(() {
            _bookings.insert(0, newBooking);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service Booking ${newBooking.bookingNumber} created successfully.')),
          );
        },
      ),
    );
  }

  void _openChecklistModal(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => DailyChecklistModal(
        booking: booking,
        onSignOff: (updatedList, supervisorName, notes) {
          setState(() {
            final idx = _bookings.indexWhere((b) => b.id == booking.id);
            if (idx != -1) {
              _bookings[idx] = booking.copyWith(
                dailyChecklist: updatedList,
                supervisorSignOffName: supervisorName,
              );
            }
          });
        },
      ),
    );
  }
}
