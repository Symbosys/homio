import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';

class JobCheckInModal extends StatefulWidget {
  final ServiceBooking booking;
  final Function(JobCheckInRecord checkIn) onCheckInCompleted;

  const JobCheckInModal({
    super.key,
    required this.booking,
    required this.onCheckInCompleted,
  });

  @override
  State<JobCheckInModal> createState() => _JobCheckInModalState();
}

class _JobCheckInModalState extends State<JobCheckInModal> {
  bool _isGpsAcquired = false;
  bool _isSelfieCaptured = false;
  bool _isCheckingIn = false;
  final double _mockLat = 28.4595;
  final double _mockLng = 77.0266;

  @override
  void initState() {
    super.initState();
    // Simulate instantaneous device GPS acquisition
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isGpsAcquired = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add_location_alt_rounded, color: Color(0xFF06B6D4), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FIELD SITE CHECK-IN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.booking.workTitle,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Booking & Site Context Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildRow('Project / Site:', widget.booking.projectName, textPrimaryColor, textSecondaryColor),
                    const SizedBox(height: 8),
                    _buildRow('Site Address:', widget.booking.siteLocation, textPrimaryColor, textSecondaryColor),
                    const SizedBox(height: 8),
                    _buildRow('Assigned Tradesman:', '${widget.booking.tradesmanName} (${widget.booking.trade.label})', textPrimaryColor, textSecondaryColor),
                    const SizedBox(height: 8),
                    _buildRow('Site Supervisor:', widget.booking.supervisorName, textPrimaryColor, textSecondaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Step 1: Geolocation Verification Badge
              Text(
                '1. SITE GEOLOCATION & TIMESTAMP',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isGpsAcquired ? const Color(0xFF10B981).withValues(alpha: 0.08) : Colors.amber.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isGpsAcquired ? const Color(0xFF10B981).withValues(alpha: 0.3) : Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isGpsAcquired ? Icons.check_circle_rounded : Icons.sensors_rounded,
                      color: _isGpsAcquired ? const Color(0xFF10B981) : Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isGpsAcquired ? 'Geo-fence Verified: Within 15m of Site Perimeter' : 'Acquiring GPS Satellite Lock...',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _isGpsAcquired ? const Color(0xFF059669) : Colors.amber.shade800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isGpsAcquired
                                ? 'Coordinates: ${_mockLat.toStringAsFixed(4)}° N, ${_mockLng.toStringAsFixed(4)}° E • ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} Local Time'
                                : 'Ensure GPS is enabled on your mobile device',
                            style: TextStyle(fontSize: 11, color: textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Step 2: Touch-friendly Selfie Capture
              Text(
                '2. BIOMETRIC SITE SELFIE VERIFICATION',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  setState(() => _isSelfieCaptured = true);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isSelfieCaptured ? const Color(0xFF10B981) : borderColor,
                      style: _isSelfieCaptured ? BorderStyle.solid : BorderStyle.solid,
                    ),
                  ),
                  child: _isSelfieCaptured
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.booking.tradesmanId == 'LBR-101'
                                    ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'
                                    : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                                    SizedBox(width: 6),
                                    Text('Selfie Captured & Verified', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF10B981))),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Tap to Retake Photo', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded, size: 32, color: AppColors.primary),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap to Capture Front Camera Selfie at Site',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary),
                            ),
                            const SizedBox(height: 2),
                            Text('Required by Homio SLA for attendance & insurance coverage', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: (!_isGpsAcquired || !_isSelfieCaptured || _isCheckingIn)
                      ? null
                      : () {
                          final nav = Navigator.of(context);
                          setState(() => _isCheckingIn = true);
                          Future.delayed(const Duration(milliseconds: 500), () {
                            final checkIn = JobCheckInRecord(
                              id: 'CHK-${DateTime.now().millisecondsSinceEpoch}',
                              jobId: widget.booking.id,
                              workerId: widget.booking.tradesmanId,
                              workerName: widget.booking.tradesmanName,
                              checkInTime: DateTime.now(),
                              latitude: _mockLat,
                              longitude: _mockLng,
                              address: widget.booking.siteLocation,
                              selfiePhotoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                            );
                            widget.onCheckInCompleted(checkIn);
                            nav.pop();
                          });
                        },
                  icon: _isCheckingIn
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.touch_app_rounded, size: 20),
                  label: Text(
                    _isCheckingIn
                        ? 'VERIFYING CHECK-IN...'
                        : (!_isSelfieCaptured ? 'CAPTURE SELFIE TO CONTINUE' : 'CONFIRM CHECK-IN & START WORK'),
                    style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.6),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color textColor, Color labelColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: labelColor)),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textColor)),
        ),
      ],
    );
  }
}
