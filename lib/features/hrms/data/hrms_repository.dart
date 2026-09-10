import 'package:flutter/foundation.dart';
import '../domain/hrms_enums.dart';
import '../domain/hrms_domain_models.dart';
import 'hrms_mock_data.dart';

/// Centralized HRMS Repository
class HrmsRepository extends ChangeNotifier {
  static final HrmsRepository _instance = HrmsRepository._internal();
  factory HrmsRepository() => _instance;

  HrmsRepository._internal() {
    _initData();
  }

  late List<Employee> _employees;
  late List<Department> _departments;
  late List<Team> _teams;
  late List<Shift> _shifts;
  late List<Geofence> _geofences;
  late List<WorkLocation> _workLocations;
  late List<AttendanceRecord> _todayAttendance;
  late List<FieldTravelRecord> _travelRecords;
  late List<LeaveApplication> _leaveApplications;
  late List<Goal> _goals;
  late List<PerformanceReview> _reviews;
  late List<Incentive> _incentives;
  late List<Deduction> _deductions;
  late List<PayrollPeriod> _payrollPeriods;
  late List<PayrollRecord> _payrollRecords;
  late List<Resignation> _resignations;
  late List<HandoverChecklist> _handoverChecklists;
  late List<ClearanceRecord> _clearances;
  late List<EmployeeActivity> _activities;
  late HrmsPolicyConfig _policyConfig;

  void _initData() {
    _employees = List.from(HrmsMockData.employees);
    _departments = List.from(HrmsMockData.departments);
    _teams = List.from(HrmsMockData.teams);
    _shifts = List.from(HrmsMockData.shifts);
    _geofences = List.from(HrmsMockData.geofences);
    _workLocations = List.from(HrmsMockData.workLocations);
    _todayAttendance = List.from(HrmsMockData.todayAttendance);
    _travelRecords = List.from(HrmsMockData.travelRecords);
    _leaveApplications = List.from(HrmsMockData.leaveApplications);
    _goals = List.from(HrmsMockData.goals);
    _reviews = List.from(HrmsMockData.performanceReviews);
    _incentives = List.from(HrmsMockData.incentives);
    _deductions = List.from(HrmsMockData.deductions);
    _payrollPeriods = List.from(HrmsMockData.payrollPeriods);
    _payrollRecords = List.from(HrmsMockData.payrollRecords);
    _resignations = List.from(HrmsMockData.resignations);
    _handoverChecklists = List.from(HrmsMockData.handoverChecklists);
    _clearances = List.from(HrmsMockData.clearances);
    _activities = List.from(HrmsMockData.activities);
    _policyConfig = HrmsMockData.policyConfig;
  }

  // --- Employees ---
  List<Employee> get employees => List.unmodifiable(_employees);

  Employee? getEmployeeById(String id) {
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Employee> filterEmployees({
    String? query,
    String? departmentId,
    EmployeeStatus? status,
    EmploymentType? employmentType,
  }) {
    return _employees.where((emp) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matches = emp.fullName.toLowerCase().contains(q) ||
            emp.employeeCode.toLowerCase().contains(q) ||
            emp.email.toLowerCase().contains(q) ||
            emp.role.toLowerCase().contains(q);
        if (!matches) return false;
      }
      if (departmentId != null && departmentId != 'all' && emp.departmentId != departmentId) {
        return false;
      }
      if (status != null && emp.status != status) {
        return false;
      }
      if (employmentType != null && emp.employmentType != employmentType) {
        return false;
      }
      return true;
    }).toList();
  }

  void addEmployee(Employee employee) {
    _employees.insert(0, employee);
    _logActivity(
      employeeId: employee.id,
      title: 'New Employee Onboarded',
      description: '${employee.fullName} (${employee.employeeCode}) joined ${employee.departmentName}',
      type: 'employee',
      iconName: 'person_add',
    );
    notifyListeners();
  }

  void updateEmployee(Employee updated) {
    final index = _employees.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _employees[index] = updated;
      notifyListeners();
    }
  }

  // --- Departments & Teams ---
  List<Department> get departments => List.unmodifiable(_departments);
  List<Team> get teams => List.unmodifiable(_teams);

  void addDepartment(Department department) {
    _departments.add(department);
    notifyListeners();
  }

  // --- Shifts & Geofences ---
  List<Shift> get shifts => List.unmodifiable(_shifts);
  List<Geofence> get geofences => List.unmodifiable(_geofences);
  List<WorkLocation> get workLocations => List.unmodifiable(_workLocations);

  // --- Attendance ---
  List<AttendanceRecord> get todayAttendance => List.unmodifiable(_todayAttendance);

  void clockIn({
    required String employeeId,
    required double latitude,
    required double longitude,
    required String locationName,
    String? selfieUrl,
  }) {
    final emp = getEmployeeById(employeeId);
    if (emp == null) return;

    // Check geofence
    GeofenceStatus geoStatus = GeofenceStatus.inside;
    // Simple simulated check: BKC vs other
    final distToBkc = (latitude - 19.0657).abs() + (longitude - 72.8687).abs();
    if (distToBkc > 0.05) {
      geoStatus = GeofenceStatus.outside;
    }

    final now = DateTime.now();
    final isLate = now.hour > 9 || (now.hour == 9 && now.minute > 45);
    final lateMins = isLate ? (now.hour - 9) * 60 + (now.minute - 30) : 0;

    final record = AttendanceRecord(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      employeeId: emp.id,
      employeeName: emp.fullName,
      employeeCode: emp.employeeCode,
      date: now,
      checkInTime: now,
      totalWorkingHours: 0.1,
      status: isLate ? AttendanceStatus.lateArrival : AttendanceStatus.present,
      geofenceStatus: geoStatus,
      checkInLatitude: latitude,
      checkInLongitude: longitude,
      checkInLocationName: locationName,
      checkInSelfieUrl: selfieUrl,
      isLate: isLate,
      lateMinutes: lateMins,
    );

    _todayAttendance.removeWhere((a) => a.employeeId == employeeId);
    _todayAttendance.insert(0, record);

    _logActivity(
      employeeId: emp.id,
      title: 'Clocked In: ${isLate ? "Late" : "On Time"}',
      description: '${emp.fullName} clocked in at $locationName ($geoStatus)',
      type: 'attendance',
      iconName: 'fingerprint',
    );

    notifyListeners();
  }

  void clockOut({required String employeeId}) {
    final index = _todayAttendance.indexWhere((a) => a.employeeId == employeeId);
    if (index != -1) {
      final old = _todayAttendance[index];
      final now = DateTime.now();
      final diff = old.checkInTime != null ? now.difference(old.checkInTime!).inMinutes / 60.0 : 8.0;
      _todayAttendance[index] = old.copyWith(
        checkOutTime: now,
        totalWorkingHours: double.parse(diff.toStringAsFixed(1)),
      );
      notifyListeners();
    }
  }

  // --- Travel & Mileage ---
  List<FieldTravelRecord> get travelRecords => List.unmodifiable(_travelRecords);

  void logTravel(FieldTravelRecord record) {
    _travelRecords.insert(0, record);
    _logActivity(
      employeeId: record.employeeId,
      title: 'Field Travel Logged',
      description: '${record.distanceKm} km to ${record.destinationName} (Claim: INR ${record.totalAmount.toStringAsFixed(2)})',
      type: 'travel',
      iconName: 'add_road',
    );
    notifyListeners();
  }

  void updateTravelStatus(String id, ApprovalStatus status, {String? approvedBy}) {
    final index = _travelRecords.indexWhere((t) => t.id == id);
    if (index != -1) {
      _travelRecords[index] = _travelRecords[index].copyWith(
        status: status,
        approvedBy: approvedBy ?? 'Admin Approver',
      );
      notifyListeners();
    }
  }

  // --- Leaves & Policy Penalties ---
  List<LeaveApplication> get leaveApplications => List.unmodifiable(_leaveApplications);

  void applyLeave(LeaveApplication application) {
    _leaveApplications.insert(0, application);
    _logActivity(
      employeeId: application.employeeId,
      title: 'Leave Application Filed',
      description: '${application.totalDays} day(s) ${application.leaveType.label} requested',
      type: 'leave',
      iconName: 'event_busy',
    );
    notifyListeners();
  }

  void updateLeaveStatus({
    required String id,
    required ApprovalStatus status,
    required String reviewerName,
    String? remarks,
  }) {
    final index = _leaveApplications.indexWhere((l) => l.id == id);
    if (index != -1) {
      final old = _leaveApplications[index];
      final isRejected = status == ApprovalStatus.rejected;
      
      // Check configurable policy: Does rejection trigger double deduction warning/penalty?
      final bool triggersDoublePenalty = isRejected && _policyConfig.doubleSalaryDeductionEnabled;
      final double penaltyDays = triggersDoublePenalty ? (old.totalDays * _policyConfig.unauthorizedAbsenceMultiplier) : 0.0;

      _leaveApplications[index] = old.copyWith(
        status: status,
        reviewedBy: reviewerName,
        reviewedDate: DateTime.now(),
        reviewRemarks: remarks,
        isStrictPenaltyTriggered: triggersDoublePenalty,
        penaltyDeductionDays: penaltyDays,
      );

      if (triggersDoublePenalty) {
        // Add policy deduction record
        final emp = getEmployeeById(old.employeeId);
        final dailyRate = emp != null ? (emp.baseSalary / 30.0) : 1000.0;
        final deductionAmount = dailyRate * penaltyDays;
        _deductions.insert(0, Deduction(
          id: 'ded_${DateTime.now().millisecondsSinceEpoch}',
          employeeId: old.employeeId,
          employeeName: old.employeeName,
          type: DeductionType.unauthorizedAbsencePenalty,
          title: 'Policy Deduction: ${old.leaveType.shortCode} Rejected (${penaltyDays}x Days)',
          amount: deductionAmount,
          isPolicyConfigurable: true,
          rateMultiplier: _policyConfig.unauthorizedAbsenceMultiplier,
          reason: 'Absence taken despite rejection. Deducted $penaltyDays days base salary.',
          period: 'Current Month',
          status: ApprovalStatus.approved,
        ));
      }

      notifyListeners();
    }
  }

  // --- Performance & Goals ---
  List<Goal> get goals => List.unmodifiable(_goals);
  List<PerformanceReview> get performanceReviews => List.unmodifiable(_reviews);

  void addGoal(Goal goal) {
    _goals.insert(0, goal);
    notifyListeners();
  }

  void addReview(PerformanceReview review) {
    _reviews.insert(0, review);
    notifyListeners();
  }

  // --- Incentives & Deductions ---
  List<Incentive> get incentives => List.unmodifiable(_incentives);
  List<Deduction> get deductions => List.unmodifiable(_deductions);

  void addIncentive(Incentive inc) {
    _incentives.insert(0, inc);
    notifyListeners();
  }

  void addDeduction(Deduction ded) {
    _deductions.insert(0, ded);
    notifyListeners();
  }

  // --- Payroll ---
  List<PayrollPeriod> get payrollPeriods => List.unmodifiable(_payrollPeriods);
  List<PayrollRecord> get payrollRecords => List.unmodifiable(_payrollRecords);

  // --- Resignation & Exit ---
  List<Resignation> get resignations => List.unmodifiable(_resignations);
  List<HandoverChecklist> get handoverChecklists => List.unmodifiable(_handoverChecklists);
  List<ClearanceRecord> get clearances => List.unmodifiable(_clearances);

  void toggleHandoverItem(String id) {
    final index = _handoverChecklists.indexWhere((h) => h.id == id);
    if (index != -1) {
      final item = _handoverChecklists[index];
      _handoverChecklists[index] = item.copyWith(
        isCompleted: !item.isCompleted,
        completedDate: !item.isCompleted ? DateTime.now() : null,
      );
      notifyListeners();
    }
  }

  void updateClearanceStatus(String id, ClearanceStatus status, {String? remarks}) {
    final index = _clearances.indexWhere((c) => c.id == id);
    if (index != -1) {
      final old = _clearances[index];
      _clearances[index] = old.copyWith(
        status: status,
        clearedDate: status == ClearanceStatus.approved ? DateTime.now() : null,
        remarks: remarks ?? old.remarks,
      );
      notifyListeners();
    }
  }

  // --- Policy Config ---
  HrmsPolicyConfig get policyConfig => _policyConfig;

  void updatePolicyConfig(HrmsPolicyConfig config) {
    _policyConfig = config;
    notifyListeners();
  }

  // --- Activities ---
  List<EmployeeActivity> get activities => List.unmodifiable(_activities);

  void _logActivity({
    required String employeeId,
    required String title,
    required String description,
    required String type,
    required String iconName,
  }) {
    _activities.insert(
      0,
      EmployeeActivity(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        employeeId: employeeId,
        title: title,
        description: description,
        timestamp: DateTime.now(),
        activityType: type,
        iconName: iconName,
      ),
    );
  }

  // --- Dashboard Stats ---
  HrmsDashboardStats getDashboardStats() {
    final total = _employees.length;
    final active = _employees.where((e) => e.status == EmployeeStatus.active).length;
    final probation = _employees.where((e) => e.status == EmployeeStatus.probation).length;
    final notice = _employees.where((e) => e.status == EmployeeStatus.noticePeriod).length;

    final present = _todayAttendance.where((a) => a.status == AttendanceStatus.present).length;
    final late = _todayAttendance.where((a) => a.status == AttendanceStatus.lateArrival).length;
    final onLeave = _todayAttendance.where((a) => a.status == AttendanceStatus.onLeave).length;

    return HrmsDashboardStats(
      totalHeadcount: total,
      activeEmployees: active,
      onProbation: probation,
      onNoticePeriod: notice,
      presentToday: present,
      absentToday: onLeave,
      lateToday: late,
      onFieldTravelToday: _travelRecords.length,
      pendingLeaveRequests: _leaveApplications.where((l) => l.status == ApprovalStatus.pending).length,
      pendingTravelClaims: _travelRecords.where((t) => t.status == ApprovalStatus.pending).length,
      monthlyPayrollBudget: 1485000.0,
      disbursedThisMonth: 1380800.0,
      pendingClearanceCount: _clearances.where((c) => c.status == ClearanceStatus.pending).length,
    );
  }
}
