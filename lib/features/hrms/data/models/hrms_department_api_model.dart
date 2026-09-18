import 'hrms_employee_api_model.dart';

/// Mini representation of a sub-team within a department
class DepartmentSubTeamInfo {
  final String id;
  final String name;
  final String code;
  final String status;
  final String? description;
  final EmployeeMiniInfo? teamLead;
  final int employeesCount;

  const DepartmentSubTeamInfo({
    required this.id,
    required this.name,
    required this.code,
    this.status = 'ACTIVE',
    this.description,
    this.teamLead,
    this.employeesCount = 0,
  });

  factory DepartmentSubTeamInfo.fromJson(Map<String, dynamic> json) {
    final countData = json['_count'] as Map<String, dynamic>?;
    return DepartmentSubTeamInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      status: json['status']?.toString() ?? 'ACTIVE',
      description: json['description']?.toString(),
      teamLead: json['teamLead'] is Map<String, dynamic>
          ? EmployeeMiniInfo.fromJson(json['teamLead'] as Map<String, dynamic>)
          : null,
      employeesCount: countData?['employeeAssignments'] is num
          ? (countData!['employeeAssignments'] as num).toInt()
          : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'status': status,
        if (description != null) 'description': description,
      };
}

/// Complete Department API Model
class HrmsDepartmentApiModel {
  final String id;
  final String organizationId;
  final String name;
  final String code;
  final String? description;
  final String status;
  final String? headOfDepartmentId;
  final EmployeeMiniInfo? headOfDepartment;
  final String? costCenterCode;
  final double? budget;
  final int teamsCount;
  final int employeesCount;
  final List<DepartmentSubTeamInfo> teams;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HrmsDepartmentApiModel({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.code,
    this.description,
    this.status = 'ACTIVE',
    this.headOfDepartmentId,
    this.headOfDepartment,
    this.costCenterCode,
    this.budget,
    this.teamsCount = 0,
    this.employeesCount = 0,
    this.teams = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  String get headEmployeeName => headOfDepartment?.fullName ?? 'Unassigned';

  factory HrmsDepartmentApiModel.fromJson(Map<String, dynamic> json) {
    final countData = json['_count'] as Map<String, dynamic>?;

    final teamsRaw = json['teams'] as List<dynamic>? ?? [];
    final parsedTeams = teamsRaw
        .map((t) => DepartmentSubTeamInfo.fromJson(t as Map<String, dynamic>))
        .toList();

    return HrmsDepartmentApiModel(
      id: json['id']?.toString() ?? '',
      organizationId: json['organizationId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      headOfDepartmentId: json['headOfDepartmentId']?.toString(),
      headOfDepartment: json['headOfDepartment'] is Map<String, dynamic>
          ? EmployeeMiniInfo.fromJson(json['headOfDepartment'] as Map<String, dynamic>)
          : null,
      costCenterCode: json['costCenterCode']?.toString(),
      budget: json['budget'] != null ? double.tryParse(json['budget'].toString()) : null,
      teamsCount: countData?['teams'] is num
          ? (countData!['teams'] as num).toInt()
          : parsedTeams.length,
      employeesCount: countData?['employeeAssignments'] is num
          ? (countData!['employeeAssignments'] as num).toInt()
          : 0,
      teams: parsedTeams,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        if (description != null) 'description': description,
        if (headOfDepartmentId != null) 'headOfDepartmentId': headOfDepartmentId,
        if (costCenterCode != null) 'costCenterCode': costCenterCode,
        if (budget != null) 'budget': budget,
        'status': status,
      };
}

/// Department Member Representation
class HrmsDepartmentMemberApiModel {
  final String id;
  final String employeeCode;
  final String firstName;
  final String? lastName;
  final String designation;
  final String? avatarUrl;
  final String? workEmail;
  final String employmentStatus;
  final DateTime? joiningDate;
  final String role;
  final TeamMiniInfo? team;
  final String? assignmentId;

  const HrmsDepartmentMemberApiModel({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    this.lastName,
    required this.designation,
    this.avatarUrl,
    this.workEmail,
    this.employmentStatus = 'ACTIVE',
    this.joiningDate,
    required this.role,
    this.team,
    this.assignmentId,
  });

  String get fullName => '$firstName ${lastName ?? ""}'.trim();

  static String? _parseAvatarUrl(dynamic val) {
    if (val == null) return null;
    if (val is String) return val.isEmpty ? null : val;
    if (val is Map<String, dynamic>) {
      return val['url'] as String? ?? val['secureUrl'] as String?;
    }
    return null;
  }

  factory HrmsDepartmentMemberApiModel.fromJson(Map<String, dynamic> json) {
    return HrmsDepartmentMemberApiModel(
      id: json['id']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString(),
      designation: json['designation']?.toString() ?? '',
      avatarUrl: _parseAvatarUrl(json['avatarUrl']),
      workEmail: json['workEmail']?.toString(),
      employmentStatus: json['employmentStatus']?.toString() ?? 'ACTIVE',
      joiningDate: DateTime.tryParse(json['joiningDate']?.toString() ?? ''),
      role: json['role']?.toString() ?? 'MEMBER',
      team: json['team'] is Map<String, dynamic>
          ? TeamMiniInfo.fromJson(json['team'] as Map<String, dynamic>)
          : null,
      assignmentId: json['assignmentId']?.toString(),
    );
  }
}

/// Paginated Departments Response Wrapper
class PaginatedDepartmentsResponse {
  final List<HrmsDepartmentApiModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedDepartmentsResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedDepartmentsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final itemsList = (data['departments'] ?? data['items']) as List<dynamic>? ?? [];
    final pagination = (data['pagination'] ?? data['meta']) as Map<String, dynamic>? ?? {};

    return PaginatedDepartmentsResponse(
      items: itemsList
          .map((e) => HrmsDepartmentApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: pagination['total'] is num ? (pagination['total'] as num).toInt() : itemsList.length,
      page: pagination['page'] is num ? (pagination['page'] as num).toInt() : 1,
      limit: pagination['limit'] is num ? (pagination['limit'] as num).toInt() : 20,
      totalPages: pagination['totalPages'] is num ? (pagination['totalPages'] as num).toInt() : 1,
    );
  }
}
