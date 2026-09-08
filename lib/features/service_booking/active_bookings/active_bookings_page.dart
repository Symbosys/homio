import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/booking_card.dart';
import '../widgets/daily_checklist_modal.dart';
import '../widgets/hire_labour_modal.dart';
import '../widgets/legal_dispute_modal.dart';

class ActiveBookingsPage extends StatefulWidget {
  const ActiveBookingsPage({super.key});

  @override
  State<ActiveBookingsPage> createState() => _ActiveBookingsPageState();
}

class _ActiveBookingsPageState extends State<ActiveBookingsPage> {
  final List<ServiceBooking> _bookings = List.from(LabourMockData.activeBookings);
  String _searchQuery = '';
  String? _selectedProjectId;
  BookingStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    var filtered = _bookings.where((b) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = b.bookingNumber.toLowerCase().contains(q) ||
            b.projectName.toLowerCase().contains(q) ||
            b.tradesmanName.toLowerCase().contains(q) ||
            b.clientName.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedProjectId != null && b.projectId != _selectedProjectId) return false;
      if (_selectedStatus != null && b.status != _selectedStatus) return false;
      return true;
    }).toList();

    final activeCount = _bookings.where((b) => b.status == BookingStatus.inProgress).length;
    final signedCount = _bookings.where((b) => b.status == BookingStatus.checklistSigned).length;
    final completedCount = _bookings.where((b) => b.status == BookingStatus.completed).length;
    final totalDues = _bookings.map((b) => b.balanceDue).reduce((a, b) => a + b);

    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Active Service Bookings & Daily Checklists',
              subtitle: 'Monitor real-time site deployments, geo-fenced GPS attendance, daily supervisor quality sign-offs, and milestone payouts.',
              activeTab: 'Active Deployments',
              trailing: ElevatedButton.icon(
                onPressed: () => _openCreateBooking(context),
                icon: const Icon(Icons.add_task_rounded, size: 16),
                label: const Text('Create Service Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Cards
                  Row(
                    children: [
                      _buildMetricCard(
                        title: 'Active On-Site Jobs',
                        value: '$activeCount Bookings',
                        subtitle: 'GPS check-in verified',
                        icon: Icons.construction_rounded,
                        color: const Color(0xFF0284C7),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Signed Today Checklists',
                        value: '$signedCount Signed',
                        subtitle: 'Supervisor inspected',
                        icon: Icons.fact_check_rounded,
                        color: const Color(0xFF10B981),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Completed & Handed Over',
                        value: '$completedCount Jobs',
                        subtitle: 'Full settlement ready',
                        icon: Icons.task_alt_rounded,
                        color: const Color(0xFF8B5CF6),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                      const SizedBox(width: 14),
                      _buildMetricCard(
                        title: 'Unsettled Wage Dues',
                        value: '₹${totalDues.toStringAsFixed(0)}',
                        subtitle: 'Protected under escrow safety',
                        icon: Icons.account_balance_wallet_outlined,
                        color: const Color(0xFFF59E0B),
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimaryColor: textPrimaryColor,
                        textSecondaryColor: textSecondaryColor,
                        textMutedColor: textMutedColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Search and Filter Bar
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
                              flex: 6,
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Search bookings by ID, project name, worker name, or client...',
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
                              flex: 3,
                              child: DropdownButtonFormField<String?>(
                                initialValue: _selectedProjectId,
                                decoration: InputDecoration(
                                  labelText: 'Filter Project',
                                  prefixIcon: const Icon(Icons.apartment_rounded, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('All Active Projects')),
                                  DropdownMenuItem(value: 'PRJ-104', child: Text('PRJ-104 - 4BHK DLF Phase 5')),
                                  DropdownMenuItem(value: 'PRJ-105', child: Text('PRJ-105 - Golf Links Villa')),
                                  DropdownMenuItem(value: 'PRJ-106', child: Text('PRJ-106 - Bandra Penthouse')),
                                  DropdownMenuItem(value: 'PRJ-107', child: Text('PRJ-107 - Whitefield Tech Villa')),
                                ],
                                onChanged: (val) => setState(() => _selectedProjectId = val),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Status Filter Tabs
                        Row(
                          children: [
                            _buildFilterTab('All Deployments (${_bookings.length})', null, surfaceColor, borderColor, textSecondaryColor),
                            const SizedBox(width: 8),
                            _buildFilterTab('In Progress ($activeCount)', BookingStatus.inProgress, surfaceColor, borderColor, textSecondaryColor),
                            const SizedBox(width: 8),
                            _buildFilterTab('Checklist Signed ($signedCount)', BookingStatus.checklistSigned, surfaceColor, borderColor, textSecondaryColor),
                            const SizedBox(width: 8),
                            _buildFilterTab('Completed ($completedCount)', BookingStatus.completed, surfaceColor, borderColor, textSecondaryColor),
                            const SizedBox(width: 8),
                            _buildFilterTab('Disputed (0)', BookingStatus.disputed, surfaceColor, borderColor, textSecondaryColor),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bookings List
                  if (filtered.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(48),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.inbox_outlined, size: 48, color: textMutedColor),
                          const SizedBox(height: 12),
                          Text('No active bookings match this filter.', style: TextStyle(fontSize: 14, color: textSecondaryColor)),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final booking = filtered[index];
                        return BookingCard(
                          booking: booking,
                          onOpenChecklist: () => _openChecklistModal(context, booking),
                          onSettlePayment: () => _openSettlePaymentDialog(context, booking),
                          onRaiseDispute: () => _openDisputeModal(context, booking),
                          onViewPhotos: () => _openPhotosPreview(context, booking),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color textMutedColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
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
                  Text(title, style: TextStyle(fontSize: 11, color: textMutedColor)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, BookingStatus? status, Color surfaceColor, Color borderColor, Color textSecondaryColor) {
    final isSelected = _selectedStatus == status;
    return InkWell(
      onTap: () => setState(() => _selectedStatus = status),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : textSecondaryColor,
          ),
        ),
      ),
    );
  }

  void _openChecklistModal(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => DailyChecklistModal(
        booking: booking,
        onSignOff: (updatedChecklist, supervisorName, notes) {
          final idx = _bookings.indexWhere((b) => b.id == booking.id);
          if (idx != -1) {
            setState(() {
              _bookings[idx] = booking.copyWith(
                dailyChecklist: updatedChecklist,
                supervisorSignOffName: supervisorName,
                status: BookingStatus.checklistSigned,
              );
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Daily Checklist for ${booking.bookingNumber} signed and authenticated by $supervisorName.')),
          );
        },
      ),
    );
  }

  void _openSettlePaymentDialog(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Settle Payout for ${booking.bookingNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deal Value: ₹${booking.dealValue.toStringAsFixed(0)}'),
            Text('Advance Released: ₹${booking.advancePaid.toStringAsFixed(0)}'),
            const Divider(),
            Text('Net Balance Payable to Worker: ₹${booking.balanceDue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
            Text('Platform Commission: ₹${booking.platformCommission.toStringAsFixed(0)} (10%)', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final idx = _bookings.indexWhere((b) => b.id == booking.id);
              if (idx != -1) {
                setState(() {
                  _bookings[idx] = booking.copyWith(
                    status: BookingStatus.completed,
                    balanceDue: 0.0,
                    advancePaid: booking.dealValue,
                  );
                });
              }
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payout of ₹${booking.balanceDue.toStringAsFixed(0)} disbursed to ${booking.tradesmanName}.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
            child: const Text('Disburse NEFT / UPI Payout'),
          ),
        ],
      ),
    );
  }

  void _openDisputeModal(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => LegalDisputeModal(
        booking: booking,
        onDisputeFiled: (newCase) {
          final idx = _bookings.indexWhere((b) => b.id == booking.id);
          if (idx != -1) {
            setState(() {
              _bookings[idx] = booking.copyWith(status: BookingStatus.disputed);
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dispute ${newCase.caseNumber} filed and transferred to Legal Hub.')),
          );
        },
      ),
    );
  }

  void _openCreateBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => HireLabourModal(
        onBookingCreated: (newBooking) {
          setState(() => _bookings.insert(0, newBooking));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service Booking ${newBooking.bookingNumber} created successfully.')),
          );
        },
      ),
    );
  }

  void _openPhotosPreview(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Site Execution Photos: ${booking.bookingNumber}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: booking.sitePhotos.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(url, height: 160, width: 260, fit: BoxFit.cover),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
