import 'hrms_salary_api_model.dart';

/// Mini representation for reporting manager / subordinates
class EmployeeMiniInfo {
  final String id;
  final String employeeCode;
  final String firstName;
  final String? lastName;
  final String designation;
  final String? workEmail;
  final String? employmentStatus;

  const EmployeeMiniInfo({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    this.lastName,
    required this.designation,
    this.workEmail,
    this.employmentStatus,
  });

  String get fullName => '$firstName ${lastName ?? ""}'.trim();

  factory EmployeeMiniInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeMiniInfo(
      id: json['id']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString(),
      designation: json['designation']?.toString() ?? '',
      workEmail: json['workEmail']?.toString(),
      employmentStatus: json['employmentStatus']?.toString(),
    );
  }
}

/// Mini representation of assigned department
class DepartmentMiniInfo {
  final String id;
  final String name;
  final String code;

  const DepartmentMiniInfo({
    required this.id,
    required this.name,
    required this.code,
  });

  factory DepartmentMiniInfo.fromJson(Map<String, dynamic> json) {
    return DepartmentMiniInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}

/// Mini representation of assigned team
class TeamMiniInfo {
  final String id;
  final String name;
  final String code;

  const TeamMiniInfo({
    required this.id,
    required this.name,
    required this.code,
  });

  factory TeamMiniInfo.fromJson(Map<String, dynamic> json) {
    return TeamMiniInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}

/// Linked User Account Info
class EmployeeUserInfo {
  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String status;
  final String? userType;

  const EmployeeUserInfo({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    required this.status,
    this.userType,
  });

  factory EmployeeUserInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeUserInfo(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      userType: json['userType']?.toString(),
    );
  }
}

/// Complete Industry-Standard Employee API Model
class HrmsEmployeeApiModel {
  final String id;
  final String organizationId;
  final String? userId;
  final EmployeeUserInfo? user;

  // Identification
  final String employeeCode;
  final String firstName;
  final String? middleName;
  final String? lastName;
  final String? displayName;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? maritalStatus;
  final String? bloodGroup;

  // Contact Information
  final String? workEmail;
  final String? personalEmail;
  final String? workPhone;
  final String? personalPhone;

  // Emergency Contact
  final String? emergencyContactName;
  final String? emergencyContactRelationship;
  final String? emergencyContactPhone;

  // Residential Addresses
  final String? currentAddress;
  final String? currentCity;
  final String? currentState;
  final String currentCountry;
  final String? currentPincode;

  final String? permanentAddress;
  final String? permanentCity;
  final String? permanentState;
  final String permanentCountry;
  final String? permanentPincode;

  // Employment & Hierarchy
  final String employmentType;
  final String employmentStatus;
  final String designation;
  final String? workLocation;

  final String? reportingManagerId;
  final EmployeeMiniInfo? reportingManager;
  final List<EmployeeMiniInfo> subordinates;

  // Department & Team Assignment
  final DepartmentMiniInfo? department;
  final TeamMiniInfo? team;
  final String? departmentRole;

  // Timeline & Lifecycle Dates
  final DateTime joiningDate;
  final DateTime? probationEndDate;
  final DateTime? confirmationDate;
  final int noticePeriodDays;
  final DateTime? resignationDate;
  final DateTime? noticePeriodEndDate;
  final DateTime? relievingDate;
  final DateTime? terminationDate;
  final String? terminationReason;

  // Statutory & Compliance
  final String? panNumber;
  final String? aadhaarNumber;
  final String? uanNumber;
  final String? pfNumber;
  final String? esiNumber;
  final String? passportNumber;
  final String taxRegime;

  // Bank Payout Details
  final String? bankAccountHolderName;
  final String? bankAccountNumber;
  final String? bankName;
  final String? bankIfscCode;
  final String? bankBranchName;

  // Media / Documents
  final dynamic documents;

  // Active Compensation
  final HrmsSalaryApiModel? currentSalary;

  final DateTime createdAt;
  final DateTime updatedAt;

  const HrmsEmployeeApiModel({
    required this.id,
    required this.organizationId,
    this.userId,
    this.user,
    required this.employeeCode,
    required this.firstName,
    this.middleName,
    this.lastName,
    this.displayName,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.maritalStatus,
    this.bloodGroup,
    this.workEmail,
    this.personalEmail,
    this.workPhone,
    this.personalPhone,
    this.emergencyContactName,
    this.emergencyContactRelationship,
    this.emergencyContactPhone,
    this.currentAddress,
    this.currentCity,
    this.currentState,
    this.currentCountry = 'IN',
    this.currentPincode,
    this.permanentAddress,
    this.permanentCity,
    this.permanentState,
    this.permanentCountry = 'IN',
    this.permanentPincode,
    required this.employmentType,
    required this.employmentStatus,
    required this.designation,
    this.workLocation,
    this.reportingManagerId,
    this.reportingManager,
    this.subordinates = const [],
    this.department,
    this.team,
    this.departmentRole,
    required this.joiningDate,
    this.probationEndDate,
    this.confirmationDate,
    this.noticePeriodDays = 30,
    this.resignationDate,
    this.noticePeriodEndDate,
    this.relievingDate,
    this.terminationDate,
    this.terminationReason,
    this.panNumber,
    this.aadhaarNumber,
    this.uanNumber,
    this.pfNumber,
    this.esiNumber,
    this.passportNumber,
    this.taxRegime = 'NEW',
    this.bankAccountHolderName,
    this.bankAccountNumber,
    this.bankName,
    this.bankIfscCode,
    this.bankBranchName,
    this.documents,
    this.currentSalary,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName {
    final parts = [firstName, middleName, lastName].where((s) => s != null && s.trim().isNotEmpty);
    return parts.isEmpty ? 'Unnamed Employee' : parts.join(' ');
  }

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = (lastName != null && lastName!.isNotEmpty) ? lastName![0] : '';
    return '$f$l'.toUpperCase();
  }

  static String? _parseAvatarUrl(dynamic val) {
    if (val == null) return null;
    if (val is String) return val.isEmpty ? null : val;
    if (val is Map<String, dynamic>) {
      return val['url'] as String? ?? val['secureUrl'] as String?;
    }
    return null;
  }

  static DateTime? _parseDate(dynamic val) {
    if (val == null) return null;
    return DateTime.tryParse(val.toString());
  }

  factory HrmsEmployeeApiModel.fromJson(Map<String, dynamic> json) {
    // Current salary can arrive as array with 1 item or direct object
    HrmsSalaryApiModel? parsedSalary;
    if (json['salaries'] is List && (json['salaries'] as List).isNotEmpty) {
      parsedSalary = HrmsSalaryApiModel.fromJson((json['salaries'] as List).first as Map<String, dynamic>);
    } else if (json['currentSalary'] is Map<String, dynamic>) {
      parsedSalary = HrmsSalaryApiModel.fromJson(json['currentSalary'] as Map<String, dynamic>);
    }

    return HrmsEmployeeApiModel(
      id: json['id']?.toString() ?? '',
      organizationId: json['organizationId']?.toString() ?? '',
      userId: json['userId']?.toString(),
      user: json['user'] is Map<String, dynamic> ? EmployeeUserInfo.fromJson(json['user'] as Map<String, dynamic>) : null,
      employeeCode: json['employeeCode']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      middleName: json['middleName']?.toString(),
      lastName: json['lastName']?.toString(),
      displayName: json['displayName']?.toString(),
      avatarUrl: _parseAvatarUrl(json['avatarUrl']),
      gender: json['gender']?.toString(),
      dateOfBirth: _parseDate(json['dateOfBirth']),
      maritalStatus: json['maritalStatus']?.toString(),
      bloodGroup: json['bloodGroup']?.toString(),
      workEmail: json['workEmail']?.toString(),
      personalEmail: json['personalEmail']?.toString(),
      workPhone: json['workPhone']?.toString(),
      personalPhone: json['personalPhone']?.toString(),
      emergencyContactName: json['emergencyContactName']?.toString(),
      emergencyContactRelationship: json['emergencyContactRelationship']?.toString(),
      emergencyContactPhone: json['emergencyContactPhone']?.toString(),
      currentAddress: json['currentAddress']?.toString(),
      currentCity: json['currentCity']?.toString(),
      currentState: json['currentState']?.toString(),
      currentCountry: json['currentCountry']?.toString() ?? 'IN',
      currentPincode: json['currentPincode']?.toString(),
      permanentAddress: json['permanentAddress']?.toString(),
      permanentCity: json['permanentCity']?.toString(),
      permanentState: json['permanentState']?.toString(),
      permanentCountry: json['permanentCountry']?.toString() ?? 'IN',
      permanentPincode: json['permanentPincode']?.toString(),
      employmentType: json['employmentType']?.toString() ?? 'FULL_TIME',
      employmentStatus: json['employmentStatus']?.toString() ?? 'ACTIVE',
      designation: json['designation']?.toString() ?? '',
      workLocation: json['workLocation']?.toString(),
      reportingManagerId: json['reportingManagerId']?.toString(),
      reportingManager: json['reportingManager'] is Map<String, dynamic>
          ? EmployeeMiniInfo.fromJson(json['reportingManager'] as Map<String, dynamic>)
          : null,
      subordinates: json['subordinates'] is List
          ? (json['subordinates'] as List)
              .map((e) => EmployeeMiniInfo.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      department: () {
        if (json['department'] != null && json['department'] is Map) {
          return DepartmentMiniInfo.fromJson(Map<String, dynamic>.from(json['department'] as Map));
        }
        if (json['departmentAssignments'] is List && (json['departmentAssignments'] as List).isNotEmpty) {
          final first = (json['departmentAssignments'] as List)[0];
          if (first is Map && first['department'] != null && first['department'] is Map) {
            return DepartmentMiniInfo.fromJson(Map<String, dynamic>.from(first['department'] as Map));
          }
        }
        return null;
      }(),
      team: () {
        if (json['team'] != null && json['team'] is Map) {
          return TeamMiniInfo.fromJson(Map<String, dynamic>.from(json['team'] as Map));
        }
        if (json['departmentAssignments'] is List && (json['departmentAssignments'] as List).isNotEmpty) {
          final first = (json['departmentAssignments'] as List)[0];
          if (first is Map && first['team'] != null && first['team'] is Map) {
            return TeamMiniInfo.fromJson(Map<String, dynamic>.from(first['team'] as Map));
          }
        }
        return null;
      }(),
      departmentRole: () {
        if (json['departmentRole'] != null) {
          return json['departmentRole'].toString();
        }
        if (json['departmentAssignments'] is List && (json['departmentAssignments'] as List).isNotEmpty) {
          final first = (json['departmentAssignments'] as List)[0];
          if (first is Map && first['role'] != null) {
            return first['role'].toString();
          }
        }
        return null;
      }(),
      joiningDate: _parseDate(json['joiningDate']) ?? DateTime.now(),
      probationEndDate: _parseDate(json['probationEndDate']),
      confirmationDate: _parseDate(json['confirmationDate']),
      noticePeriodDays: json['noticePeriodDays'] is num ? (json['noticePeriodDays'] as num).toInt() : 30,
      resignationDate: _parseDate(json['resignationDate']),
      noticePeriodEndDate: _parseDate(json['noticePeriodEndDate']),
      relievingDate: _parseDate(json['relievingDate']),
      terminationDate: _parseDate(json['terminationDate']),
      terminationReason: json['terminationReason']?.toString(),
      panNumber: json['panNumber']?.toString(),
      aadhaarNumber: json['aadhaarNumber']?.toString(),
      uanNumber: json['uanNumber']?.toString(),
      pfNumber: json['pfNumber']?.toString(),
      esiNumber: json['esiNumber']?.toString(),
      passportNumber: json['passportNumber']?.toString(),
      taxRegime: json['taxRegime']?.toString() ?? 'NEW',
      bankAccountHolderName: json['bankAccountHolderName']?.toString(),
      bankAccountNumber: json['bankAccountNumber']?.toString(),
      bankName: json['bankName']?.toString(),
      bankIfscCode: json['bankIfscCode']?.toString(),
      bankBranchName: json['bankBranchName']?.toString(),
      documents: json['documents'],
      currentSalary: parsedSalary,
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      'employeeCode': employeeCode,
      'firstName': firstName,
      if (middleName != null) 'middleName': middleName,
      if (lastName != null) 'lastName': lastName,
      if (displayName != null) 'displayName': displayName,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String().split('T')[0],
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      if (workEmail != null) 'workEmail': workEmail,
      if (personalEmail != null) 'personalEmail': personalEmail,
      if (workPhone != null) 'workPhone': workPhone,
      if (personalPhone != null) 'personalPhone': personalPhone,
      if (emergencyContactName != null) 'emergencyContactName': emergencyContactName,
      if (emergencyContactRelationship != null) 'emergencyContactRelationship': emergencyContactRelationship,
      if (emergencyContactPhone != null) 'emergencyContactPhone': emergencyContactPhone,
      if (currentAddress != null) 'currentAddress': currentAddress,
      if (currentCity != null) 'currentCity': currentCity,
      if (currentState != null) 'currentState': currentState,
      'currentCountry': currentCountry,
      if (currentPincode != null) 'currentPincode': currentPincode,
      if (permanentAddress != null) 'permanentAddress': permanentAddress,
      if (permanentCity != null) 'permanentCity': permanentCity,
      if (permanentState != null) 'permanentState': permanentState,
      'permanentCountry': permanentCountry,
      if (permanentPincode != null) 'permanentPincode': permanentPincode,
      'employmentType': employmentType,
      'employmentStatus': employmentStatus,
      'designation': designation,
      if (workLocation != null) 'workLocation': workLocation,
      if (reportingManagerId != null) 'reportingManagerId': reportingManagerId,
      if (department != null) 'departmentId': department!.id,
      if (team != null) 'teamId': team!.id,
      if (departmentRole != null) 'departmentRole': departmentRole,
      'joiningDate': joiningDate.toIso8601String().split('T')[0],
      if (probationEndDate != null) 'probationEndDate': probationEndDate!.toIso8601String().split('T')[0],
      if (confirmationDate != null) 'confirmationDate': confirmationDate!.toIso8601String().split('T')[0],
      'noticePeriodDays': noticePeriodDays,
      if (panNumber != null) 'panNumber': panNumber,
      if (aadhaarNumber != null) 'aadhaarNumber': aadhaarNumber,
      if (uanNumber != null) 'uanNumber': uanNumber,
      if (pfNumber != null) 'pfNumber': pfNumber,
      if (esiNumber != null) 'esiNumber': esiNumber,
      if (passportNumber != null) 'passportNumber': passportNumber,
      'taxRegime': taxRegime,
      if (bankAccountHolderName != null) 'bankAccountHolderName': bankAccountHolderName,
      if (bankAccountNumber != null) 'bankAccountNumber': bankAccountNumber,
      if (bankName != null) 'bankName': bankName,
      if (bankIfscCode != null) 'bankIfscCode': bankIfscCode,
      if (bankBranchName != null) 'bankBranchName': bankBranchName,
    };
  }
}

/// Paginated Employees Response wrapper
class PaginatedEmployeesResponse {
  final List<HrmsEmployeeApiModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedEmployeesResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedEmployeesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final itemsList = data['items'] as List<dynamic>? ?? [];
    final meta = data['meta'] as Map<String, dynamic>? ?? {};

    return PaginatedEmployeesResponse(
      items: itemsList.map((e) => HrmsEmployeeApiModel.fromJson(e as Map<String, dynamic>)).toList(),
      total: meta['total'] is num ? (meta['total'] as num).toInt() : itemsList.length,
      page: meta['page'] is num ? (meta['page'] as num).toInt() : 1,
      limit: meta['limit'] is num ? (meta['limit'] as num).toInt() : 20,
      totalPages: meta['totalPages'] is num ? (meta['totalPages'] as num).toInt() : 1,
    );
  }
}
