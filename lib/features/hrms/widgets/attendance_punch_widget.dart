import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';

class AttendancePunchWidget extends StatefulWidget {
  final VoidCallback? onPunchCompleted;

  const AttendancePunchWidget({super.key, this.onPunchCompleted});

  @override
  State<AttendancePunchWidget> createState() => _AttendancePunchWidgetState();
}

class _AttendancePunchWidgetState extends State<AttendancePunchWidget> {
  final _repo = HrmsRepository();
  String _selectedEmployeeId = 'emp_001';
  String _selectedLocationId = 'geo_hq_bkc';
  bool _isSelfieCaptured = false;
  static const double _currentDistanceMeters = 42.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final employees = _repo.employees;
    final geofences = _repo.geofences;

    // Check if current selected employee is already clocked in today
    final currentAttendance = _repo.todayAttendance.where((a) => a.employeeId == _selectedEmployeeId).firstOrNull;
    final isClockedIn = currentAttendance != null && currentAttendance.checkOutTime == null;
    final isInside = _currentDistanceMeters <= 150.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.md,
                    ),
                    child: const Icon(Icons.fingerprint, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Geofence Punch Terminal',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'GPS Boundary + Selfie Verification',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isClockedIn ? const Color(0xFF10B981).withValues(alpha: 0.12) : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: AppRadius.full,
                  border: Border.all(
                    color: isClockedIn ? const Color(0xFF10B981).withValues(alpha: 0.3) : const Color(0xFFF59E0B).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  isClockedIn ? 'CLOCKED IN' : 'READY TO PUNCH',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isClockedIn ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Select Employee Dropdown
          Text(
            'Select Personnel',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF475569)),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedEmployeeId,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                items: employees.map((emp) {
                  return DropdownMenuItem<String>(
                    value: emp.id,
                    child: Text(
                      '${emp.fullName} (${emp.employeeCode}) • ${emp.departmentName}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedEmployeeId = val);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Geofence Zone Target
          Text(
            'Assigned Geofence Hub',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF475569)),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B202E) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLocationId,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                items: geofences.map((geo) {
                  return DropdownMenuItem<String>(
                    value: geo.id,
                    child: Text(
                      '${geo.name} (Radius: ${geo.radiusMeters.toInt()}m)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedLocationId = val);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Camera / Selfie & GPS status box
          Row(
            children: [
              // Simulated Selfie Viewfinder
              Expanded(
                flex: 5,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F1420) : const Color(0xFFF1F5F9),
                    borderRadius: AppRadius.md,
                    border: Border.all(
                      color: _isSelfieCaptured ? const Color(0xFF10B981) : (isDark ? Colors.white12 : Colors.black12),
                      width: _isSelfieCaptured ? 1.5 : 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isSelfieCaptured) ...[
                        ClipRRect(
                          borderRadius: AppRadius.md,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (ctx, err, stack) => const Icon(Icons.check_circle, size: 40, color: Color(0xFF10B981)),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: AppRadius.sm,
                            ),
                            child: Text(
                              'VERIFIED',
                              style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                      ] else ...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined, size: 28, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 6),
                            Text(
                              'Live Selfie Camera',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      Positioned(
                        bottom: 6,
                        child: InkWell(
                          onTap: () {
                            setState(() => _isSelfieCaptured = !_isSelfieCaptured);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: AppRadius.full,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_isSelfieCaptured ? Icons.refresh : Icons.camera, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  _isSelfieCaptured ? 'Retake' : 'Capture Live',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // GPS Diagnostic metrics
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGpsIndicator(
                      label: 'Proximity',
                      value: '${_currentDistanceMeters.toInt()}m from Center',
                      statusColor: isInside ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      icon: isInside ? Icons.check_circle : Icons.warning_amber,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildGpsIndicator(
                      label: 'GPS Accuracy',
                      value: '± 2.4 meters (Strong)',
                      statusColor: const Color(0xFF3B82F6),
                      icon: Icons.gps_fixed,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildGpsIndicator(
                      label: 'Boundary Check',
                      value: isInside ? 'Authorized Location' : 'Breach Flagged',
                      statusColor: isInside ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      icon: Icons.shield,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Punch Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isClockedIn
                      ? null
                      : () {
                          final geo = geofences.firstWhere((g) => g.id == _selectedLocationId);
                          _repo.clockIn(
                            employeeId: _selectedEmployeeId,
                            latitude: geo.latitude,
                            longitude: geo.longitude,
                            locationName: geo.name,
                            selfieUrl: _isSelfieCaptured ? 'https://homio.internal/selfie_verified.jpg' : null,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Clock-In Verified! Geofence & Timestamp Logged.'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                          widget.onPunchCompleted?.call();
                          setState(() {});
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                    disabledBackgroundColor: Colors.grey.withValues(alpha: 0.2),
                  ),
                  icon: const Icon(Icons.login, size: 18),
                  label: Text('CLOCK IN', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: !isClockedIn
                      ? null
                      : () {
                          _repo.clockOut(employeeId: _selectedEmployeeId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Clock-Out Recorded! Total Hours calculated.'),
                              backgroundColor: Color(0xFF3B82F6),
                            ),
                          );
                          widget.onPunchCompleted?.call();
                          setState(() {});
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                    disabledBackgroundColor: Colors.grey.withValues(alpha: 0.2),
                  ),
                  icon: const Icon(Icons.logout, size: 18),
                  label: Text('CLOCK OUT', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGpsIndicator({
    required String label,
    required String value,
    required Color statusColor,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181D2A) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: statusColor),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                ),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
