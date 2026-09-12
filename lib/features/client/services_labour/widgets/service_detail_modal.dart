import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../feedback_ratings/models/feedback_models.dart';
import '../../feedback_ratings/widgets/feedback_step_modal.dart';
import '../models/service_labour_models.dart';

/// Full lifecycle, daily photo updates, payment & completion verification modal
class ServiceDetailModal extends StatefulWidget {
  final ServiceBooking booking;
  final VoidCallback onStateUpdated;

  const ServiceDetailModal({
    super.key,
    required this.booking,
    required this.onStateUpdated,
  });

  static Future<void> show(
    BuildContext context, {
    required ServiceBooking booking,
    required VoidCallback onStateUpdated,
  }) {
    final isMobile = Breakpoints.isCompact(context);
    if (isMobile) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.94,
          child: ServiceDetailModal(booking: booking, onStateUpdated: onStateUpdated),
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620, maxHeight: 780),
          child: ServiceDetailModal(booking: booking, onStateUpdated: onStateUpdated),
        ),
      ),
    );
  }

  @override
  State<ServiceDetailModal> createState() => _ServiceDetailModalState();
}

class _ServiceDetailModalState extends State<ServiceDetailModal> {
  late ServiceBooking _booking;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  void _payPending() {
    ServiceRepository.instance.payPendingAmount(_booking);
    setState(() {
      _booking = ServiceRepository.instance.bookings.firstWhere((b) => b.id == _booking.id);
    });
    widget.onStateUpdated();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment settled successfully via HOMIO Secure Escrow.'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _confirmCompletion() {
    ServiceRepository.instance.confirmCompletion(_booking);
    setState(() {
      _booking = ServiceRepository.instance.bookings.firstWhere((b) => b.id == _booking.id);
    });
    widget.onStateUpdated();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service completion confirmed. Quality sign-off issued.'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _openRatingModal() {
    Navigator.of(context).pop();
    final prompt = PendingFeedbackPrompt(
      id: 'pnd_${_booking.id}',
      categoryLabel: 'SERVICE COMPLETED',
      title: '${_booking.serviceType} Execution',
      subtitle: 'Completed by ${_booking.provider.name} on ${_booking.startDate}.',
      date: _booking.startDate,
      targetType: 'Labour',
      providerName: _booking.provider.name,
      projectId: _booking.projectId,
      icon: Icons.carpenter_rounded,
      badgeColor: const Color(0xFF0EA5E9),
    );
    FeedbackStepModal.show(context, prompt: prompt, onSubmitted: () {
      setState(() => _booking.isRated = true);
      widget.onStateUpdated();
    });
  }

  void _reportIssue() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Defect & Snag Ticket for ${_booking.id} (${_booking.provider.name})...'),
        backgroundColor: const Color(0xFFEF4444),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(isDark),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Payment Banner
                  _buildStatusPaymentBanner(isDark),
                  const SizedBox(height: 20),

                  // 10-Step Lifecycle Stepper
                  Text(
                    '10-Step Execution Lifecycle',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildStepper(isDark),
                  const SizedBox(height: 24),

                  // Daily Photo Updates
                  Text(
                    'Daily Site Progress Updates & Proof',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDailyUpdates(isDark),
                  const SizedBox(height: 20),

                  // Details Breakdown
                  Text(
                    'Service Scope & Site Information',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailsCard(isDark),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          _buildBottomActions(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long_rounded, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _booking.id,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _booking.serviceType,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_booking.provider.name} · ${_booking.projectName}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPaymentBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBannerItem('Deal Value', '₹${_booking.dealValue}', isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, isDark),
          _buildDivider(isDark),
          _buildBannerItem('Paid Amount', '₹${_booking.paidAmount}', const Color(0xFF10B981), isDark),
          _buildDivider(isDark),
          _buildBannerItem('Pending Due', '₹${_booking.pendingAmount}', const Color(0xFFF59E0B), isDark),
        ],
      ),
    );
  }

  Widget _buildBannerItem(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 26,
      width: 1,
      color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
    );
  }

  Widget _buildStepper(bool isDark) {
    final steps = _booking.lifecycleSteps;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: steps.map((step) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: step.isCompleted
                            ? const Color(0xFF10B981)
                            : (step.isCurrent
                                ? AppColors.primary
                                : (isDark ? AppColors.darkBorder : Colors.grey.shade300)),
                      ),
                      alignment: Alignment.center,
                      child: step.isCompleted
                          ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                          : Text(
                              '${step.index + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: step.isCurrent ? Colors.white : Colors.grey.shade600,
                              ),
                            ),
                    ),
                    if (step.index < steps.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: step.isCompleted
                              ? const Color(0xFF10B981)
                              : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              step.title,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: step.isCurrent ? FontWeight.w800 : FontWeight.w600,
                                color: step.isCompleted || step.isCurrent
                                    ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                                    : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade500),
                              ),
                            ),
                            if (step.isCurrent) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'ACTIVE',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            if (step.timestamp != null)
                              Text(
                                step.timestamp!,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                          ],
                        ),
                        if (step.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            step.subtitle!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDailyUpdates(bool isDark) {
    if (_booking.dailyUpdates.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade50,
          borderRadius: AppRadius.md,
        ),
        child: Text(
          'No daily updates recorded yet.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      );
    }

    return Column(
      children: _booking.dailyUpdates.map((upd) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF8FAFC),
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.camera_alt_outlined, size: 15, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    upd.date,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${upd.photoCount} Photos Logged',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                upd.note,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: upd.photoLabels.map((lbl) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.image_rounded, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          lbl,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow('Project Site', _booking.propertyAddress, isDark),
          _buildDetailRow('Workers Assigned', '${_booking.workerCount} Verified Technicians', isDark),
          _buildDetailRow('Start Schedule', '${_booking.startDate} at ${_booking.startTime ?? '10:00 AM'}', isDark),
          _buildDetailRow('Duration', _booking.estimatedDuration, isDark),
          _buildDetailRow('Handover Target', _booking.requiredCompletionDate, isDark),
          _buildDetailRow('Work Scope', _booking.workDescription, isDark),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.end,
        children: [
          // Report an Issue
          OutlinedButton.icon(
            onPressed: _reportIssue,
            icon: const Icon(Icons.report_problem_outlined, size: 16, color: Color(0xFFEF4444)),
            label: Text(
              'Report Issue',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEF4444),
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
          ),

          // Pay Pending Amount
          if (_booking.pendingAmount > 0)
            ElevatedButton.icon(
              onPressed: _payPending,
              icon: const Icon(Icons.payment_rounded, size: 16),
              label: Text(
                'Pay Pending (₹${_booking.pendingAmount})',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                elevation: 0,
              ),
            ),

          // Confirm Completion
          if (!_booking.isCompletionConfirmed && _booking.status != 'Completed')
            ElevatedButton.icon(
              onPressed: _confirmCompletion,
              icon: const Icon(Icons.verified_rounded, size: 16),
              label: Text(
                'Confirm Completion',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                elevation: 0,
              ),
            ),

          // Rate Service
          if (!_booking.isRated)
            ElevatedButton.icon(
              onPressed: _openRatingModal,
              icon: const Icon(Icons.star_rounded, size: 16),
              label: Text(
                'Rate Service',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                elevation: 0,
              ),
            ),
        ],
      ),
    );
  }
}
