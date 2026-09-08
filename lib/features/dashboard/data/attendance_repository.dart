import 'dart:async';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';

/// Clean repository interface for Attendance module.
abstract class IAttendanceRepository {
  Future<AttendanceSummary> getAttendanceSummary({DashboardDateFilter? dateFilter});
  Future<List<AttendanceRecord>> getAttendanceHistory({int? month, int? year});
  Future<AttendanceSummary> clockIn({
    required String location,
    required double latitude,
    required double longitude,
    required bool selfieCaptured,
  });
  Future<AttendanceSummary> clockOut({
    required String location,
    required double latitude,
    required double longitude,
  });
  Future<void> requestRegularization({
    required String date,
    required String reason,
    required String adjustedInTime,
    required String adjustedOutTime,
  });
}

/// Production-ready mock implementation for AttendanceRepository.
class AttendanceRepository implements IAttendanceRepository {
  static final AttendanceRepository instance = AttendanceRepository._internal();
  AttendanceRepository._internal() {
    _initializeData();
  }
  factory AttendanceRepository() => instance;

  bool _isClockedIn = true;
  DateTime? _clockInTime = DateTime(2026, 9, 8, 9, 14);
  DateTime? _clockOutTime;
  String _currentLocation = 'HQ — DLF Phase 5 Hub';
  bool _isGeofenceVerified = true;

  final List<AttendanceRecord> _records = [];

  void _initializeData() {
    _records.addAll([
      const AttendanceRecord(
        id: 'ATT-20260908',
        date: 'Sep 8, 2026 (Today)',
        inTime: '09:14 AM',
        outTime: 'Active (Working)',
        hoursWorked: 6.8,
        status: AttendanceStatus.present,
        location: 'HQ — DLF Phase 5 Hub',
        isGeofenceVerified: true,
      ),
      const AttendanceRecord(
        id: 'ATT-20260907',
        date: 'Sep 7, 2026 (Mon)',
        inTime: '09:05 AM',
        outTime: '06:45 PM',
        hoursWorked: 9.6,
        status: AttendanceStatus.present,
        location: 'HQ — DLF Phase 5 Hub',
        isGeofenceVerified: true,
      ),
      const AttendanceRecord(
        id: 'ATT-20260906',
        date: 'Sep 6, 2026 (Sun)',
        inTime: '—',
        outTime: '—',
        hoursWorked: 0.0,
        status: AttendanceStatus.holiday,
        location: 'Weekly Off',
        isGeofenceVerified: false,
      ),
      const AttendanceRecord(
        id: 'ATT-20260905',
        date: 'Sep 5, 2026 (Sat)',
        inTime: '09:48 AM',
        outTime: '06:30 PM',
        hoursWorked: 8.7,
        status: AttendanceStatus.late,
        location: 'Site #104 — DLF Phase 5',
        isGeofenceVerified: true,
      ),
      const AttendanceRecord(
        id: 'ATT-20260904',
        date: 'Sep 4, 2026 (Fri)',
        inTime: '09:00 AM',
        outTime: '07:15 PM',
        hoursWorked: 10.2,
        status: AttendanceStatus.present,
        location: 'HQ — DLF Phase 5 Hub',
        isGeofenceVerified: true,
      ),
      const AttendanceRecord(
        id: 'ATT-20260903',
        date: 'Sep 3, 2026 (Thu)',
        inTime: '09:20 AM',
        outTime: '06:10 PM',
        hoursWorked: 8.8,
        status: AttendanceStatus.onDuty,
        location: 'Sobha City Penthouse #402',
        isGeofenceVerified: true,
      ),
      const AttendanceRecord(
        id: 'ATT-20260902',
        date: 'Sep 2, 2026 (Wed)',
        inTime: '01:30 PM',
        outTime: '06:30 PM',
        hoursWorked: 5.0,
        status: AttendanceStatus.halfDay,
        location: 'HQ — DLF Phase 5 Hub',
        isGeofenceVerified: true,
      ),
      const AttendanceRecord(
        id: 'ATT-20260901',
        date: 'Sep 1, 2026 (Tue)',
        inTime: '—',
        outTime: '—',
        hoursWorked: 0.0,
        status: AttendanceStatus.leave,
        location: 'Approved Sick Leave',
        isGeofenceVerified: false,
      ),
    ]);
  }

  @override
  Future<AttendanceSummary> getAttendanceSummary({DashboardDateFilter? dateFilter}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return AttendanceSummary(
      presentDays: 22,
      absentDays: 1,
      leaveDays: 2,
      totalWorkingHours: 186.5,
      avgDailyHours: 8.47,
      isClockedIn: _isClockedIn,
      clockInTime: _clockInTime,
      clockOutTime: _clockOutTime,
      clockInLocation: _currentLocation,
      isGeofenceVerified: _isGeofenceVerified,
    );
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceHistory({int? month, int? year}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_records);
  }

  @override
  Future<AttendanceSummary> clockIn({
    required String location,
    required double latitude,
    required double longitude,
    required bool selfieCaptured,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isClockedIn = true;
    _clockInTime = DateTime.now();
    _clockOutTime = null;
    _currentLocation = location;
    _isGeofenceVerified = true;

    // Prepend or update today's record
    _records.insert(
      0,
      AttendanceRecord(
        id: 'ATT-${DateTime.now().millisecondsSinceEpoch}',
        date: 'Today (${DateTime.now().hour}:${DateTime.now().minute})',
        inTime: '${_clockInTime!.hour.toString().padLeft(2, '0')}:${_clockInTime!.minute.toString().padLeft(2, '0')} AM',
        outTime: 'Active (Working)',
        hoursWorked: 0.1,
        status: AttendanceStatus.present,
        location: location,
        isGeofenceVerified: true,
      ),
    );

    return getAttendanceSummary();
  }

  @override
  Future<AttendanceSummary> clockOut({
    required String location,
    required double latitude,
    required double longitude,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isClockedIn = false;
    _clockOutTime = DateTime.now();

    final duration = _clockInTime != null ? _clockOutTime!.difference(_clockInTime!) : const Duration(hours: 8);
    final hours = (duration.inMinutes / 60.0);

    if (_records.isNotEmpty) {
      final today = _records.first;
      _records[0] = AttendanceRecord(
        id: today.id,
        date: today.date,
        inTime: today.inTime,
        outTime: '${_clockOutTime!.hour.toString().padLeft(2, '0')}:${_clockOutTime!.minute.toString().padLeft(2, '0')} PM',
        hoursWorked: double.parse(hours.toStringAsFixed(1)),
        status: today.status,
        location: location,
        isGeofenceVerified: true,
      );
    }

    return getAttendanceSummary();
  }

  @override
  Future<void> requestRegularization({
    required String date,
    required String reason,
    required String adjustedInTime,
    required String adjustedOutTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    // Simulated backend submission
  }
}
