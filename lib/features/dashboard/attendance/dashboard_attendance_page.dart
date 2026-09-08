import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../data/attendance_repository.dart';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';
import '../models/dashboard_mock_data.dart';
import '../widgets/attendance_punch_modal.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/state_feedback_widgets.dart';

/// Screen 3: Attendance & Geofence Verification.
/// Features Real-time Check In/Out with geofence validation, live working hours timer,
/// monthly interactive calendar, daily working-hour charts, and responsive history table/cards.
class DashboardAttendancePage extends StatefulWidget {
  final String userName;

  const DashboardAttendancePage({
    super.key,
    this.userName = 'Vikram Malhotra',
  });

  @override
  State<DashboardAttendancePage> createState() => _DashboardAttendancePageState();
}

class _DashboardAttendancePageState extends State<DashboardAttendancePage> {
  final AttendanceRepository _repository = AttendanceRepository.instance;
  final ScrollController _scrollController = ScrollController();

  DashboardDateFilter _dateFilter = DashboardDateFilter.thisMonth;
  DashboardScopeFilter _scopeFilter = DashboardScopeFilter.myWork;

  bool _isLoading = true;
  AttendanceSummary? _summary;
  List<AttendanceRecord> _records = [];
  int _selectedCalendarDay = 8;

  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_summary?.isClockedIn == true && _summary?.clockInTime != null) {
        if (mounted) {
          setState(() {
            _elapsed = DateTime.now().difference(_summary!.clockInTime!);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final savedOffset = _scrollController.hasClients ? _scrollController.offset : null;
    setState(() => _isLoading = true);
    final summary = await _repository.getAttendanceSummary(dateFilter: _dateFilter);
    final records = await _repository.getAttendanceHistory();

    if (mounted) {
      setState(() {
        _summary = summary;
        _records = records;
        _isLoading = false;
        if (summary.isClockedIn && summary.clockInTime != null) {
          _elapsed = DateTime.now().difference(summary.clockInTime!);
        }
      });
      if (savedOffset != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            final target = savedOffset.clamp(0.0, _scrollController.position.maxScrollExtent);
            _scrollController.jumpTo(target);
          }
        });
      }
    }
  }

  String _formatLiveDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final mins = (d.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours : $mins : $secs';
  }

  void _triggerPunchModal() {
    final isClockingIn = !(_summary?.isClockedIn ?? false);
    AttendancePunchModal.show(
      context,
      isClockingIn: isClockingIn,
      onPunchConfirmed: () async {
        if (isClockingIn) {
          await _repository.clockIn(
            location: 'HQ — DLF Phase 5 Hub (100m Geofence)',
            latitude: 28.4595,
            longitude: 77.0266,
            selfieCaptured: true,
          );
        } else {
          await _repository.clockOut(
            location: 'HQ — DLF Phase 5 Hub (100m Geofence)',
            latitude: 28.4595,
            longitude: 77.0266,
          );
        }
        _loadData();
      },
    );
  }

  void _openRegularizationDialog() {
    final reasonCtrl = TextEditingController();
    final inCtrl = TextEditingController(text: '09:00 AM');
    final outCtrl = TextEditingController(text: '06:30 PM');

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_calendar_rounded, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                'Attendance Regularization',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Submit adjustment for biometric punch mismatch or offsite client emergency.',
                  style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(height: 14),
                Text('Missed Punch Date: Sep 5, 2026', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Requested In', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: inCtrl,
                            style: GoogleFonts.inter(fontSize: 12),
                            decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder(borderRadius: AppRadius.sm)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Requested Out', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: outCtrl,
                            style: GoogleFonts.inter(fontSize: 12),
                            decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder(borderRadius: AppRadius.sm)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Reason for Regularization', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                const SizedBox(height: 4),
                TextField(
                  controller: reasonCtrl,
                  maxLines: 2,
                  style: GoogleFonts.inter(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'e.g. In transit to DLF Phase 5 site measurement meeting',
                    hintStyle: GoogleFonts.inter(fontSize: 12),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: AppRadius.sm),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
                    content: Text(
                      'Regularization request submitted to HRMS controller',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
              child: Text('Submit Request', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
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
          controller: _scrollController,
          key: const PageStorageKey('dashboard_attendance_scroll'),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Common Header
              DashboardHeader(
                title: 'Attendance & Geofence Telemetry',
                subtitle: 'Track attendance, working hours & verified field punches',
                icon: Icons.access_time_rounded,
                userName: widget.userName,
                activeDateFilter: _dateFilter,
                activeScopeFilter: _scopeFilter,
                onDateFilterChanged: (f) {
                  setState(() => _dateFilter = f);
                  _loadData();
                },
                onScopeFilterChanged: (s) {
                  setState(() => _scopeFilter = s);
                  _loadData();
                },
                onRefresh: _loadData,
                primaryAction: ElevatedButton.icon(
                  onPressed: _openRegularizationDialog,
                  icon: const Icon(Icons.history_toggle_off_rounded, size: 16),
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

              // Non-disruptive inline indicator right below header
              DashboardInlineLoadingIndicator(isLoading: _isLoading && _summary != null),

              if (_isLoading && _summary == null) ...[
                const DashboardSkeletonLoader(height: 120),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 88),
                const SizedBox(height: 16),
                const DashboardSkeletonLoader(height: 280),
              ] else if (_summary != null) ...[
                // 2. Today's Live Attendance & Geofence Punch Card
                _buildTodayAttendanceCard(isDark, isMobile),
                const SizedBox(height: 18),

                // 3. Attendance Summary KPIs Strip
                _buildAttendanceSummaryKpis(isDark, isMobile, isTablet),
                const SizedBox(height: 18),

                // 4. Monthly Calendar & Working Hours Chart Row
                _buildCalendarAndChartsRow(isDark, isMobile, isTablet),
                const SizedBox(height: 20),

                // 5. Attendance History (Table on Desktop, Cards on Mobile) with Localized Loading
                LocalizedLoadingOverlay(
                  isLoading: _isLoading && _summary != null,
                  message: 'Refreshing telemetry...',
                  child: _buildAttendanceHistorySection(isDark, isMobile),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION: TODAY'S LIVE ATTENDANCE CARD
  // ===========================================================================
  Widget _buildTodayAttendanceCard(bool isDark, bool isMobile) {
    final s = _summary!;
    final isClockedIn = s.isClockedIn;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isClockedIn
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isClockedIn ? const Color(0xFF10B981) : Colors.black).withValues(alpha: isDark ? 0.1 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTodayStatusHeader(isClockedIn, s, isDark),
                const SizedBox(height: 14),
                _buildLiveTimerBox(isClockedIn, isDark),
                const SizedBox(height: 14),
                _buildPunchButton(isClockedIn),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 5, child: _buildTodayStatusHeader(isClockedIn, s, isDark)),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: _buildLiveTimerBox(isClockedIn, isDark)),
                const SizedBox(width: 16),
                _buildPunchButton(isClockedIn),
              ],
            ),
    );
  }

  Widget _buildTodayStatusHeader(bool isClockedIn, AttendanceSummary s, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withValues(alpha: isDark ? 0.2 : 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isClockedIn ? Icons.login_rounded : Icons.logout_rounded,
            size: 24,
            color: isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isClockedIn ? '● Present & Clocked In' : '○ Not Clocked In',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isClockedIn ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Punch In: ${isClockedIn ? '09:14 AM' : '—'} • Check Out: ${s.clockOutTime != null ? '06:30 PM' : 'Not yet'}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.pin_drop_rounded, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Text(
                    s.clockInLocation,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'GEOFENCE VERIFIED',
                      style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveTimerBox(bool isClockedIn, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Working Time',
            style: GoogleFonts.inter(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
          const SizedBox(height: 2),
          Text(
            isClockedIn ? _formatLiveDuration(_elapsed) : '00 : 00 : 00',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: isClockedIn ? const Color(0xFF10B981) : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPunchButton(bool isClockedIn) {
    return ElevatedButton.icon(
      onPressed: _triggerPunchModal,
      icon: Icon(isClockedIn ? Icons.logout_rounded : Icons.login_rounded, size: 16),
      label: Text(
        isClockedIn ? 'Clock Out Shift' : 'Clock In Now',
        style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isClockedIn ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
    );
  }

  // ===========================================================================
  // SECTION: ATTENDANCE SUMMARY KPIS
  // ===========================================================================
  Widget _buildAttendanceSummaryKpis(bool isDark, bool isMobile, bool isTablet) {
    final s = _summary!;
    final kpis = [
      _buildSummaryCard('Present Days', '${s.presentDays}', 'full day shifts', const Color(0xFF10B981), isDark),
      _buildSummaryCard('Absent', '${s.absentDays}', 'unexcused', const Color(0xFFEF4444), isDark),
      _buildSummaryCard('Leave', '${s.leaveDays}', 'approved sick/casual', const Color(0xFF8B5CF6), isDark),
      _buildSummaryCard('Total Working Hours', '${s.totalWorkingHours}h', 'Sep 2026 logged', const Color(0xFF3B82F6), isDark),
      _buildSummaryCard('Average Daily Hours', '${s.avgDailyHours}h', 'SLA: 8.0h/day', const Color(0xFF0EA5E9), isDark),
    ];

    if (isMobile) {
      return SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: kpis.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) => SizedBox(width: 145, child: kpis[index]),
        ),
      );
    }

    return Row(
      children: kpis.map((k) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: k))).toList(),
    );
  }

  Widget _buildSummaryCard(String title, String val, String sub, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(val, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION: CALENDAR & WORKING HOURS CHARTS
  // ===========================================================================
  Widget _buildCalendarAndChartsRow(bool isDark, bool isMobile, bool isTablet) {
    final calendarWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Attendance Grid — September 2026',
                style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              Text(
                'Day $_selectedCalendarDay: Present (9.2h)',
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF10B981)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 7-day header
          Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((d) {
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // 30 days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 36,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final dayNum = index + 1;
              final isSelected = dayNum == _selectedCalendarDay;
              final isSun = (dayNum % 7 == 6);
              final isLeave = dayNum == 1;
              final isHalf = dayNum == 2;
              final isLate = dayNum == 5;
              final isFuture = dayNum > 8;

              Color dotColor = const Color(0xFF10B981);
              if (isFuture) {
                dotColor = const Color(0xFFCBD5E1);
              } else if (isSun) {
                dotColor = const Color(0xFF64748B);
              } else if (isLeave) {
                dotColor = const Color(0xFFEC4899);
              } else if (isHalf) {
                dotColor = const Color(0xFF8B5CF6);
              } else if (isLate) {
                dotColor = const Color(0xFFF59E0B);
              }

              return InkWell(
                onTap: () => setState(() => _selectedCalendarDay = dayNum),
                borderRadius: AppRadius.xs,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.15)
                        : (isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC)),
                    borderRadius: AppRadius.xs,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: isSelected ? 1.5 : 0.6,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : (isFuture ? const Color(0xFF94A3B8) : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Legend
          Wrap(
            spacing: 12,
            children: [
              _buildLegendDot(const Color(0xFF10B981), 'Present'),
              _buildLegendDot(const Color(0xFFF59E0B), 'Late'),
              _buildLegendDot(const Color(0xFF8B5CF6), 'Half Day'),
              _buildLegendDot(const Color(0xFFEC4899), 'Leave'),
              _buildLegendDot(const Color(0xFF64748B), 'Holiday'),
            ],
          ),
        ],
      ),
    );

    final chartWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Working Hours Distribution',
                style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              Text(
                'Target: 8.5h / day',
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const SizedBox(
            height: 240,
            child: DashboardAttendanceHoursBarChart(
              dailyHours: DashboardMockData.attendanceHoursPast30Days,
            ),
          ),
        ],
      ),
    );

    if (isMobile || isTablet) {
      return Column(
        children: [
          calendarWidget,
          const SizedBox(height: 14),
          chartWidget,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: calendarWidget),
        const SizedBox(width: 14),
        Expanded(flex: 5, child: chartWidget),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B))),
      ],
    );
  }

  // ===========================================================================
  // SECTION: ATTENDANCE HISTORY
  // ===========================================================================
  Widget _buildAttendanceHistorySection(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Punch Telemetry Ledger',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                '${_records.length} Recorded Shifts',
                style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (isMobile) ...[
            // Mobile Card view
            ..._records.map((r) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(r.date, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: r.status.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            r.status.label,
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: r.status.color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Punch In: ${r.inTime} • Punch Out: ${r.outTime}',
                      style: GoogleFonts.inter(fontSize: 11.5),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(r.location, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                        Text('${r.hoursWorked} hrs', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6))),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ] else ...[
            // Desktop Table view
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(1.8),
                2: FlexColumnWidth(1.8),
                3: FlexColumnWidth(1.6),
                4: FlexColumnWidth(3.0),
                5: FlexColumnWidth(2.0),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                    borderRadius: AppRadius.xs,
                  ),
                  children: [
                    _tableHeader('Date', isDark),
                    _tableHeader('Check In', isDark),
                    _tableHeader('Check Out', isDark),
                    _tableHeader('Duration', isDark),
                    _tableHeader('Location', isDark),
                    _tableHeader('Status', isDark),
                  ],
                ),
                ..._records.map((r) {
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8)),
                    ),
                    children: [
                      _tableCell(r.date, isDark, isBold: true),
                      _tableCell(r.inTime, isDark),
                      _tableCell(r.outTime, isDark),
                      _tableCell('${r.hoursWorked} hrs', isDark, color: const Color(0xFF3B82F6)),
                      _tableCell(r.location, isDark),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: r.status.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              r.status.label,
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: r.status.color),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _tableHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _tableCell(String text, bool isDark, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
      ),
    );
  }
}
