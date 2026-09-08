// Domain models for Module 13: HRMS, Geofenced Attendance, Travel Mileage & Payroll
// and Module 3: Organization, Department & Role Hierarchy

enum DepartmentType {
  marketing,
  sales,
  design,
  execution,
  afterSales;

  String get displayName {
    switch (this) {
      case DepartmentType.marketing:
        return 'Marketing & Growth';
      case DepartmentType.sales:
        return 'Sales & Consultations';
      case DepartmentType.design:
        return 'Design & Architecture';
      case DepartmentType.execution:
        return 'Turnkey Site Execution';
      case DepartmentType.afterSales:
        return 'After-Sales & Warranty';
    }
  }
}

enum HierarchyLevel {
  lead,
  manager,
  specialist,
  junior,
  director,
  departmentHead,
  fieldLead,
  executive,
  intern;

  String get displayName {
    switch (this) {
      case HierarchyLevel.director:
        return 'Director';
      case HierarchyLevel.lead:
      case HierarchyLevel.departmentHead:
        return 'Dept Head / Lead';
      case HierarchyLevel.manager:
        return 'Manager';
      case HierarchyLevel.specialist:
      case HierarchyLevel.fieldLead:
        return 'Field Lead / Specialist';
      case HierarchyLevel.executive:
        return 'Executive';
      case HierarchyLevel.junior:
      case HierarchyLevel.intern:
        return 'Junior / Intern';
    }
  }
}

enum EmployeeStatus {
  active,
  onLeave,
  noticePeriod,
  probation;

  String get displayName {
    switch (this) {
      case EmployeeStatus.active:
        return 'Active';
      case EmployeeStatus.onLeave:
        return 'On Leave';
      case EmployeeStatus.noticePeriod:
        return 'Notice Period';
      case EmployeeStatus.probation:
        return 'Probation';
    }
  }
}

enum AccessScope {
  myLeadsTasks,
  organizationWide,
  myLeadsOnly,
  teamWide;

  String get displayName {
    switch (this) {
      case AccessScope.myLeadsTasks:
      case AccessScope.myLeadsOnly:
        return 'My Leads/Tasks Only';
      case AccessScope.teamWide:
        return 'Team-Wide Scope';
      case AccessScope.organizationWide:
        return 'Organization-Wide';
    }
  }
}

enum GeofenceStatus {
  withinGeofence,
  outsideViolation,
  inside,
  outside,
  pendingVerification;

  bool get isInside => this == GeofenceStatus.withinGeofence || this == GeofenceStatus.inside;
}

enum AttendanceStatus {
  present,
  late,
  halfDay,
  absent,
  onLeave,
  doublePenalty;

  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late Punch-in';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.onLeave:
        return 'Approved Leave';
      case AttendanceStatus.doublePenalty:
        return '2X Salary Penalty';
    }
  }
}

enum ApprovalStatus {
  pending,
  approved,
  rejected;

  String get displayName {
    switch (this) {
      case ApprovalStatus.pending:
        return 'Pending Audit';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
    }
  }
}

enum VehicleType {
  twoWheeler,
  fourWheeler;

  double get defaultRatePerKm => this == VehicleType.twoWheeler ? 12.0 : 18.0;
}

enum LeaveType {
  casual,
  sick,
  paid,
  unpaid,
  unapproved,
  unapprovedAbsence;

  String get displayName {
    switch (this) {
      case LeaveType.casual:
        return 'Casual Leave (CL)';
      case LeaveType.sick:
        return 'Sick Leave (SL)';
      case LeaveType.paid:
        return 'Privilege / Paid Leave (PL)';
      case LeaveType.unpaid:
        return 'Loss of Pay (LOP)';
      case LeaveType.unapproved:
      case LeaveType.unapprovedAbsence:
        return 'Unapproved Absence (2X Penalty)';
    }
  }
}

enum PayrollStatus {
  draft,
  processed,
  approved,
  disbursed,
  onHold;

  String get displayName {
    switch (this) {
      case PayrollStatus.draft:
        return 'Draft';
      case PayrollStatus.processed:
        return 'Processed';
      case PayrollStatus.approved:
        return 'Approved';
      case PayrollStatus.disbursed:
        return 'Disbursed';
      case PayrollStatus.onHold:
        return 'On Hold';
    }
  }
}

class KycVerification {
  final bool aadhaarVerified;
  final bool panVerified;
  final bool bankAccountLinked;
  final bool signedAgreementAttached;
  final String? aadhaarNumber;
  final String? panNumber;
  final String? bankAccountNumber;
  final String? ifscCode;

  const KycVerification({
    bool? aadhaarVerified,
    bool? panVerified,
    bool? bankAccountLinked,
    bool? signedAgreementAttached,
    bool? isAadhaarVerified,
    bool? isPanVerified,
    bool? isBankVerified,
    String? aadhaarMasked,
    String? panMasked,
    this.aadhaarNumber,
    this.panNumber,
    this.bankAccountNumber,
    this.ifscCode,
  })  : aadhaarVerified = aadhaarVerified ?? isAadhaarVerified ?? true,
        panVerified = panVerified ?? isPanVerified ?? true,
        bankAccountLinked = bankAccountLinked ?? isBankVerified ?? true,
        signedAgreementAttached = signedAgreementAttached ?? true;

  bool get isFullyCompliant =>
      aadhaarVerified && panVerified && bankAccountLinked && signedAgreementAttached;
}

class EmployeeDossier {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String avatarUrl;
  final DepartmentType department;
  final String roleTitle;
  final HierarchyLevel level;
  final DateTime joiningDate;
  final EmployeeStatus status;
  final AccessScope accessScope;
  final KycVerification kyc;
  final double baseSalary;
  final String emergencyContactName;
  final String emergencyContactPhone;

  const EmployeeDossier({
    required this.id,
    String? fullName,
    String? name,
    String? code,
    required this.email,
    required this.phone,
    String? avatarUrl,
    required this.department,
    String? roleTitle,
    String? designation,
    HierarchyLevel? level,
    HierarchyLevel? hierarchyLevel,
    required this.joiningDate,
    required this.status,
    required this.accessScope,
    required this.kyc,
    required this.baseSalary,
    String? emergencyContactName,
    String? emergencyContactPhone,
  })  : fullName = fullName ?? name ?? 'Employee',
        avatarUrl = avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        roleTitle = roleTitle ?? designation ?? 'Staff Member',
        level = level ?? hierarchyLevel ?? HierarchyLevel.executive,
        emergencyContactName = emergencyContactName ?? 'Emergency Contact',
        emergencyContactPhone = emergencyContactPhone ?? '+91 98000 00000';

  String get name => fullName;
  String get code => id;
  String get designation => roleTitle;
  HierarchyLevel get hierarchyLevel => level;

  String get departmentName => department.displayName;

  EmployeeDossier copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    DepartmentType? department,
    String? roleTitle,
    HierarchyLevel? level,
    DateTime? joiningDate,
    EmployeeStatus? status,
    AccessScope? accessScope,
    KycVerification? kyc,
    double? baseSalary,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) {
    return EmployeeDossier(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      department: department ?? this.department,
      roleTitle: roleTitle ?? this.roleTitle,
      level: level ?? this.level,
      joiningDate: joiningDate ?? this.joiningDate,
      status: status ?? this.status,
      accessScope: accessScope ?? this.accessScope,
      kyc: kyc ?? this.kyc,
      baseSalary: baseSalary ?? this.baseSalary,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
    );
  }
}

class GeofenceZone {
  final String id;
  final String name;
  final double centerLat;
  final double centerLng;
  final double radiusMeters;
  final String activeSiteName;
  final String address;

  const GeofenceZone({
    required this.id,
    required this.name,
    required this.centerLat,
    required this.centerLng,
    required this.radiusMeters,
    String? activeSiteName,
    String? address,
  })  : activeSiteName = activeSiteName ?? name,
        address = address ?? activeSiteName ?? name;

  double get latitude => centerLat;
  double get longitude => centerLng;
}

class AttendanceRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String departmentName;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? checkInSelfieUrl;
  final String? checkOutSelfieUrl;
  final double latitude;
  final double longitude;
  final GeofenceStatus geofenceStatus;
  final double loggedHours;
  final double overtimeHours;
  final AttendanceStatus status;
  final String zoneId;
  final String zoneName;
  final String? penaltyReason;

  AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    String? employeeCode,
    String? departmentName,
    DateTime? date,
    this.checkInTime,
    this.checkOutTime,
    String? checkInSelfieUrl,
    String? selfieUrl,
    this.checkOutSelfieUrl,
    required this.latitude,
    required this.longitude,
    required this.geofenceStatus,
    double? loggedHours,
    this.overtimeHours = 0.0,
    required this.status,
    String? zoneId,
    String? zoneName,
    this.penaltyReason,
  })  : departmentName = departmentName ?? 'General',
        date = date ?? checkInTime ?? DateTime.now(),
        checkInSelfieUrl = checkInSelfieUrl ?? selfieUrl,
        loggedHours = loggedHours ?? 8.0,
        zoneId = zoneId ?? 'ZONE-01',
        zoneName = zoneName ?? 'Homio Corporate Site';

  String get employeeCode => employeeId;
  String? get selfieUrl => checkInSelfieUrl;

  AttendanceRecord copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? departmentName,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInSelfieUrl,
    String? checkOutSelfieUrl,
    double? latitude,
    double? longitude,
    GeofenceStatus? geofenceStatus,
    double? loggedHours,
    double? overtimeHours,
    AttendanceStatus? status,
    String? zoneId,
    String? zoneName,
    String? penaltyReason,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      departmentName: departmentName ?? this.departmentName,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInSelfieUrl: checkInSelfieUrl ?? this.checkInSelfieUrl,
      checkOutSelfieUrl: checkOutSelfieUrl ?? this.checkOutSelfieUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      geofenceStatus: geofenceStatus ?? this.geofenceStatus,
      loggedHours: loggedHours ?? this.loggedHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      status: status ?? this.status,
      zoneId: zoneId ?? this.zoneId,
      zoneName: zoneName ?? this.zoneName,
      penaltyReason: penaltyReason ?? this.penaltyReason,
    );
  }
}

class TravelMileageRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String departmentName;
  final DateTime date;
  final String projectName;
  final String departureLocation;
  final DateTime departureTime;
  final String? departureSelfieUrl;
  final String arrivalLocation;
  final DateTime arrivalTime;
  final String? arrivalSelfieUrl;
  final double distanceKm;
  final double ratePerKm;
  final double reimbursementAmount;
  final ApprovalStatus approvalStatus;
  final String notes;
  final VehicleType vehicleType;
  final double? startLatitude;
  final double? startLongitude;
  final double? endLatitude;
  final double? endLongitude;

  TravelMileageRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    String? employeeCode,
    String? departmentName,
    DateTime? date,
    String? projectName,
    String? projectReference,
    String? departureLocation,
    String? originAddress,
    DateTime? departureTime,
    DateTime? startTime,
    String? departureSelfieUrl,
    String? startSelfieUrl,
    String? arrivalLocation,
    String? destinationAddress,
    DateTime? arrivalTime,
    DateTime? endTime,
    String? arrivalSelfieUrl,
    String? endSelfieUrl,
    required this.distanceKm,
    required this.ratePerKm,
    required this.reimbursementAmount,
    ApprovalStatus? approvalStatus,
    ApprovalStatus? status,
    String? notes,
    VehicleType? vehicleType,
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
  })  : departmentName = departmentName ?? 'Field Execution',
        date = date ?? departureTime ?? startTime ?? DateTime.now(),
        projectName = projectName ?? projectReference ?? 'Turnkey Site Visit',
        departureLocation = departureLocation ?? originAddress ?? 'HQ Cyber City',
        departureTime = departureTime ?? startTime ?? DateTime.now(),
        departureSelfieUrl = departureSelfieUrl ?? startSelfieUrl,
        arrivalLocation = arrivalLocation ?? destinationAddress ?? 'Client Site',
        arrivalTime = arrivalTime ?? endTime ?? DateTime.now(),
        arrivalSelfieUrl = arrivalSelfieUrl ?? endSelfieUrl,
        approvalStatus = approvalStatus ?? status ?? ApprovalStatus.pending,
        notes = notes ?? 'Official site survey travel claim',
        vehicleType = vehicleType ?? VehicleType.twoWheeler;

  String get employeeCode => employeeId;
  String? get projectReference => projectName;
  String get originAddress => departureLocation;
  String get destinationAddress => arrivalLocation;
  DateTime get startTime => departureTime;
  DateTime get endTime => arrivalTime;
  String? get startSelfieUrl => departureSelfieUrl;
  String? get endSelfieUrl => arrivalSelfieUrl;
  ApprovalStatus get status => approvalStatus;

  TravelMileageRecord copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? departmentName,
    DateTime? date,
    String? projectName,
    String? departureLocation,
    DateTime? departureTime,
    String? departureSelfieUrl,
    String? arrivalLocation,
    DateTime? arrivalTime,
    String? arrivalSelfieUrl,
    double? distanceKm,
    double? ratePerKm,
    double? reimbursementAmount,
    ApprovalStatus? approvalStatus,
    ApprovalStatus? status,
    String? notes,
    VehicleType? vehicleType,
  }) {
    return TravelMileageRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      departmentName: departmentName ?? this.departmentName,
      date: date ?? this.date,
      projectName: projectName ?? this.projectName,
      departureLocation: departureLocation ?? this.departureLocation,
      departureTime: departureTime ?? this.departureTime,
      departureSelfieUrl: departureSelfieUrl ?? this.departureSelfieUrl,
      arrivalLocation: arrivalLocation ?? this.arrivalLocation,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      arrivalSelfieUrl: arrivalSelfieUrl ?? this.arrivalSelfieUrl,
      distanceKm: distanceKm ?? this.distanceKm,
      ratePerKm: ratePerKm ?? this.ratePerKm,
      reimbursementAmount: reimbursementAmount ?? this.reimbursementAmount,
      approvalStatus: approvalStatus ?? status ?? this.approvalStatus,
      notes: notes ?? this.notes,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }
}

class LeaveApplication {
  final String id;
  final String employeeId;
  final String employeeName;
  final String departmentName;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String reason;
  final ApprovalStatus status;
  final bool isDoublePenaltyApplied;
  final double penaltyDeductionAmount;
  final DateTime appliedDate;
  final String? reviewedBy;

  LeaveApplication({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    String? employeeCode,
    String? departmentName,
    LeaveType? leaveType,
    LeaveType? type,
    required this.startDate,
    required this.endDate,
    int? totalDays,
    int? days,
    required this.reason,
    required this.status,
    this.isDoublePenaltyApplied = false,
    double? penaltyDeductionAmount,
    DateTime? appliedDate,
    this.reviewedBy,
  })  : departmentName = departmentName ?? 'General Operations',
        leaveType = leaveType ?? type ?? LeaveType.casual,
        totalDays = totalDays ?? days ?? 1,
        penaltyDeductionAmount = penaltyDeductionAmount ?? 0.0,
        appliedDate = appliedDate ?? DateTime.now();

  String get employeeCode => employeeId;
  int get days => totalDays;
  LeaveType get type => leaveType;

  LeaveApplication copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? departmentName,
    LeaveType? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? totalDays,
    String? reason,
    ApprovalStatus? status,
    bool? isDoublePenaltyApplied,
    double? penaltyDeductionAmount,
    DateTime? appliedDate,
    String? reviewedBy,
  }) {
    return LeaveApplication(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      departmentName: departmentName ?? this.departmentName,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      isDoublePenaltyApplied: isDoublePenaltyApplied ?? this.isDoublePenaltyApplied,
      penaltyDeductionAmount: penaltyDeductionAmount ?? this.penaltyDeductionAmount,
      appliedDate: appliedDate ?? this.appliedDate,
      reviewedBy: reviewedBy ?? this.reviewedBy,
    );
  }
}

class PayrollRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String departmentName;
  final String roleTitle;
  final String monthYear;
  final double baseSalary;
  final double travelAllowance;
  final double incentives;
  final double overtimePay;
  final double absenteeismDoublePenalty;
  final double statutoryDeductions;
  final PayrollStatus paymentStatus;
  final String? paymentRef;
  final DateTime generatedDate;

  PayrollRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    String? employeeCode,
    String? departmentName,
    String? roleTitle,
    String? monthYear,
    String? month,
    required this.baseSalary,
    double? travelAllowance,
    double? travelReimbursement,
    double? incentives,
    this.overtimePay = 0.0,
    double? absenteeismDoublePenalty,
    double? doublePenaltyDeduction,
    double? statutoryDeductions,
    double? pfDeduction,
    double? tdsDeduction,
    PayrollStatus? paymentStatus,
    PayrollStatus? status,
    this.paymentRef,
    DateTime? generatedDate,
  })  : departmentName = departmentName ?? 'Corporate',
        roleTitle = roleTitle ?? 'Associate',
        monthYear = monthYear ?? month ?? 'August 2026',
        travelAllowance = travelAllowance ?? travelReimbursement ?? 0.0,
        incentives = incentives ?? 0.0,
        absenteeismDoublePenalty = absenteeismDoublePenalty ?? doublePenaltyDeduction ?? 0.0,
        statutoryDeductions = statutoryDeductions ?? ((pfDeduction ?? 0.0) + (tdsDeduction ?? 0.0)),
        paymentStatus = paymentStatus ?? status ?? PayrollStatus.draft,
        generatedDate = generatedDate ?? DateTime.now();

  double get grossPay => baseSalary + travelAllowance + incentives + overtimePay;
  double get totalDeductions => absenteeismDoublePenalty + statutoryDeductions;
  double get netPayable => grossPay - totalDeductions;

  String get employeeCode => employeeId;
  String get month => monthYear;
  double get travelReimbursement => travelAllowance;
  double get pfDeduction => statutoryDeductions > 0 ? (statutoryDeductions * 0.6) : 0.0;
  double get tdsDeduction => statutoryDeductions > 0 ? (statutoryDeductions * 0.4) : 0.0;
  double get doublePenaltyDeduction => absenteeismDoublePenalty;
  double get netSalary => netPayable;
  PayrollStatus get status => paymentStatus;
  String get pdfPasswordHint {
    final clean = employeeName.replaceAll(' ', '').toUpperCase();
    final prefix = clean.length >= 4 ? clean.substring(0, 4) : clean.padRight(4, 'X');
    return '${prefix}1994';
  }

  PayrollRecord copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? departmentName,
    String? roleTitle,
    String? monthYear,
    double? baseSalary,
    double? travelAllowance,
    double? incentives,
    double? overtimePay,
    double? absenteeismDoublePenalty,
    double? statutoryDeductions,
    PayrollStatus? paymentStatus,
    PayrollStatus? status,
    String? paymentRef,
    DateTime? generatedDate,
  }) {
    return PayrollRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      departmentName: departmentName ?? this.departmentName,
      roleTitle: roleTitle ?? this.roleTitle,
      monthYear: monthYear ?? this.monthYear,
      baseSalary: baseSalary ?? this.baseSalary,
      travelAllowance: travelAllowance ?? this.travelAllowance,
      incentives: incentives ?? this.incentives,
      overtimePay: overtimePay ?? this.overtimePay,
      absenteeismDoublePenalty: absenteeismDoublePenalty ?? this.absenteeismDoublePenalty,
      statutoryDeductions: statutoryDeductions ?? this.statutoryDeductions,
      paymentStatus: paymentStatus ?? status ?? this.paymentStatus,
      paymentRef: paymentRef ?? this.paymentRef,
      generatedDate: generatedDate ?? this.generatedDate,
    );
  }
}

class NoticePeriodHandoff {
  final String id;
  final String employeeId;
  final String employeeName;
  final String departmentName;
  final String roleTitle;
  final DateTime resignationDate;
  final int noticeDays;
  final DateTime lwdDate;
  final int remainingDays;
  final bool assetClearanceStatus;
  final bool projectHandoverStatus;
  final bool accountsNoDuesStatus;
  final bool relievingLetterIssued;
  final String? handoverToEmployeeName;
  final DepartmentType? departmentType;

  NoticePeriodHandoff({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    String? employeeCode,
    String? departmentName,
    DepartmentType? department,
    String? roleTitle,
    required this.resignationDate,
    int? noticeDays,
    int? noticeDaysTotal,
    DateTime? lwdDate,
    DateTime? lastWorkingDay,
    int? remainingDays,
    bool? assetClearanceStatus,
    bool? isAssetCleared,
    bool? projectHandoverStatus,
    bool? isProjectHandoffDone,
    bool? accountsNoDuesStatus,
    bool? isAccountsSettled,
    bool? relievingLetterIssued,
    bool? isRelievingLetterIssued,
    this.handoverToEmployeeName,
  })  : departmentName = departmentName ?? department?.displayName ?? 'Design',
        departmentType = department,
        roleTitle = roleTitle ?? 'Associate',
        noticeDays = noticeDays ?? noticeDaysTotal ?? 30,
        lwdDate = lwdDate ?? lastWorkingDay ?? resignationDate.add(Duration(days: noticeDays ?? noticeDaysTotal ?? 30)),
        remainingDays = remainingDays ?? (lwdDate ?? lastWorkingDay ?? resignationDate.add(Duration(days: noticeDays ?? noticeDaysTotal ?? 30))).difference(DateTime.now()).inDays,
        assetClearanceStatus = assetClearanceStatus ?? isAssetCleared ?? false,
        projectHandoverStatus = projectHandoverStatus ?? isProjectHandoffDone ?? false,
        accountsNoDuesStatus = accountsNoDuesStatus ?? isAccountsSettled ?? false,
        relievingLetterIssued = relievingLetterIssued ?? isRelievingLetterIssued ?? false;

  bool get isFullyCleared =>
      assetClearanceStatus && projectHandoverStatus && accountsNoDuesStatus;

  String get employeeCode => employeeId;
  DepartmentType get department => departmentType ?? DepartmentType.design;
  DateTime get lastWorkingDay => lwdDate;
  int get noticeDaysTotal => noticeDays;
  bool get isAssetCleared => assetClearanceStatus;
  bool get isProjectHandoffDone => projectHandoverStatus;
  bool get isAccountsSettled => accountsNoDuesStatus;
  bool get isRelievingLetterIssued => relievingLetterIssued;

  NoticePeriodHandoff copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? departmentName,
    DepartmentType? department,
    String? roleTitle,
    DateTime? resignationDate,
    int? noticeDays,
    DateTime? lwdDate,
    int? remainingDays,
    bool? assetClearanceStatus,
    bool? isAssetCleared,
    bool? projectHandoverStatus,
    bool? isProjectHandoffDone,
    bool? accountsNoDuesStatus,
    bool? isAccountsSettled,
    bool? relievingLetterIssued,
    bool? isRelievingLetterIssued,
    String? handoverToEmployeeName,
  }) {
    return NoticePeriodHandoff(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      departmentName: departmentName ?? this.departmentName,
      department: department ?? this.department,
      roleTitle: roleTitle ?? this.roleTitle,
      resignationDate: resignationDate ?? this.resignationDate,
      noticeDays: noticeDays ?? this.noticeDays,
      lwdDate: lwdDate ?? this.lwdDate,
      remainingDays: remainingDays ?? this.remainingDays,
      assetClearanceStatus: assetClearanceStatus ?? isAssetCleared ?? this.assetClearanceStatus,
      projectHandoverStatus: projectHandoverStatus ?? isProjectHandoffDone ?? this.projectHandoverStatus,
      accountsNoDuesStatus: accountsNoDuesStatus ?? isAccountsSettled ?? this.accountsNoDuesStatus,
      relievingLetterIssued: relievingLetterIssued ?? isRelievingLetterIssued ?? this.relievingLetterIssued,
      handoverToEmployeeName: handoverToEmployeeName ?? this.handoverToEmployeeName,
    );
  }
}
