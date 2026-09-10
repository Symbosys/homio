import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_data_table.dart';
import '../widgets/hrms_filter_bar.dart';
import '../widgets/hrms_status_badge.dart';
import '../widgets/hrms_map_widget.dart';
import '../widgets/hrms_calendar.dart';
import '../widgets/attendance_punch_widget.dart';

class HrmsAttendancePage extends StatefulWidget {
  const HrmsAttendancePage({super.key});

  @override
  State<HrmsAttendancePage> createState() => _HrmsAttendancePageState();
}

class _HrmsAttendancePageState extends State<HrmsAttendancePage> with SingleTickerProviderStateMixin {
  final _repo = HrmsRepository();
  late TabController _tabController;

  String _statusFilter = 'all';
  String _searchQuery = '';
  String _calendarEmpId = 'emp_001';
  int _currentPage = 1;
  static const int _pageSize = 8;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  List<AttendanceRecord> get _filteredRecords {
    return _repo.todayAttendance.where((r) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!r.employeeName.toLowerCase().contains(q) && !r.employeeCode.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_statusFilter == 'present' && r.status != AttendanceStatus.present) return false;
      if (_statusFilter == 'late' && r.status != AttendanceStatus.lateArrival) return false;
      if (_statusFilter == 'geofence_flagged' && r.geofenceStatus == GeofenceStatus.inside) return false;
      return true;
    }).toList();
  }

  void _openPunchModal() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: AttendancePunchWidget(
            onPunchCompleted: () {
              Navigator.of(ctx).pop();
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  void _openRegularizeDialog(AttendanceRecord record) {
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF131722) : Colors.white,
            borderRadius: AppRadius.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Regularize Attendance Punch',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Employee: ${record.employeeName} (${record.employeeCode})',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: reasonCtrl,
                maxLines: 3,
                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                decoration: const InputDecoration(
                  labelText: 'Justification for Late Arrival or Geofence Breach',
                  hintText: 'e.g. Client meeting at site before office arrival...',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Regularization request submitted to Head of Department.'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Submit Request'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    final records = _filteredRecords;
    final totalRecords = records.length;
    final totalPages = (totalRecords / _pageSize).ceil().clamp(1, 99);
    final startIndex = (_currentPage - 1) * _pageSize;
    final paged = records.skip(startIndex).take(_pageSize).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? AppSpacing.md : AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                HrmsHeader(
                  title: 'GPS Geofenced Attendance & Biometric Hub',
                  subtitle: 'Real-time GPS virtual perimeter verification, facial selfie check-in, late arrival penalties & regularization',
                  icon: Icons.location_on_rounded,
                  badgeText: 'LIVE GPS ENGINE',
                  badgeColor: const Color(0xFF10B981),
                  actions: [
                    ElevatedButton.icon(
                      onPressed: _openPunchModal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.fingerprint, size: 16),
                      label: Text('Quick Punch Terminal', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Metrics
                _buildMetrics(context, isCompact),
                const SizedBox(height: AppSpacing.md),

                // Tab Switcher
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131722) : Colors.white,
                    borderRadius: AppRadius.lg,
                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(icon: Icon(Icons.history, size: 16), text: 'Today\'s Attendance Feed'),
                      Tab(icon: Icon(Icons.radar, size: 16), text: 'Geofence Boundaries & Radar'),
                      Tab(icon: Icon(Icons.calendar_month, size: 16), text: 'Monthly Heatmap Calendar'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Tab Body
                SizedBox(
                  height: 620,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Live Punch Log & Table
                      Column(
                        children: [
                          HrmsFilterBar(
                            searchHint: 'Search attendance by employee name or code...',
                            selectedFilter: _statusFilter,
                            onSearchChanged: (q) => setState(() {
                              _searchQuery = q;
                              _currentPage = 1;
                            }),
                            filterOptions: [
                              FilterOption(label: 'All Logs', value: 'all', count: _repo.todayAttendance.length),
                              FilterOption(label: 'Present On-Time', value: 'present', count: _repo.todayAttendance.where((a) => a.status == AttendanceStatus.present).length),
                              FilterOption(label: 'Late Arrivals', value: 'late', count: _repo.todayAttendance.where((a) => a.status == AttendanceStatus.lateArrival).length),
                              FilterOption(label: 'Geofence Breaches', value: 'geofence_flagged', count: _repo.todayAttendance.where((a) => a.geofenceStatus != GeofenceStatus.inside).length),
                            ],
                            onFilterSelected: (val) => setState(() {
                              _statusFilter = val;
                              _currentPage = 1;
                            }),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Expanded(child: _buildAttendanceTable(paged, totalRecords, totalPages, isDark)),
                        ],
                      ),

                      // Tab 2: Geofence Zones & Radar Map
                      _buildGeofencesTab(isDark),

                      // Tab 3: Monthly Calendar View
                      _buildCalendarTab(isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, bool isCompact) {
    final presentCount = _repo.todayAttendance.where((a) => a.status == AttendanceStatus.present).length;
    final lateCount = _repo.todayAttendance.where((a) => a.status == AttendanceStatus.lateArrival).length;
    final geofenceBreaches = _repo.todayAttendance.where((a) => a.geofenceStatus != GeofenceStatus.inside).length;

    final cards = [
      HrmsMetricCard(
        title: 'Present On-Time',
        value: '$presentCount Staff',
        subtitle: 'Verified Inside Geofence',
        icon: Icons.check_circle_outline,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Late Arrivals (>15m)',
        value: '$lateCount Incidents',
        subtitle: 'Grace Period Exceeded',
        icon: Icons.alarm,
        accentColor: const Color(0xFFFB923C),
      ),
      HrmsMetricCard(
        title: 'Geofence Breaches',
        value: '$geofenceBreaches Flagged',
        subtitle: 'Clock-In >150m from Site',
        icon: Icons.warning_amber_rounded,
        accentColor: const Color(0xFFEF4444),
      ),
      HrmsMetricCard(
        title: 'Approved Field Visits',
        value: '3 Staff',
        subtitle: 'Remote GPS Tracking Active',
        icon: Icons.add_road_rounded,
        accentColor: const Color(0xFF3B82F6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildAttendanceTable(List<AttendanceRecord> records, int totalRecords, int totalPages, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'EMPLOYEE & CODE'),
        HrmsDataColumn(title: 'PUNCH IN'),
        HrmsDataColumn(title: 'PUNCH OUT / HOURS'),
        HrmsDataColumn(title: 'STATUS'),
        HrmsDataColumn(title: 'GEOFENCE LOCATION'),
        HrmsDataColumn(title: 'ACTION', alignment: Alignment.centerRight),
      ],
      currentPage: _currentPage,
      totalPages: totalPages,
      totalRecords: totalRecords,
      onPageChanged: (p) => setState(() => _currentPage = p),
      rows: records.map((r) {
        return [
          // Employee Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(r.employeeName, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              Text(r.employeeCode, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            ],
          ),

          // Check-in Time & Late tag
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                r.checkInTime != null ? '${r.checkInTime!.hour.toString().padLeft(2, '0')}:${r.checkInTime!.minute.toString().padLeft(2, '0')} AM' : '--',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              if (r.isLate)
                Text('+${r.lateMinutes}m late', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFFFB923C), fontWeight: FontWeight.w700))
              else
                Text('On-time', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF10B981))),
            ],
          ),

          // Working Hours
          Text(
            r.checkOutTime != null ? '${r.totalWorkingHours}h (Done)' : '${r.totalWorkingHours}h (Active)',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
          ),

          // Status Badge
          HrmsStatusBadge.attendance(r.status),

          // Geofence status & location
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HrmsStatusBadge.geofence(r.geofenceStatus),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  r.checkInLocationName,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Action
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (r.isLate || r.geofenceStatus != GeofenceStatus.inside)
                OutlinedButton(
                  onPressed: () => _openRegularizeDialog(r),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text('Regularize', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primary)),
                )
              else
                const Icon(Icons.check_circle, size: 16, color: Color(0xFF10B981)),
            ],
          ),
        ];
      }).toList(),
    );
  }

  Widget _buildGeofencesTab(bool isDark) {
    final geofences = _repo.geofences;

    return SingleChildScrollView(
      child: Column(
        children: [
          const HrmsMapWidget(
            locationTitle: 'Homio Global Headquarters - BKC Virtual Boundary',
            centerLat: 19.0657,
            centerLng: 72.8687,
            radiusMeters: 180.0,
            isInside: true,
            height: 240,
          ),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: geofences.length,
            separatorBuilder: (ctx, idx) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final g = geofences[index];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131722) : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: AppRadius.md,
                          ),
                          child: const Icon(Icons.location_on, color: Color(0xFF10B981), size: 18),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g.name, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                            Text(g.address, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Radius: ${g.radiusMeters.toInt()}m', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                        Text('${g.latitude.toStringAsFixed(4)}°N, ${g.longitude.toStringAsFixed(4)}°E', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Filter Calendar for Employee:', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: AppSpacing.sm),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131722) : Colors.white,
                  borderRadius: AppRadius.md,
                  border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _calendarEmpId,
                    dropdownColor: isDark ? const Color(0xFF1A1F2C) : Colors.white,
                    items: _repo.employees.map((e) => DropdownMenuItem(value: e.id, child: Text(e.fullName))).toList(),
                    onChanged: (v) => setState(() => _calendarEmpId = v!),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          HrmsCalendar(
            month: 8,
            year: 2026,
            attendanceMap: const {
              1: AttendanceStatus.present,
              2: AttendanceStatus.present,
              3: AttendanceStatus.lateArrival,
              4: AttendanceStatus.present,
              5: AttendanceStatus.present,
              6: AttendanceStatus.present,
              7: AttendanceStatus.weeklyOff,
              8: AttendanceStatus.present,
              9: AttendanceStatus.present,
              10: AttendanceStatus.present,
            },
          ),
        ],
      ),
    );
  }
}
