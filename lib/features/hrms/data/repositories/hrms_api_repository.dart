import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints/hrms_endpoints.dart';
import '../models/hrms_employee_api_model.dart';
import '../models/hrms_salary_api_model.dart';
import '../models/hrms_department_api_model.dart';
import '../models/hrms_team_api_model.dart';

class HrmsApiRepository {
  final Dio _dio;

  HrmsApiRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  // ==========================================
  // EMPLOYEE MANAGEMENT APIS
  // ==========================================

  /// Get paginated employees list with search & filters
  Future<PaginatedEmployeesResponse> getEmployees({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? employmentType,
    String? reportingManagerId,
    String? departmentId,
    String? teamId,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }
      if (employmentType != null && employmentType.isNotEmpty && employmentType != 'all') {
        queryParams['employmentType'] = employmentType;
      }
      if (reportingManagerId != null && reportingManagerId.isNotEmpty) {
        queryParams['reportingManagerId'] = reportingManagerId;
      }
      if (departmentId != null && departmentId.isNotEmpty) {
        queryParams['departmentId'] = departmentId;
      }
      if (teamId != null && teamId.isNotEmpty) {
        queryParams['teamId'] = teamId;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }
      if (sortOrder != null && sortOrder.isNotEmpty) {
        queryParams['sortOrder'] = sortOrder;
      }

      final response = await _dio.get(
        HrmsEndpoints.employees,
        queryParameters: queryParams,
      );

      return PaginatedEmployeesResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get single employee details by ID (including current salary and subordinates)
  Future<HrmsEmployeeApiModel> getEmployeeById(String id) async {
    try {
      final response = await _dio.get(HrmsEndpoints.employeeById(id));
      final data = response.data['data'] as Map<String, dynamic>;
      return HrmsEmployeeApiModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get organization hierarchy / reporting tree
  Future<List<dynamic>> getEmployeeHierarchy({String? rootEmployeeId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (rootEmployeeId != null && rootEmployeeId.isNotEmpty) {
        queryParams['rootEmployeeId'] = rootEmployeeId;
      }

      final response = await _dio.get(
        HrmsEndpoints.employeeHierarchy,
        queryParameters: queryParams,
      );

      return response.data['data'] as List<dynamic>? ?? [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Create a new employee with optional avatar multipart upload
  Future<HrmsEmployeeApiModel> createEmployee(
    Map<String, dynamic> data, {
    List<int>? avatarBytes,
    String? avatarFileName,
  }) async {
    try {
      dynamic payload = data;
      if (avatarBytes != null && avatarBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['avatar'] = MultipartFile.fromBytes(
          avatarBytes,
          filename: avatarFileName ?? 'employee_avatar.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.post(HrmsEndpoints.employees, data: payload);
      return HrmsEmployeeApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update employee details with optional avatar upload
  Future<HrmsEmployeeApiModel> updateEmployee(
    String id,
    Map<String, dynamic> data, {
    List<int>? avatarBytes,
    String? avatarFileName,
  }) async {
    try {
      dynamic payload = data;
      if (avatarBytes != null && avatarBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['avatar'] = MultipartFile.fromBytes(
          avatarBytes,
          filename: avatarFileName ?? 'employee_avatar.jpg',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.patch(HrmsEndpoints.employeeById(id), data: payload);
      return HrmsEmployeeApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Soft delete an employee
  Future<void> deleteEmployee(String id) async {
    try {
      await _dio.delete(HrmsEndpoints.employeeById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ==========================================
  // SALARY & REVISION MANAGEMENT APIS
  // ==========================================

  /// Record initial salary or create a salary revision (automatically closes the previous period)
  Future<HrmsSalaryApiModel> createSalaryRevision(
    String employeeId,
    Map<String, dynamic> data, {
    List<int>? documentBytes,
    String? documentFileName,
  }) async {
    try {
      dynamic payload = data;
      if (documentBytes != null && documentBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['document'] = MultipartFile.fromBytes(
          documentBytes,
          filename: documentFileName ?? 'increment_letter.pdf',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.post(
        HrmsEndpoints.employeeSalaries(employeeId),
        data: payload,
      );

      return HrmsSalaryApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get complete historical timeline of salary revisions for an employee
  Future<List<HrmsSalaryApiModel>> getSalaryHistory(String employeeId) async {
    try {
      final response = await _dio.get(HrmsEndpoints.employeeSalaryHistory(employeeId));
      final list = response.data['data'] as List<dynamic>? ?? [];
      return list.map((e) => HrmsSalaryApiModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get active current salary package for an employee
  Future<HrmsSalaryApiModel> getCurrentSalary(String employeeId) async {
    try {
      final response = await _dio.get(HrmsEndpoints.employeeCurrentSalary(employeeId));
      return HrmsSalaryApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get specific salary record by ID
  Future<HrmsSalaryApiModel> getSalaryById(String id) async {
    try {
      final response = await _dio.get(HrmsEndpoints.salaryById(id));
      return HrmsSalaryApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update an existing salary structure record
  Future<HrmsSalaryApiModel> updateSalary(
    String employeeId,
    String salaryId,
    Map<String, dynamic> data, {
    List<int>? documentBytes,
    String? documentFileName,
  }) async {
    try {
      dynamic payload = data;
      if (documentBytes != null && documentBytes.isNotEmpty) {
        final map = Map<String, dynamic>.from(data);
        map['document'] = MultipartFile.fromBytes(
          documentBytes,
          filename: documentFileName ?? 'increment_letter.pdf',
        );
        payload = FormData.fromMap(map);
      }

      final response = await _dio.patch(
        HrmsEndpoints.updateSalary(employeeId, salaryId),
        data: payload,
      );

      return HrmsSalaryApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Delete / archive a salary record
  Future<void> deleteSalary(String id) async {
    try {
      await _dio.delete(HrmsEndpoints.salaryById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ==========================================
  // DEPARTMENTS MANAGEMENT APIS
  // ==========================================

  /// Get paginated departments list with search & status filters
  Future<PaginatedDepartmentsResponse> getDepartments({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }
      if (sortOrder != null && sortOrder.isNotEmpty) {
        queryParams['sortOrder'] = sortOrder;
      }

      final response = await _dio.get(
        HrmsEndpoints.departments,
        queryParameters: queryParams,
      );

      return PaginatedDepartmentsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get department by ID
  Future<HrmsDepartmentApiModel> getDepartmentById(String id) async {
    try {
      final response = await _dio.get(HrmsEndpoints.departmentById(id));
      final data = response.data['data'] as Map<String, dynamic>;
      return HrmsDepartmentApiModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Create a new department
  Future<HrmsDepartmentApiModel> createDepartment(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(HrmsEndpoints.departments, data: data);
      final resData = response.data['data'] as Map<String, dynamic>;
      return HrmsDepartmentApiModel.fromJson(resData);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update department details
  Future<HrmsDepartmentApiModel> updateDepartment(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(HrmsEndpoints.departmentById(id), data: data);
      final resData = response.data['data'] as Map<String, dynamic>;
      return HrmsDepartmentApiModel.fromJson(resData);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Soft delete department
  Future<void> deleteDepartment(String id) async {
    try {
      await _dio.delete(HrmsEndpoints.departmentById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get all members assigned to a department
  Future<List<HrmsDepartmentMemberApiModel>> getDepartmentMembers(String departmentId) async {
    try {
      final response = await _dio.get(HrmsEndpoints.departmentMembers(departmentId));
      final list = response.data['data'] as List<dynamic>? ?? [];
      return list.map((e) => HrmsDepartmentMemberApiModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // ==========================================
  // TEAMS MANAGEMENT APIS
  // ==========================================

  /// Get paginated teams list across organization or filtered by department
  Future<PaginatedTeamsResponse> getTeams({
    int page = 1,
    int limit = 20,
    String? departmentId,
    String? search,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (departmentId != null && departmentId.isNotEmpty) {
        queryParams['departmentId'] = departmentId;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }
      if (sortOrder != null && sortOrder.isNotEmpty) {
        queryParams['sortOrder'] = sortOrder;
      }

      final response = await _dio.get(
        HrmsEndpoints.teams,
        queryParameters: queryParams,
      );

      return PaginatedTeamsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get teams belonging to a specific department
  Future<List<HrmsTeamApiModel>> getDepartmentTeams(String departmentId) async {
    try {
      final response = await _dio.get(HrmsEndpoints.departmentTeams(departmentId));
      final list = response.data['data'] as List<dynamic>? ?? [];
      return list.map((e) => HrmsTeamApiModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get team by ID
  Future<HrmsTeamApiModel> getTeamById(String id) async {
    try {
      final response = await _dio.get(HrmsEndpoints.teamById(id));
      final data = response.data['data'] as Map<String, dynamic>;
      return HrmsTeamApiModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Create a new team under a department
  Future<HrmsTeamApiModel> createTeam({
    required String departmentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(
        HrmsEndpoints.departmentTeams(departmentId),
        data: data,
      );
      final resData = response.data['data'] as Map<String, dynamic>;
      return HrmsTeamApiModel.fromJson(resData);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Update team details
  Future<HrmsTeamApiModel> updateTeam(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(HrmsEndpoints.teamById(id), data: data);
      final resData = response.data['data'] as Map<String, dynamic>;
      return HrmsTeamApiModel.fromJson(resData);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Soft delete team
  Future<void> deleteTeam(String id) async {
    try {
      await _dio.delete(HrmsEndpoints.teamById(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Get members assigned to a team
  Future<List<HrmsTeamMemberApiModel>> getTeamMembers(String teamId) async {
    try {
      final response = await _dio.get(HrmsEndpoints.teamMembers(teamId));
      final list = response.data['data'] as List<dynamic>? ?? [];
      return list.map((e) => HrmsTeamMemberApiModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}

final hrmsApiRepository = HrmsApiRepository();
