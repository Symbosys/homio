import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/dashboard_mock_data.dart';
import '../models/dashboard_models.dart';
import '../widgets/compact_data_table.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_metric_card.dart';

/// Attendance & Geofence Verification screen with real-time clock-in/out,
/// geofence telemetry, monthly work-hours bar chart, and regularization requests.
class DashboardAttendancePage extends StatefulWidget {
  const DashboardAttendancePage({super.key});

  @override
  State<DashboardAttendancePage> createState() => _DashboardAttendancePageState();
}

class _DashboardAttendancePageState extends State<DashboardAttendancePage> {
  DashboardDateFilter _dateFilter = DashboardDateFilter.month;
  bool _isClockedIn = true;
  DateTime _clockInTime = DateTime.now().subtract(const Duration(hours: 3, minutes: 42, seconds: 15));
  late Timer _timer;
  Duration _elapsed = const Duration(hours: 3, minutes: 42, seconds: 15);
  final List<AttendanceRecord> _records = List.from(DashboardMockData.attendanceRecords);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isClockedIn) {
        setState(() {
          _elapsed = DateTime.now().difference(_clockInTime);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours : $minutes : $seconds';
  }

  void _toggleClock() {
    setState(() {
      _isClockedIn = !_isClockedIn;
      if (_isClockedIn) {
        _clockInTime = DateTime.now();
        _elapsed = Duration.zero;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isClockedIn
              ? 'Punched In: Verified within HQ Geofence (100m radius)'
              : 'Punched Out: Shift ended successfully',
          style: GoogleFonts.inter(fontSize: 12),
        ),
        backgroundColor: _isClockedIn ? const Color(0xFF10B981) : const Color(0xFF64748B),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openRegularizeDialog() {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          title: Row(
            children: [
              const Icon(Icons.edit_calendar, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Attendance Regularization Request',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select Date & Reason for discrepancy (e.g., on-site field visit, client meeting delay):',
                  style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  style: GoogleFonts.inter(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Describe reason for manual punch regularization...',
                    hintStyle: GoogleFonts.inter(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Regularization request submitted to HR / Manager', style: GoogleFonts.inter(fontSize: 12)),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
              child: Text('Submit', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              DashboardHeader(
                title: 'Attendance & Geofence Verification',
                subtitle: 'Biometric geofenced clock-in, live shift telemetry, and work duration analysis',
                icon: Icons.access_time_filled_outlined,
                activeFilter: _dateFilter,
                onFilterChanged: (val) => setState(() => _dateFilter = val),
                primaryAction: ElevatedButton.icon(
                  onPressed: _openRegularizeDialog,
                  icon: const Icon(Icons.edit_calendar, size: 14),
                  label: Text(
                    'Regularize Punch',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ),

              // Live Geofence Clock Card
              _buildClockInHeroCard(isDark, isMobile),
              const SizedBox(height: 18),

              // 4 Attendance KPI metrics
              _buildKpis(isMobile, isTablet),
              const SizedBox(height: 18),

              // Charts: 30-Day Work Hours Bar Chart & Status Donut Breakdown
              _buildChartsRow(isDark, isMobile, isTablet),
              const SizedBox(height: 18),

              // Attendance Records Data Table
              _buildAttendanceTable(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClockInHeroCard(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: _isClockedIn
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildClockTimerSection(isDark),
                const SizedBox(height: 16),
                _buildGeofenceInfoSection(isDark),
                const SizedBox(height: 16),
                _buildClockActionButton(),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 4, child: _buildClockTimerSection(isDark)),
                Container(
                  width: 1,
                  height: 70,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: _buildGeofenceInfoSection(isDark)),
                const SizedBox(width: 20),
                Expanded(flex: 3, child: _buildClockActionButton()),
              ],
            ),
    );
  }

  Widget _buildClockTimerSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _isClockedIn ? 'SHIFT ACTIVE' : 'SHIFT INACTIVE',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _formatDuration(_elapsed),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _isClockedIn ? 'Punched in at 09:30 AM • Shift: 09:30 AM - 06:30 PM' : 'Not clocked in yet today',
          style: GoogleFonts.inter(
            fontSize: 10.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildGeofenceInfoSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, size: 15, color: Color(0xFF2563EB)),
            const SizedBox(width: 6),
            Text(
              'Homio Corporate HQ (Indiranagar, BLR)',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Geofence Radius: 100 meters | GPS Accuracy: ±6m (Verified)',
          style: GoogleFonts.inter(
            fontSize: 10.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            DashboardBadge(label: 'GEOFENCE MATCHED', color: const Color(0xFF10B981), icon: Icons.verified),
            const SizedBox(width: 8),
            DashboardBadge(label: 'FACE RECOGNIZED', color: const Color(0xFF2563EB), icon: Icons.face),
          ],
        ),
      ],
    );
  }

  Widget _buildClockActionButton() {
    return ElevatedButton.icon(
      onPressed: _toggleClock,
      icon: Icon(_isClockedIn ? Icons.logout : Icons.login, size: 16),
      label: Text(
        _isClockedIn ? 'Punch Out' : 'Punch In Now',
        style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isClockedIn ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
    );
  }

  Widget _buildKpis(bool isMobile, bool isTablet) {
    final kpis = DashboardMockData.attendanceKpis;
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 118,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return DashboardMetricCard(metric: kpis[index]);
      },
    );
  }

  Widget _buildChartsRow(bool isDark, bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          DashboardAttendanceHoursBarChart(dailyHours: DashboardMockData.attendanceHoursPast30Days),
          const SizedBox(height: 16),
          DashboardAttendanceStatusDonutChart(presentDays: 22, lateDays: 1, leaveDays: 1),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: DashboardAttendanceHoursBarChart(dailyHours: DashboardMockData.attendanceHoursPast30Days),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: DashboardAttendanceStatusDonutChart(presentDays: 22, lateDays: 1, leaveDays: 1),
        ),
      ],
    );
  }

  Widget _buildAttendanceTable(bool isDark) {
    return CompactTableCard(
      title: 'Monthly Attendance & Geofence Log',
      subtitle: 'Showing 6 recent shifts with location telemetry & biometric validation',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.file_download_outlined, size: 13),
        label: Text('Export CSV', style: GoogleFonts.inter(fontSize: 11)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          visualDensity: VisualDensity.compact,
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = math.max(constraints.maxWidth, 880.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.4), // DATE
                  1: FlexColumnWidth(1.2), // IN TIME
                  2: FlexColumnWidth(1.2), // OUT TIME
                  3: FlexColumnWidth(1.2), // HOURS
                  4: FlexColumnWidth(2.6), // GEOFENCE STATUS
                  5: FlexColumnWidth(1.3), // STATUS
                  6: FlexColumnWidth(1.0), // ACTION
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildHeaderCell('DATE', isDark),
                      _buildHeaderCell('IN TIME', isDark),
                      _buildHeaderCell('OUT TIME', isDark),
                      _buildHeaderCell('HOURS', isDark),
                      _buildHeaderCell('GEOFENCE STATUS', isDark),
                      _buildHeaderCell('STATUS', isDark),
                      _buildHeaderCell('ACTION', isDark, align: TextAlign.center),
                    ],
                  ),
                  ..._records.map((r) {
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorder.withValues(alpha: 0.8),
                            width: 0.8,
                          ),
                        ),
                      ),
                      children: [
                        // DATE
                        _buildDataCell(
                          Text(
                            r.date,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        // IN TIME
                        _buildDataCell(
                          Text(
                            r.inTime,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // OUT TIME
                        _buildDataCell(
                          Text(
                            r.outTime,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        // HOURS
                        _buildDataCell(
                          Text(
                            '${r.hoursWorked.toStringAsFixed(1)} hrs',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        // GEOFENCE STATUS
                        _buildDataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                r.isGeofenceVerified ? Icons.check_circle : Icons.warning_amber_rounded,
                                size: 14,
                                color: r.isGeofenceVerified ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  r.location,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // STATUS
                        _buildDataCell(
                          DashboardBadge(label: r.status.toUpperCase(), color: r.statusColor),
                        ),
                        // ACTION
                        _buildDataCell(
                          Center(
                            child: TextButton(
                              onPressed: _openRegularizeDialog,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                minimumSize: const Size(40, 26),
                              ),
                              child: Text(
                                'Edit',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCell(String text, bool isDark, {TextAlign align = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget content, {EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: content,
    );
  }
}
