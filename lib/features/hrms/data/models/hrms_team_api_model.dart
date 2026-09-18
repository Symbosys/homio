import 'hrms_employee_api_model.dart';

/// Complete Team API Model
class HrmsTeamApiModel {
  final String id;
  final String organizationId;
  final String departmentId;
  final String name;
  final String code;
  final String? description;
  final String status;
  final String? teamLeadId;
  final EmployeeMiniInfo? teamLead;
  final DepartmentMiniInfo? department;
  final int employeesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HrmsTeamApiModel({
    required this.id,
    required this.organizationId,
    required this.departmentId,
    required this.name,
    required this.code,
    this.description,
    this.status = 'ACTIVE',
    this.teamLeadId,
    this.teamLead,
    this.department,
    this.employeesCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  String get leadEmployeeName => teamLead?.fullName ?? 'No Lead Assigned';
  String get departmentName => department?.name ?? 'Department';

  factory HrmsTeamApiModel.fromJson(Map<String, dynamic> json) {
    final countData = json['_count'] as Map<String, dynamic>?;

    return HrmsTeamApiModel(
      id: json['id']?.toString() ?? '',
      organizationId: json['organizationId']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      teamLeadId: json['teamLeadId']?.toString(),
      teamLead: json['teamLead'] is Map<String, dynamic>
          ? EmployeeMiniInfo.fromJson(json['teamLead'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map<String, dynamic>
          ? DepartmentMiniInfo.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      employeesCount: countData?['employeeAssignments'] is num
          ? (countData!['employeeAssignments'] as num).toInt()
          : 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (departmentId.isNotEmpty) 'departmentId': departmentId,
        'name': name,
        'code': code,
        if (description != null) 'description': description,
        if (teamLeadId != null) 'teamLeadId': teamLeadId,
        'status': status,
      };
}

/// Team Member Representation
class HrmsTeamMemberApiModel {
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
  final String? assignmentId;

  const HrmsTeamMemberApiModel({
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

  factory HrmsTeamMemberApiModel.fromJson(Map<String, dynamic> json) {
    return HrmsTeamMemberApiModel(
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
      assignmentId: json['assignmentId']?.toString(),
    );
  }
}

/// Paginated Teams Response Wrapper
class PaginatedTeamsResponse {
  final List<HrmsTeamApiModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedTeamsResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedTeamsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final itemsList = (data['teams'] ?? data['items']) as List<dynamic>? ?? [];
    final pagination = (data['pagination'] ?? data['meta']) as Map<String, dynamic>? ?? {};

    return PaginatedTeamsResponse(
      items: itemsList
          .map((e) => HrmsTeamApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: pagination['total'] is num ? (pagination['total'] as num).toInt() : itemsList.length,
      page: pagination['page'] is num ? (pagination['page'] as num).toInt() : 1,
      limit: pagination['limit'] is num ? (pagination['limit'] as num).toInt() : 20,
      totalPages: pagination['totalPages'] is num ? (pagination['totalPages'] as num).toInt() : 1,
    );
  }
}
