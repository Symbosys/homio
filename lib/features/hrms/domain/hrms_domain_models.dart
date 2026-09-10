import 'hrms_enums.dart';

/// KYC and Identification Document
class KycDocument {
  final String id;
  final DocumentType type;
  final String documentNumber;
  final String documentUrl;
  final bool isVerified;
  final DateTime? verifiedAt;
  final String? verifiedBy;
  final String? notes;

  const KycDocument({
    required this.id,
    required this.type,
    required this.documentNumber,
    required this.documentUrl,
    this.isVerified = false,
    this.verifiedAt,
    this.verifiedBy,
    this.notes,
  });

  KycDocument copyWith({
    String? id,
    DocumentType? type,
    String? documentNumber,
    String? documentUrl,
    bool? isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    String? notes,
  }) {
    return KycDocument(
      id: id ?? this.id,
      type: type ?? this.type,
      documentNumber: documentNumber ?? this.documentNumber,
      documentUrl: documentUrl ?? this.documentUrl,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      notes: notes ?? this.notes,
    );
  }
}

/// Emergency Contact Info
class EmergencyContact {
  final String name;
  final String relationship;
  final String phone;
  final String? alternativePhone;
  final String? address;

  const EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
    this.alternativePhone,
    this.address,
  });
}

/// Bank Account Details for Payroll Disbursal
class BankDetails {
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final String accountHolderName;
  final String? upiId;

  const BankDetails({
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
    required this.accountHolderName,
    this.upiId,
  });
}

/// Master Employee Entity
class Employee {
  final String id;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String avatarUrl;
  final String departmentId;
  final String departmentName;
  final String role;
  final String designation;
  final String? reportingManagerId;
  final String? reportingManagerName;
  final EmployeeStatus status;
  final EmploymentType employmentType;
  final DateTime joinDate;
  final DateTime? probationEndDate;
  final DateTime? confirmationDate;
  final int noticePeriodDays;
  final String workLocationId;
  final String workLocationName;
  final double baseSalary;
  final double ctc;
  final BankDetails? bankDetails;
  final EmergencyContact? emergencyContact;
  final List<KycDocument> kycDocuments;
  final List<String> skills;
  final String shiftId;
  final String shiftName;
  final DateTime createdDate;
  final DateTime updatedDate;

  const Employee({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.departmentId,
    required this.departmentName,
    required this.role,
    required this.designation,
    this.reportingManagerId,
    this.reportingManagerName,
    this.status = EmployeeStatus.active,
    this.employmentType = EmploymentType.fullTime,
    required this.joinDate,
    this.probationEndDate,
    this.confirmationDate,
    this.noticePeriodDays = 30,
    required this.workLocationId,
    required this.workLocationName,
    required this.baseSalary,
    required this.ctc,
    this.bankDetails,
    this.emergencyContact,
    this.kycDocuments = const [],
    this.skills = const [],
    this.shiftId = 'shift_gen',
    this.shiftName = 'General Day Shift',
    required this.createdDate,
    required this.updatedDate,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ""}${lastName.isNotEmpty ? lastName[0] : ""}';

  Employee copyWith({
    String? id,
    String? employeeCode,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? departmentId,
    String? departmentName,
    String? role,
    String? designation,
    String? reportingManagerId,
    String? reportingManagerName,
    EmployeeStatus? status,
    EmploymentType? employmentType,
    DateTime? joinDate,
    DateTime? probationEndDate,
    DateTime? confirmationDate,
    int? noticePeriodDays,
    String? workLocationId,
    String? workLocationName,
    double? baseSalary,
    double? ctc,
    BankDetails? bankDetails,
    EmergencyContact? emergencyContact,
    List<KycDocument>? kycDocuments,
    List<String>? skills,
    String? shiftId,
    String? shiftName,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Employee(
      id: id ?? this.id,
      employeeCode: employeeCode ?? this.employeeCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      role: role ?? this.role,
      designation: designation ?? this.designation,
      reportingManagerId: reportingManagerId ?? this.reportingManagerId,
      reportingManagerName: reportingManagerName ?? this.reportingManagerName,
      status: status ?? this.status,
      employmentType: employmentType ?? this.employmentType,
      joinDate: joinDate ?? this.joinDate,
      probationEndDate: probationEndDate ?? this.probationEndDate,
      confirmationDate: confirmationDate ?? this.confirmationDate,
      noticePeriodDays: noticePeriodDays ?? this.noticePeriodDays,
      workLocationId: workLocationId ?? this.workLocationId,
      workLocationName: workLocationName ?? this.workLocationName,
      baseSalary: baseSalary ?? this.baseSalary,
      ctc: ctc ?? this.ctc,
      bankDetails: bankDetails ?? this.bankDetails,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      kycDocuments: kycDocuments ?? this.kycDocuments,
      skills: skills ?? this.skills,
      shiftId: shiftId ?? this.shiftId,
      shiftName: shiftName ?? this.shiftName,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}

/// Department Hierarchy
class Department {
  final String id;
  final String code;
  final String name;
  final String description;
  final String headEmployeeId;
  final String headEmployeeName;
  final int totalEmployees;
  final int activeCount;
  final double budget;
  final String iconName;
  final DateTime createdDate;

  const Department({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.headEmployeeId,
    required this.headEmployeeName,
    this.totalEmployees = 0,
    this.activeCount = 0,
    this.budget = 0.0,
    this.iconName = 'business',
    required this.createdDate,
  });

  Department copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    String? headEmployeeId,
    String? headEmployeeName,
    int? totalEmployees,
    int? activeCount,
    double? budget,
    String? iconName,
    DateTime? createdDate,
  }) {
    return Department(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      headEmployeeId: headEmployeeId ?? this.headEmployeeId,
      headEmployeeName: headEmployeeName ?? this.headEmployeeName,
      totalEmployees: totalEmployees ?? this.totalEmployees,
      activeCount: activeCount ?? this.activeCount,
      budget: budget ?? this.budget,
      iconName: iconName ?? this.iconName,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}

/// Teams within a Department
class Team {
  final String id;
  final String departmentId;
  final String departmentName;
  final String name;
  final String leadEmployeeId;
  final String leadEmployeeName;
  final List<String> memberIds;
  final String description;

  const Team({
    required this.id,
    required this.departmentId,
    required this.departmentName,
    required this.name,
    required this.leadEmployeeId,
    required this.leadEmployeeName,
    this.memberIds = const [],
    this.description = '',
  });
}

/// Work Shift Definition
class Shift {
  final String id;
  final String name;
  final String code;
  final String startTime; // '09:30'
  final String endTime;   // '18:30'
  final int gracePeriodMinutes;
  final double halfDayThresholdHours;
  final double fullDayThresholdHours;
  final bool isNightShift;
  final List<int> workingDays; // 1 = Monday, 7 = Sunday
  final bool isDefault;

  const Shift({
    required this.id,
    required this.name,
    required this.code,
    required this.startTime,
    required this.endTime,
    this.gracePeriodMinutes = 15,
    this.halfDayThresholdHours = 4.5,
    this.fullDayThresholdHours = 8.0,
    this.isNightShift = false,
    this.workingDays = const [1, 2, 3, 4, 5, 6],
    this.isDefault = false,
  });
}

/// Shift Assignment
class ShiftAssignment {
  final String id;
  final String employeeId;
  final String shiftId;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;

  const ShiftAssignment({
    required this.id,
    required this.employeeId,
    required this.shiftId,
    required this.effectiveFrom,
    this.effectiveTo,
  });
}

/// Geofence Virtual Perimeter
class Geofence {
  final String id;
  final String name;
  final String locationName;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final bool isActive;
  final String address;
  final List<String> allowedDepartments;

  const Geofence({
    required this.id,
    required this.name,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    this.radiusMeters = 150.0,
    this.isActive = true,
    required this.address,
    this.allowedDepartments = const [],
  });
}

/// Work Location / Office / Site Hub
class WorkLocation {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final bool isHeadquarters;
  final String geofenceId;

  const WorkLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.isHeadquarters = false,
    required this.geofenceId,
  });
}

/// Daily Attendance Punch & Geofence Verification Record
class AttendanceRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final double totalWorkingHours;
  final AttendanceStatus status;
  final GeofenceStatus geofenceStatus;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final String? checkInSelfieUrl;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final String? checkOutSelfieUrl;
  final String checkInLocationName;
  final bool isLate;
  final bool isEarlyDeparture;
  final int lateMinutes;
  final int earlyDepartureMinutes;
  final String? regularizationReason;
  final ApprovalStatus? regularizationStatus;
  final String? regularizedBy;
  final String? notes;

  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.totalWorkingHours = 0.0,
    this.status = AttendanceStatus.present,
    this.geofenceStatus = GeofenceStatus.inside,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkInSelfieUrl,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutSelfieUrl,
    this.checkInLocationName = 'HQ Mumbai BKC',
    this.isLate = false,
    this.isEarlyDeparture = false,
    this.lateMinutes = 0,
    this.earlyDepartureMinutes = 0,
    this.regularizationReason,
    this.regularizationStatus,
    this.regularizedBy,
    this.notes,
  });

  AttendanceRecord copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeCode,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? totalWorkingHours,
    AttendanceStatus? status,
    GeofenceStatus? geofenceStatus,
    double? checkInLatitude,
    double? checkInLongitude,
    String? checkInSelfieUrl,
    double? checkOutLatitude,
    double? checkOutLongitude,
    String? checkOutSelfieUrl,
    String? checkInLocationName,
    bool? isLate,
    bool? isEarlyDeparture,
    int? lateMinutes,
    int? earlyDepartureMinutes,
    String? regularizationReason,
    ApprovalStatus? regularizationStatus,
    String? regularizedBy,
    String? notes,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeCode: employeeCode ?? this.employeeCode,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      totalWorkingHours: totalWorkingHours ?? this.totalWorkingHours,
      status: status ?? this.status,
      geofenceStatus: geofenceStatus ?? this.geofenceStatus,
      checkInLatitude: checkInLatitude ?? this.checkInLatitude,
      checkInLongitude: checkInLongitude ?? this.checkInLongitude,
      checkInSelfieUrl: checkInSelfieUrl ?? this.checkInSelfieUrl,
      checkOutLatitude: checkOutLatitude ?? this.checkOutLatitude,
      checkOutLongitude: checkOutLongitude ?? this.checkOutLongitude,
      checkOutSelfieUrl: checkOutSelfieUrl ?? this.checkOutSelfieUrl,
      checkInLocationName: checkInLocationName ?? this.checkInLocationName,
      isLate: isLate ?? this.isLate,
      isEarlyDeparture: isEarlyDeparture ?? this.isEarlyDeparture,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      earlyDepartureMinutes: earlyDepartureMinutes ?? this.earlyDepartureMinutes,
      regularizationReason: regularizationReason ?? this.regularizationReason,
      regularizationStatus: regularizationStatus ?? this.regularizationStatus,
      regularizedBy: regularizedBy ?? this.regularizedBy,
      notes: notes ?? this.notes,
    );
  }
}

/// GPS Field Travel & Mileage Reimbursement Log
class FieldTravelRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime date;
  final String originName;
  final double originLat;
  final double originLng;
  final String? originSelfieUrl;
  final DateTime departureTime;
  final String destinationName;
  final double destinationLat;
  final double destinationLng;
  final String? arrivalSelfieUrl;
  final DateTime? arrivalTime;
  final double distanceKm;
  final double approvedKm;
  final double ratePerKm;
  final double totalAmount;
  final TravelMode travelMode;
  final String purpose;
  final String? clientProjectId;
  final String? clientProjectName;
  final ApprovalStatus status;
  final String? approvedBy;
  final String? remarks;

  const FieldTravelRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.date,
    required this.originName,
    required this.originLat,
    required this.originLng,
    this.originSelfieUrl,
    required this.departureTime,
    required this.destinationName,
    required this.destinationLat,
    required this.destinationLng,
    this.arrivalSelfieUrl,
    this.arrivalTime,
    required this.distanceKm,
    required this.approvedKm,
    required this.ratePerKm,
    required this.totalAmount,
    this.travelMode = TravelMode.bike,
    required this.purpose,
    this.clientProjectId,
    this.clientProjectName,
    this.status = ApprovalStatus.pending,
    this.approvedBy,
    this.remarks,
  });

  FieldTravelRecord copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeCode,
    DateTime? date,
    String? originName,
    double? originLat,
    double? originLng,
    String? originSelfieUrl,
    DateTime? departureTime,
    String? destinationName,
    double? destinationLat,
    double? destinationLng,
    String? arrivalSelfieUrl,
    DateTime? arrivalTime,
    double? distanceKm,
    double? approvedKm,
    double? ratePerKm,
    double? totalAmount,
    TravelMode? travelMode,
    String? purpose,
    String? clientProjectId,
    String? clientProjectName,
    ApprovalStatus? status,
    String? approvedBy,
    String? remarks,
  }) {
    return FieldTravelRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeCode: employeeCode ?? this.employeeCode,
      date: date ?? this.date,
      originName: originName ?? this.originName,
      originLat: originLat ?? this.originLat,
      originLng: originLng ?? this.originLng,
      originSelfieUrl: originSelfieUrl ?? this.originSelfieUrl,
      departureTime: departureTime ?? this.departureTime,
      destinationName: destinationName ?? this.destinationName,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      arrivalSelfieUrl: arrivalSelfieUrl ?? this.arrivalSelfieUrl,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      distanceKm: distanceKm ?? this.distanceKm,
      approvedKm: approvedKm ?? this.approvedKm,
      ratePerKm: ratePerKm ?? this.ratePerKm,
      totalAmount: totalAmount ?? this.totalAmount,
      travelMode: travelMode ?? this.travelMode,
      purpose: purpose ?? this.purpose,
      clientProjectId: clientProjectId ?? this.clientProjectId,
      clientProjectName: clientProjectName ?? this.clientProjectName,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      remarks: remarks ?? this.remarks,
    );
  }
}

/// Leave Quota Balance per Category
class LeaveBalance {
  final String id;
  final String employeeId;
  final LeaveType leaveType;
  final double totalAllocated;
  final double used;
  final double pending;
  final double balance;
  final int year;

  const LeaveBalance({
    required this.id,
    required this.employeeId,
    required this.leaveType,
    required this.totalAllocated,
    required this.used,
    required this.pending,
    required this.balance,
    required this.year,
  });
}

/// Formal Leave Application & Penalty Tracking
class LeaveApplication {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final String departmentName;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final double totalDays;
  final bool isHalfDay;
  final String reason;
  final ApprovalStatus status;
  final DateTime appliedDate;
  final String? reviewedBy;
  final DateTime? reviewedDate;
  final String? reviewRemarks;
  final bool isStrictPenaltyTriggered; // True if rejected & unapproved absence triggers penalty
  final double penaltyDeductionDays;  // Configurable e.g. 2.0x days

  const LeaveApplication({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.departmentName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    this.isHalfDay = false,
    required this.reason,
    this.status = ApprovalStatus.pending,
    required this.appliedDate,
    this.reviewedBy,
    this.reviewedDate,
    this.reviewRemarks,
    this.isStrictPenaltyTriggered = false,
    this.penaltyDeductionDays = 0.0,
  });

  LeaveApplication copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeCode,
    String? departmentName,
    LeaveType? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    double? totalDays,
    bool? isHalfDay,
    String? reason,
    ApprovalStatus? status,
    DateTime? appliedDate,
    String? reviewedBy,
    DateTime? reviewedDate,
    String? reviewRemarks,
    bool? isStrictPenaltyTriggered,
    double? penaltyDeductionDays,
  }) {
    return LeaveApplication(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeCode: employeeCode ?? this.employeeCode,
      departmentName: departmentName ?? this.departmentName,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      isHalfDay: isHalfDay ?? this.isHalfDay,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedDate: reviewedDate ?? this.reviewedDate,
      reviewRemarks: reviewRemarks ?? this.reviewRemarks,
      isStrictPenaltyTriggered: isStrictPenaltyTriggered ?? this.isStrictPenaltyTriggered,
      penaltyDeductionDays: penaltyDeductionDays ?? this.penaltyDeductionDays,
    );
  }
}

/// Performance Goal / OKR
class Goal {
  final String id;
  final String employeeId;
  final String title;
  final String description;
  final String category; // 'Sales', 'Design', 'Project Delivery', 'Customer CSAT'
  final double targetValue;
  final double currentValue;
  final String metricUnit; // 'INR Lacs', 'Projects', 'Reviews', '%'
  final double weightage; // 0 - 100%
  final GoalStatus status;
  final DateTime startDate;
  final DateTime dueDate;
  final DateTime? completionDate;
  final String? feedback;

  const Goal({
    required this.id,
    required this.employeeId,
    required this.title,
    required this.description,
    required this.category,
    required this.targetValue,
    required this.currentValue,
    required this.metricUnit,
    this.weightage = 25.0,
    this.status = GoalStatus.inProgress,
    required this.startDate,
    required this.dueDate,
    this.completionDate,
    this.feedback,
  });

  double get progressPercentage => targetValue > 0 ? (currentValue / targetValue * 100).clamp(0.0, 150.0) : 0.0;
}

/// Performance Appraisal & Review Record
class PerformanceReview {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final String departmentName;
  final String reviewerId;
  final String reviewerName;
  final String reviewPeriod; // e.g. 'Q3 2026', 'Annual 2025-26'
  final ReviewType reviewType;
  final double overallScore; // 1.0 to 5.0 scale
  final Map<String, double> kpiScores; // e.g. {'Delivery Speed': 4.5, 'Quality': 4.2}
  final String selfReviewComments;
  final String reviewerComments;
  final String recommendation; // 'Promote', 'Incentive Increment', 'PIP'
  final ApprovalStatus status;
  final DateTime reviewDate;

  const PerformanceReview({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.departmentName,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewPeriod,
    required this.reviewType,
    required this.overallScore,
    this.kpiScores = const {},
    this.selfReviewComments = '',
    this.reviewerComments = '',
    this.recommendation = 'Maintain',
    this.status = ApprovalStatus.approved,
    required this.reviewDate,
  });
}

/// Variable Incentive / Bonus Award
class Incentive {
  final String id;
  final String employeeId;
  final String employeeName;
  final IncentiveType type;
  final String title;
  final double amount;
  final String calculationBasis; // e.g. '2.5% of Villa Project Deal Value'
  final String period; // e.g. 'August 2026'
  final ApprovalStatus status;
  final String approvedBy;
  final bool isPaid;
  final DateTime? paidDate;
  final String? notes;

  const Incentive({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.title,
    required this.amount,
    required this.calculationBasis,
    required this.period,
    this.status = ApprovalStatus.approved,
    required this.approvedBy,
    this.isPaid = false,
    this.paidDate,
    this.notes,
  });
}

/// Deduction Record (Automatic or Manual)
class Deduction {
  final String id;
  final String employeeId;
  final String employeeName;
  final DeductionType type;
  final String title;
  final double amount;
  final bool isPolicyConfigurable;
  final double rateMultiplier; // e.g. 2.0x for unapproved leave penalty
  final String reason;
  final String period;
  final ApprovalStatus status;
  final String? notes;

  const Deduction({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.title,
    required this.amount,
    this.isPolicyConfigurable = false,
    this.rateMultiplier = 1.0,
    required this.reason,
    required this.period,
    this.status = ApprovalStatus.approved,
    this.notes,
  });
}

/// Salary Component Breakdown
class SalaryComponent {
  final String id;
  final String name;
  final bool isEarning; // true = earning, false = deduction
  final bool isTaxable;
  final bool isStatutory;
  final double monthlyAmount;

  const SalaryComponent({
    required this.id,
    required this.name,
    this.isEarning = true,
    this.isTaxable = true,
    this.isStatutory = false,
    required this.monthlyAmount,
  });
}

/// Master Salary Structure for an Employee
class SalaryStructure {
  final String id;
  final String employeeId;
  final double basicSalary;
  final double hra;
  final double conveyanceAllowance;
  final double specialAllowance;
  final double medicalAllowance;
  final double pfEmployee;
  final double esiEmployee;
  final double professionalTax;

  const SalaryStructure({
    required this.id,
    required this.employeeId,
    required this.basicSalary,
    required this.hra,
    required this.conveyanceAllowance,
    required this.specialAllowance,
    required this.medicalAllowance,
    this.pfEmployee = 1800.0,
    this.esiEmployee = 0.0,
    this.professionalTax = 200.0,
  });

  double get grossMonthly => basicSalary + hra + conveyanceAllowance + specialAllowance + medicalAllowance;
  double get totalStatutoryDeductions => pfEmployee + esiEmployee + professionalTax;
  double get netMonthly => grossMonthly - totalStatutoryDeductions;
  double get annualCtc => (grossMonthly + pfEmployee) * 12; // with employer PF
}

/// Monthly Payroll Run Cycle
class PayrollPeriod {
  final String id;
  final String name; // e.g. 'August 2026'
  final int month;
  final int year;
  final DateTime startDate;
  final DateTime endDate;
  final PayrollStatus status;
  final int totalEmployees;
  final double totalGross;
  final double totalDeductions;
  final double totalNet;
  final DateTime? processedDate;

  const PayrollPeriod({
    required this.id,
    required this.name,
    required this.month,
    required this.year,
    required this.startDate,
    required this.endDate,
    this.status = PayrollStatus.paid,
    required this.totalEmployees,
    required this.totalGross,
    required this.totalDeductions,
    required this.totalNet,
    this.processedDate,
  });
}

/// Individual Employee Payroll Record in a Period
class PayrollRecord {
  final String id;
  final String payrollPeriodId;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final String departmentName;
  final String designation;
  final int workingDays;
  final int presentDays;
  final double paidLeaveDays;
  final double unpaidLeaveDays;
  final int absentDays;
  final double penaltyDeductionDays; // e.g. 2 days for unapproved leave
  final double baseSalary;
  final double hra;
  final double specialAllowance;
  final double travelReimbursement;
  final double incentivesTotal;
  final double grossEarnings;
  final double pfDeduction;
  final double professionalTax;
  final double policyPenaltyDeduction;
  final double otherDeductions;
  final double totalDeductions;
  final double netPay;
  final PayrollStatus paymentStatus;
  final String paymentMethod;
  final String paymentReference;
  final DateTime? paidDate;

  const PayrollRecord({
    required this.id,
    required this.payrollPeriodId,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.departmentName,
    required this.designation,
    this.workingDays = 26,
    this.presentDays = 24,
    this.paidLeaveDays = 2,
    this.unpaidLeaveDays = 0,
    this.absentDays = 0,
    this.penaltyDeductionDays = 0,
    required this.baseSalary,
    required this.hra,
    required this.specialAllowance,
    this.travelReimbursement = 0.0,
    this.incentivesTotal = 0.0,
    required this.grossEarnings,
    this.pfDeduction = 1800.0,
    this.professionalTax = 200.0,
    this.policyPenaltyDeduction = 0.0,
    this.otherDeductions = 0.0,
    required this.totalDeductions,
    required this.netPay,
    this.paymentStatus = PayrollStatus.paid,
    this.paymentMethod = 'NEFT Direct Deposit',
    this.paymentReference = 'CMS-TXN-882910',
    this.paidDate,
  });
}

/// Official Resignation Submission
class Resignation {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final String departmentName;
  final DateTime submissionDate;
  final DateTime requestedRelievingDate;
  final DateTime officialLastWorkingDate;
  final int noticePeriodDays;
  final String reason;
  final String reasonCategory; // 'Higher Studies', 'Better Opportunity', 'Relocation'
  final ApprovalStatus status;
  final String feedback;
  final bool isEligibleForRehire;

  const Resignation({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.departmentName,
    required this.submissionDate,
    required this.requestedRelievingDate,
    required this.officialLastWorkingDate,
    required this.noticePeriodDays,
    required this.reason,
    required this.reasonCategory,
    this.status = ApprovalStatus.approved,
    this.feedback = '',
    this.isEligibleForRehire = true,
  });

  int get remainingNoticeDays => officialLastWorkingDate.difference(DateTime.now()).inDays.clamp(0, 365);
}

/// Task / Asset Handover Item
class HandoverChecklist {
  final String id;
  final String resignationId;
  final String employeeId;
  final String item;
  final String category; // 'Project Files', 'Client Contacts', 'Code Repository', 'Design Tokens'
  final String assigneeEmployeeId;
  final String assigneeName;
  final bool isCompleted;
  final DateTime? completedDate;
  final String? notes;

  const HandoverChecklist({
    required this.id,
    required this.resignationId,
    required this.employeeId,
    required this.item,
    required this.category,
    required this.assigneeEmployeeId,
    required this.assigneeName,
    this.isCompleted = false,
    this.completedDate,
    this.notes,
  });

  HandoverChecklist copyWith({
    String? id,
    String? resignationId,
    String? employeeId,
    String? item,
    String? category,
    String? assigneeEmployeeId,
    String? assigneeName,
    bool? isCompleted,
    DateTime? completedDate,
    String? notes,
  }) {
    return HandoverChecklist(
      id: id ?? this.id,
      resignationId: resignationId ?? this.resignationId,
      employeeId: employeeId ?? this.employeeId,
      item: item ?? this.item,
      category: category ?? this.category,
      assigneeEmployeeId: assigneeEmployeeId ?? this.assigneeEmployeeId,
      assigneeName: assigneeName ?? this.assigneeName,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
      notes: notes ?? this.notes,
    );
  }
}

/// Departmental No-Dues Clearance Signoff
class ClearanceRecord {
  final String id;
  final String resignationId;
  final String employeeId;
  final String department; // 'IT & Infrastructure', 'Finance & Accounts', 'HR & Admin', 'Project Manager'
  final ClearanceStatus status;
  final String clearedBy;
  final DateTime? clearedDate;
  final String remarks;
  final double duesPending;

  const ClearanceRecord({
    required this.id,
    required this.resignationId,
    required this.employeeId,
    required this.department,
    this.status = ClearanceStatus.pending,
    required this.clearedBy,
    this.clearedDate,
    this.remarks = '',
    this.duesPending = 0.0,
  });

  ClearanceRecord copyWith({
    String? id,
    String? resignationId,
    String? employeeId,
    String? department,
    ClearanceStatus? status,
    String? clearedBy,
    DateTime? clearedDate,
    String? remarks,
    double? duesPending,
  }) {
    return ClearanceRecord(
      id: id ?? this.id,
      resignationId: resignationId ?? this.resignationId,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      status: status ?? this.status,
      clearedBy: clearedBy ?? this.clearedBy,
      clearedDate: clearedDate ?? this.clearedDate,
      remarks: remarks ?? this.remarks,
      duesPending: duesPending ?? this.duesPending,
    );
  }
}

/// Audit Trail & Activity Log
class EmployeeActivity {
  final String id;
  final String employeeId;
  final String title;
  final String description;
  final DateTime timestamp;
  final String activityType; // 'attendance', 'leave', 'travel', 'payroll', 'performance'
  final String iconName;

  const EmployeeActivity({
    required this.id,
    required this.employeeId,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.activityType,
    required this.iconName,
  });
}

/// Configurable Corporate HR Policies (No hardcoding)
class HrmsPolicyConfig {
  final bool doubleSalaryDeductionEnabled;
  final double unauthorizedAbsenceMultiplier; // Default 2.0x (Double day deduction)
  final int lateArrivalGraceMinutes; // Default 15 mins
  final int lateArrivalThresholdPenaltyCount; // e.g. 3 late arrivals = half day deduction
  final int standardNoticePeriodDays; // e.g. 30 days
  final double bikeMileageRatePerKm; // INR 4.5
  final double carMileageRatePerKm; // INR 10.0
  final bool selfieVerificationRequired;
  final bool geofenceEnforcementStrict;
  final double defaultGeofenceRadiusMeters;

  const HrmsPolicyConfig({
    this.doubleSalaryDeductionEnabled = true,
    this.unauthorizedAbsenceMultiplier = 2.0,
    this.lateArrivalGraceMinutes = 15,
    this.lateArrivalThresholdPenaltyCount = 3,
    this.standardNoticePeriodDays = 30,
    this.bikeMileageRatePerKm = 4.5,
    this.carMileageRatePerKm = 10.0,
    this.selfieVerificationRequired = true,
    this.geofenceEnforcementStrict = true,
    this.defaultGeofenceRadiusMeters = 150.0,
  });

  HrmsPolicyConfig copyWith({
    bool? doubleSalaryDeductionEnabled,
    double? unauthorizedAbsenceMultiplier,
    int? lateArrivalGraceMinutes,
    int? lateArrivalThresholdPenaltyCount,
    int? standardNoticePeriodDays,
    double? bikeMileageRatePerKm,
    double? carMileageRatePerKm,
    bool? selfieVerificationRequired,
    bool? geofenceEnforcementStrict,
    double? defaultGeofenceRadiusMeters,
  }) {
    return HrmsPolicyConfig(
      doubleSalaryDeductionEnabled: doubleSalaryDeductionEnabled ?? this.doubleSalaryDeductionEnabled,
      unauthorizedAbsenceMultiplier: unauthorizedAbsenceMultiplier ?? this.unauthorizedAbsenceMultiplier,
      lateArrivalGraceMinutes: lateArrivalGraceMinutes ?? this.lateArrivalGraceMinutes,
      lateArrivalThresholdPenaltyCount: lateArrivalThresholdPenaltyCount ?? this.lateArrivalThresholdPenaltyCount,
      standardNoticePeriodDays: standardNoticePeriodDays ?? this.standardNoticePeriodDays,
      bikeMileageRatePerKm: bikeMileageRatePerKm ?? this.bikeMileageRatePerKm,
      carMileageRatePerKm: carMileageRatePerKm ?? this.carMileageRatePerKm,
      selfieVerificationRequired: selfieVerificationRequired ?? this.selfieVerificationRequired,
      geofenceEnforcementStrict: geofenceEnforcementStrict ?? this.geofenceEnforcementStrict,
      defaultGeofenceRadiusMeters: defaultGeofenceRadiusMeters ?? this.defaultGeofenceRadiusMeters,
    );
  }
}

/// HRMS Executive Command Center Stats
class HrmsDashboardStats {
  final int totalHeadcount;
  final int activeEmployees;
  final int onProbation;
  final int onNoticePeriod;
  final int presentToday;
  final int absentToday;
  final int lateToday;
  final int onFieldTravelToday;
  final int pendingLeaveRequests;
  final int pendingTravelClaims;
  final double monthlyPayrollBudget;
  final double disbursedThisMonth;
  final int pendingClearanceCount;

  const HrmsDashboardStats({
    required this.totalHeadcount,
    required this.activeEmployees,
    required this.onProbation,
    required this.onNoticePeriod,
    required this.presentToday,
    required this.absentToday,
    required this.lateToday,
    required this.onFieldTravelToday,
    required this.pendingLeaveRequests,
    required this.pendingTravelClaims,
    required this.monthlyPayrollBudget,
    required this.disbursedThisMonth,
    required this.pendingClearanceCount,
  });
}
