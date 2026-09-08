import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class BookingCard extends StatelessWidget {
  final ServiceBooking booking;
  final VoidCallback onOpenChecklist;
  final VoidCallback onSettlePayment;
  final VoidCallback onRaiseDispute;
  final VoidCallback? onViewPhotos;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onOpenChecklist,
    required this.onSettlePayment,
    required this.onRaiseDispute,
    this.onViewPhotos,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final statusColor = booking.status.color;
    final tradeColor = booking.trade.color;

    final completedTasks = booking.dailyChecklist.where((t) => t.isCompleted).length;
    final totalTasks = booking.dailyChecklist.length;
    final progress = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: booking.status == BookingStatus.disputed
              ? AppColors.error.withValues(alpha: 0.6)
              : borderColor.withValues(alpha: 0.8),
          width: booking.status == BookingStatus.disputed ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar: Booking # + Project Name + Status Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor.withValues(alpha: 0.7),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                bottom: BorderSide(color: borderColor.withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tradeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(booking.trade.icon, size: 14, color: tradeColor),
                      const SizedBox(width: 4),
                      Text(
                        booking.bookingNumber,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: tradeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    booking.projectName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking.status.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Assigned Personnel & Location Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assigned Tradesman',
                            style: TextStyle(fontSize: 11, color: textMutedColor),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.person_pin_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${booking.tradesmanName} (${booking.tradesmenCount} workers)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            booking.tradesmanPhone,
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client & Supervisor',
                            style: TextStyle(fontSize: 11, color: textMutedColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Client: ${booking.clientName}',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor),
                          ),
                          Text(
                            booking.supervisorName,
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GPS Check-in & Site Location',
                            style: TextStyle(fontSize: 11, color: textMutedColor),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  booking.gpsCheckInStamp,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            booking.siteLocation,
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Scope Description Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Work Scope & Milestones:',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textSecondaryColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.scopeDescription,
                        style: TextStyle(fontSize: 12, color: textPrimaryColor),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Daily Checklist Progress & Financial Settlement Grid
                Row(
                  children: [
                    // Daily Checklist Status Box
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Daily Task Checklist',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor),
                                ),
                                Text(
                                  '$completedTasks / $totalTasks items',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: completedTasks == totalTasks ? const Color(0xFF10B981) : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: borderColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  completedTasks == totalTasks ? const Color(0xFF10B981) : AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              booking.supervisorSignOffName.isNotEmpty
                                  ? 'Verified & Signed by ${booking.supervisorSignOffName}'
                                  : 'Awaiting Supervisor Sign-off',
                              style: TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: booking.supervisorSignOffName.isNotEmpty ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Deal Value & Payout Breakdown
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFinanceCol('Deal Value', '₹${booking.dealValue.toStringAsFixed(0)}', textPrimaryColor, textMutedColor),
                            _buildFinanceCol('Advance Paid', '₹${booking.advancePaid.toStringAsFixed(0)}', const Color(0xFF10B981), textMutedColor),
                            _buildFinanceCol('Balance Due', '₹${booking.balanceDue.toStringAsFixed(0)}', const Color(0xFFEF4444), textMutedColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Toolbar
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: onOpenChecklist,
                      icon: const Icon(Icons.checklist_rounded, size: 16),
                      label: const Text('Daily Checklist', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: booking.status == BookingStatus.completed ? null : onSettlePayment,
                      icon: const Icon(Icons.payments_outlined, size: 16),
                      label: Text(
                        booking.status == BookingStatus.completed ? 'Settled' : 'Settle Payout',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const Spacer(),
                    if (booking.sitePhotos.isNotEmpty && onViewPhotos != null) ...[
                      TextButton.icon(
                        onPressed: onViewPhotos,
                        icon: const Icon(Icons.photo_library_outlined, size: 15),
                        label: Text('${booking.sitePhotos.length} Photos', style: const TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          foregroundColor: textSecondaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    OutlinedButton.icon(
                      onPressed: onRaiseDispute,
                      icon: const Icon(Icons.gavel_outlined, size: 15),
                      label: const Text('Dispute & Legal', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withValues(alpha: 0.6)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCol(String label, String amount, Color amountColor, Color textMutedColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: textMutedColor)),
        const SizedBox(height: 2),
        Text(
          amount,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: amountColor),
        ),
      ],
    );
  }
}
