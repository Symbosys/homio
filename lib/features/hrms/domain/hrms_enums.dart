import 'package:flutter/material.dart';

/// Employee Lifecycle Status
enum EmployeeStatus {
  active,
  probation,
  noticePeriod,
  onLeave,
  suspended,
  resigned,
  terminated,
  retired,
}

extension EmployeeStatusExtension on EmployeeStatus {
  String get label {
    switch (this) {
      case EmployeeStatus.active:
        return 'Active';
      case EmployeeStatus.probation:
        return 'On Probation';
      case EmployeeStatus.noticePeriod:
        return 'Serving Notice';
      case EmployeeStatus.onLeave:
        return 'On Leave';
      case EmployeeStatus.suspended:
        return 'Suspended';
      case EmployeeStatus.resigned:
        return 'Resigned';
      case EmployeeStatus.terminated:
        return 'Terminated';
      case EmployeeStatus.retired:
        return 'Retired';
    }
  }

  Color get color {
    switch (this) {
      case EmployeeStatus.active:
        return const Color(0xFF10B981); // emerald
      case EmployeeStatus.probation:
        return const Color(0xFFF59E0B); // amber
      case EmployeeStatus.noticePeriod:
        return const Color(0xFF8B5CF6); // purple
      case EmployeeStatus.onLeave:
        return const Color(0xFF06B6D4); // cyan
      case EmployeeStatus.suspended:
        return const Color(0xFFEF4444); // red
      case EmployeeStatus.resigned:
        return const Color(0xFF64748B); // slate
      case EmployeeStatus.terminated:
        return const Color(0xFFDC2626); // dark red
      case EmployeeStatus.retired:
        return const Color(0xFF475569); // grey
    }
  }

  IconData get icon {
    switch (this) {
      case EmployeeStatus.active:
        return Icons.check_circle_outline;
      case EmployeeStatus.probation:
        return Icons.timelapse;
      case EmployeeStatus.noticePeriod:
        return Icons.timer_outlined;
      case EmployeeStatus.onLeave:
        return Icons.beach_access_outlined;
      case EmployeeStatus.suspended:
        return Icons.block;
      case EmployeeStatus.resigned:
        return Icons.exit_to_app;
      case EmployeeStatus.terminated:
        return Icons.person_off_outlined;
      case EmployeeStatus.retired:
        return Icons.elderly;
    }
  }
}

/// Employment Type Contract
enum EmploymentType {
  fullTime,
  partTime,
  contract,
  intern,
  consultant,
}

extension EmploymentTypeExtension on EmploymentType {
  String get label {
    switch (this) {
      case EmploymentType.fullTime:
        return 'Full Time';
      case EmploymentType.partTime:
        return 'Part Time';
      case EmploymentType.contract:
        return 'Contractual';
      case EmploymentType.intern:
        return 'Intern';
      case EmploymentType.consultant:
        return 'Consultant';
    }
  }

  Color get color {
    switch (this) {
      case EmploymentType.fullTime:
        return const Color(0xFF3B82F6);
      case EmploymentType.partTime:
        return const Color(0xFF8B5CF6);
      case EmploymentType.contract:
        return const Color(0xFFF97316);
      case EmploymentType.intern:
        return const Color(0xFF14B8A6);
      case EmploymentType.consultant:
        return const Color(0xFF6366F1);
    }
  }
}

/// Granular Attendance Status
enum AttendanceStatus {
  present,
  absent,
  halfDay,
  lateArrival,
  earlyDeparture,
  onLeave,
  holiday,
  weeklyOff,
  missedPunch,
  regularized,
  wfh,
}

extension AttendanceStatusExtension on AttendanceStatus {
  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.lateArrival:
        return 'Late Arrival';
      case AttendanceStatus.earlyDeparture:
        return 'Early Exit';
      case AttendanceStatus.onLeave:
        return 'On Leave';
      case AttendanceStatus.holiday:
        return 'Holiday';
      case AttendanceStatus.weeklyOff:
        return 'Weekly Off';
      case AttendanceStatus.missedPunch:
        return 'Missed Punch';
      case AttendanceStatus.regularized:
        return 'Regularized';
      case AttendanceStatus.wfh:
        return 'Work From Home';
    }
  }

  Color get color {
    switch (this) {
      case AttendanceStatus.present:
        return const Color(0xFF10B981);
      case AttendanceStatus.absent:
        return const Color(0xFFEF4444);
      case AttendanceStatus.halfDay:
        return const Color(0xFFF59E0B);
      case AttendanceStatus.lateArrival:
        return const Color(0xFFFB923C);
      case AttendanceStatus.earlyDeparture:
        return const Color(0xFFEAB308);
      case AttendanceStatus.onLeave:
        return const Color(0xFF06B6D4);
      case AttendanceStatus.holiday:
        return const Color(0xFF8B5CF6);
      case AttendanceStatus.weeklyOff:
        return const Color(0xFF94A3B8);
      case AttendanceStatus.missedPunch:
        return const Color(0xFFDC2626);
      case AttendanceStatus.regularized:
        return const Color(0xFF3B82F6);
      case AttendanceStatus.wfh:
        return const Color(0xFF6366F1);
    }
  }
}

/// Geofence Boundary Check
enum GeofenceStatus {
  inside,
  outside,
  warning,
  remoteAllowed,
  unknown,
}

extension GeofenceStatusExtension on GeofenceStatus {
  String get label {
    switch (this) {
      case GeofenceStatus.inside:
        return 'Inside Geofence';
      case GeofenceStatus.outside:
        return 'Outside Geofence';
      case GeofenceStatus.warning:
        return 'Borderline (~50m)';
      case GeofenceStatus.remoteAllowed:
        return 'Remote Approved';
      case GeofenceStatus.unknown:
        return 'GPS Unavailable';
    }
  }

  Color get color {
    switch (this) {
      case GeofenceStatus.inside:
        return const Color(0xFF10B981);
      case GeofenceStatus.outside:
        return const Color(0xFFEF4444);
      case GeofenceStatus.warning:
        return const Color(0xFFF59E0B);
      case GeofenceStatus.remoteAllowed:
        return const Color(0xFF3B82F6);
      case GeofenceStatus.unknown:
        return const Color(0xFF64748B);
    }
  }
}

/// Clock In/Out Punch Type
enum PunchType {
  checkIn,
  checkOut,
  breakStart,
  breakEnd,
}

/// Types of Leave
enum LeaveType {
  casual,
  sick,
  earned,
  maternity,
  paternity,
  bereavement,
  compOff,
  unpaid,
}

extension LeaveTypeExtension on LeaveType {
  String get label {
    switch (this) {
      case LeaveType.casual:
        return 'Casual Leave (CL)';
      case LeaveType.sick:
        return 'Sick Leave (SL)';
      case LeaveType.earned:
        return 'Earned Leave (EL)';
      case LeaveType.maternity:
        return 'Maternity Leave';
      case LeaveType.paternity:
        return 'Paternity Leave';
      case LeaveType.bereavement:
        return 'Bereavement Leave';
      case LeaveType.compOff:
        return 'Compensatory Off';
      case LeaveType.unpaid:
        return 'Loss of Pay (LWP)';
    }
  }

  String get shortCode {
    switch (this) {
      case LeaveType.casual:
        return 'CL';
      case LeaveType.sick:
        return 'SL';
      case LeaveType.earned:
        return 'EL';
      case LeaveType.maternity:
        return 'ML';
      case LeaveType.paternity:
        return 'PL';
      case LeaveType.bereavement:
        return 'BL';
      case LeaveType.compOff:
        return 'CO';
      case LeaveType.unpaid:
        return 'LWP';
    }
  }

  Color get color {
    switch (this) {
      case LeaveType.casual:
        return const Color(0xFF3B82F6);
      case LeaveType.sick:
        return const Color(0xFFEF4444);
      case LeaveType.earned:
        return const Color(0xFF10B981);
      case LeaveType.maternity:
        return const Color(0xFFEC4899);
      case LeaveType.paternity:
        return const Color(0xFF8B5CF6);
      case LeaveType.bereavement:
        return const Color(0xFF64748B);
      case LeaveType.compOff:
        return const Color(0xFFF59E0B);
      case LeaveType.unpaid:
        return const Color(0xFF94A3B8);
    }
  }
}

/// Generic Approval State
enum ApprovalStatus {
  pending,
  approved,
  rejected,
  cancelled,
  draft,
}

extension ApprovalStatusExtension on ApprovalStatus {
  String get label {
    switch (this) {
      case ApprovalStatus.pending:
        return 'Pending';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
      case ApprovalStatus.cancelled:
        return 'Cancelled';
      case ApprovalStatus.draft:
        return 'Draft';
    }
  }

  Color get color {
    switch (this) {
      case ApprovalStatus.pending:
        return const Color(0xFFF59E0B);
      case ApprovalStatus.approved:
        return const Color(0xFF10B981);
      case ApprovalStatus.rejected:
        return const Color(0xFFEF4444);
      case ApprovalStatus.cancelled:
        return const Color(0xFF64748B);
      case ApprovalStatus.draft:
        return const Color(0xFF94A3B8);
    }
  }
}

/// Payroll Processing Cycle Status
enum PayrollStatus {
  draft,
  pendingReview,
  approved,
  processed,
  paid,
  hold,
}

extension PayrollStatusExtension on PayrollStatus {
  String get label {
    switch (this) {
      case PayrollStatus.draft:
        return 'Draft';
      case PayrollStatus.pendingReview:
        return 'Under Review';
      case PayrollStatus.approved:
        return 'Approved';
      case PayrollStatus.processed:
        return 'Processed';
      case PayrollStatus.paid:
        return 'Disbursed / Paid';
      case PayrollStatus.hold:
        return 'On Hold';
    }
  }

  Color get color {
    switch (this) {
      case PayrollStatus.draft:
        return const Color(0xFF64748B);
      case PayrollStatus.pendingReview:
        return const Color(0xFFF59E0B);
      case PayrollStatus.approved:
        return const Color(0xFF3B82F6);
      case PayrollStatus.processed:
        return const Color(0xFF8B5CF6);
      case PayrollStatus.paid:
        return const Color(0xFF10B981);
      case PayrollStatus.hold:
        return const Color(0xFFEF4444);
    }
  }
}

/// Incentive Categories
enum IncentiveType {
  salesCommission,
  performanceBonus,
  projectMilestone,
  spotAward,
  retentionBonus,
  fieldTravelAllowance,
}

extension IncentiveTypeExtension on IncentiveType {
  String get label {
    switch (this) {
      case IncentiveType.salesCommission:
        return 'Sales Commission';
      case IncentiveType.performanceBonus:
        return 'Performance Bonus';
      case IncentiveType.projectMilestone:
        return 'Milestone Achievement';
      case IncentiveType.spotAward:
        return 'Spot Excellence Award';
      case IncentiveType.retentionBonus:
        return 'Retention Bonus';
      case IncentiveType.fieldTravelAllowance:
        return 'Field Mileage Allowance';
    }
  }

  Color get color {
    switch (this) {
      case IncentiveType.salesCommission:
        return const Color(0xFF10B981);
      case IncentiveType.performanceBonus:
        return const Color(0xFF6366F1);
      case IncentiveType.projectMilestone:
        return const Color(0xFF3B82F6);
      case IncentiveType.spotAward:
        return const Color(0xFFEC4899);
      case IncentiveType.retentionBonus:
        return const Color(0xFF8B5CF6);
      case IncentiveType.fieldTravelAllowance:
        return const Color(0xFFF59E0B);
    }
  }
}

/// Deduction Categories (including policy-based penalties)
enum DeductionType {
  unauthorizedAbsencePenalty, // e.g. double salary deduction rule
  latePenalty,
  providentFund,
  employeeStateInsurance,
  professionalTax,
  taxDeductedAtSource,
  advanceRecovery,
  assetDamage,
  lossOfPay,
}

extension DeductionTypeExtension on DeductionType {
  String get label {
    switch (this) {
      case DeductionType.unauthorizedAbsencePenalty:
        return 'Unauthorized Absence (Policy Deduction)';
      case DeductionType.latePenalty:
        return 'Excessive Late Arrival Penalty';
      case DeductionType.providentFund:
        return 'Provident Fund (PF)';
      case DeductionType.employeeStateInsurance:
        return 'ESIC';
      case DeductionType.professionalTax:
        return 'Professional Tax (PT)';
      case DeductionType.taxDeductedAtSource:
        return 'TDS (Income Tax)';
      case DeductionType.advanceRecovery:
        return 'Salary Advance Recovery';
      case DeductionType.assetDamage:
        return 'Asset / Tool Damage Charge';
      case DeductionType.lossOfPay:
        return 'Loss of Pay (Unpaid Leave)';
    }
  }
}

/// Goal State for KPI & Performance
enum GoalStatus {
  notStarted,
  inProgress,
  achieved,
  exceeded,
  cancelled,
}

extension GoalStatusExtension on GoalStatus {
  String get label {
    switch (this) {
      case GoalStatus.notStarted:
        return 'Not Started';
      case GoalStatus.inProgress:
        return 'In Progress';
      case GoalStatus.achieved:
        return 'Achieved';
      case GoalStatus.exceeded:
        return 'Exceeded (100%+)';
      case GoalStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case GoalStatus.notStarted:
        return const Color(0xFF64748B);
      case GoalStatus.inProgress:
        return const Color(0xFF3B82F6);
      case GoalStatus.achieved:
        return const Color(0xFF10B981);
      case GoalStatus.exceeded:
        return const Color(0xFF8B5CF6);
      case GoalStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

/// Review Cadence
enum ReviewType {
  quarterly,
  annual,
  probation,
  midYear,
  projectBased,
}

extension ReviewTypeExtension on ReviewType {
  String get label {
    switch (this) {
      case ReviewType.quarterly:
        return 'Quarterly Review';
      case ReviewType.annual:
        return 'Annual Appraisal';
      case ReviewType.probation:
        return 'Probation Assessment';
      case ReviewType.midYear:
        return 'Mid-Year Review';
      case ReviewType.projectBased:
        return 'Project Completion';
    }
  }
}

/// Resignation Department Clearance Status
enum ClearanceStatus {
  pending,
  approved,
  rejected,
  waived,
  na,
}

extension ClearanceStatusExtension on ClearanceStatus {
  String get label {
    switch (this) {
      case ClearanceStatus.pending:
        return 'Pending Signoff';
      case ClearanceStatus.approved:
        return 'Cleared';
      case ClearanceStatus.rejected:
        return 'Action Required / Blocked';
      case ClearanceStatus.waived:
        return 'Waived by Management';
      case ClearanceStatus.na:
        return 'Not Applicable';
    }
  }

  Color get color {
    switch (this) {
      case ClearanceStatus.pending:
        return const Color(0xFFF59E0B);
      case ClearanceStatus.approved:
        return const Color(0xFF10B981);
      case ClearanceStatus.rejected:
        return const Color(0xFFEF4444);
      case ClearanceStatus.waived:
        return const Color(0xFF6366F1);
      case ClearanceStatus.na:
        return const Color(0xFF64748B);
    }
  }
}

/// Field Travel Transport Mode
enum TravelMode {
  bike,
  car,
  publicTransport,
  auto,
  walking,
}

extension TravelModeExtension on TravelMode {
  String get label {
    switch (this) {
      case TravelMode.bike:
        return 'Two-Wheeler / Bike';
      case TravelMode.car:
        return 'Car / Four-Wheeler';
      case TravelMode.publicTransport:
        return 'Metro / Train / Bus';
      case TravelMode.auto:
        return 'Auto / Cab (Uber/Ola)';
      case TravelMode.walking:
        return 'Walking';
    }
  }

  IconData get icon {
    switch (this) {
      case TravelMode.bike:
        return Icons.two_wheeler;
      case TravelMode.car:
        return Icons.directions_car;
      case TravelMode.publicTransport:
        return Icons.train;
      case TravelMode.auto:
        return Icons.local_taxi;
      case TravelMode.walking:
        return Icons.directions_walk;
    }
  }

  double get defaultRatePerKm {
    switch (this) {
      case TravelMode.bike:
        return 4.5;
      case TravelMode.car:
        return 10.0;
      case TravelMode.publicTransport:
        return 2.5;
      case TravelMode.auto:
        return 8.0;
      case TravelMode.walking:
        return 0.0;
    }
  }
}

/// Official KYC & Onboarding Documents
enum DocumentType {
  aadhaar,
  pan,
  passport,
  drivingLicense,
  educationDegree,
  experienceLetter,
  salarySlip,
  photo,
  offerLetter,
  nda,
}

extension DocumentTypeExtension on DocumentType {
  String get label {
    switch (this) {
      case DocumentType.aadhaar:
        return 'Aadhaar Card';
      case DocumentType.pan:
        return 'PAN Card';
      case DocumentType.passport:
        return 'Passport';
      case DocumentType.drivingLicense:
        return 'Driving License';
      case DocumentType.educationDegree:
        return 'Degree Certificate';
      case DocumentType.experienceLetter:
        return 'Previous Experience Letter';
      case DocumentType.salarySlip:
        return 'Previous Salary Slips';
      case DocumentType.photo:
        return 'Passport Size Photo';
      case DocumentType.offerLetter:
        return 'Signed Offer Letter';
      case DocumentType.nda:
        return 'Signed NDA & Policy';
    }
  }
}
