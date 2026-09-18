import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../../core/utils/query_cache_utils.dart';
import '../../../../core/utils/toast_service.dart';
import '../../data/models/hrms_employee_api_model.dart';
import '../../data/models/hrms_salary_api_model.dart';
import '../../data/models/hrms_department_api_model.dart';
import '../../data/models/hrms_team_api_model.dart';
import '../../data/repositories/hrms_api_repository.dart';

abstract class HrmsQueryKeys {
  static const String employeesList = 'hrms_employees_list';
  static const String employeeHierarchy = 'hrms_employee_hierarchy';

  static String employeeDetail(String id) => 'hrms_employee_detail_$id';
  static String salaryHistory(String employeeId) => 'hrms_salary_history_$employeeId';
  static String currentSalary(String employeeId) => 'hrms_current_salary_$employeeId';
  static String salaryDetail(String id) => 'hrms_salary_detail_$id';

  // Departments & Teams
  static const String departmentsList = 'hrms_departments_list';
  static String departmentDetail(String id) => 'hrms_department_detail_$id';
  static String departmentMembers(String id) => 'hrms_department_members_$id';

  static const String teamsList = 'hrms_teams_list';
  static String departmentTeams(String deptId) => 'hrms_department_teams_$deptId';
  static String teamDetail(String id) => 'hrms_team_detail_$id';
  static String teamMembers(String id) => 'hrms_team_members_$id';
}

class HrmsQueries {
  final HrmsApiRepository _repository;

  HrmsQueries({HrmsApiRepository? repository})
      : _repository = repository ?? hrmsApiRepository;

  // ==========================================
  // CACHE INVALIDATIONS
  // ==========================================

  void invalidateEmployeesCache() {
    QueryCacheUtils.invalidateAndRefetch(HrmsQueryKeys.employeesList);
    QueryCacheUtils.invalidateAndRefetch(HrmsQueryKeys.employeeHierarchy);
  }

  void invalidateEmployeeDetailCache(String id) {
    QueryCacheUtils.invalidateKey(HrmsQueryKeys.employeeDetail(id));
  }

  void invalidateSalaryCache(String employeeId) {
    QueryCacheUtils.invalidateAndRefetch(HrmsQueryKeys.salaryHistory(employeeId));
    QueryCacheUtils.invalidateAndRefetch(HrmsQueryKeys.currentSalary(employeeId));
    invalidateEmployeeDetailCache(employeeId);
    invalidateEmployeesCache();
  }

  void invalidateDepartmentsCache() {
    QueryCacheUtils.invalidateAndRefetch(HrmsQueryKeys.departmentsList);
    invalidateEmployeesCache();
  }

  void invalidateTeamsCache() {
    QueryCacheUtils.invalidateAndRefetch(HrmsQueryKeys.teamsList);
    invalidateEmployeesCache();
  }

  // ==========================================
  // QUERIES
  // ==========================================

  /// Query to fetch paginated employees list with search and filters
  Query<PaginatedEmployeesResponse> getEmployeesQuery({
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
  }) {
    final queryKey =
        '${HrmsQueryKeys.employeesList}_${page}_${search ?? ''}_${status ?? ''}_${employmentType ?? ''}_${reportingManagerId ?? ''}_${departmentId ?? ''}_${teamId ?? ''}';

    return Query<PaginatedEmployeesResponse>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getEmployees(
        page: page,
        limit: limit,
        search: search,
        status: status,
        employmentType: employmentType,
        reportingManagerId: reportingManagerId,
        departmentId: departmentId,
        teamId: teamId,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );
  }

  /// Query to fetch single employee detailed profile
  Query<HrmsEmployeeApiModel> getEmployeeDetailQuery(String id) {
    return Query<HrmsEmployeeApiModel>(
      key: HrmsQueryKeys.employeeDetail(id),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getEmployeeById(id),
    );
  }

  /// Query to fetch organizational hierarchy / reporting tree
  Query<List<dynamic>> getEmployeeHierarchyQuery({String? rootEmployeeId}) {
    final key = '${HrmsQueryKeys.employeeHierarchy}_${rootEmployeeId ?? 'root'}';

    return Query<List<dynamic>>(
      key: key,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 10),
        cacheDuration: const Duration(minutes: 10),
      ),
      queryFn: () => _repository.getEmployeeHierarchy(rootEmployeeId: rootEmployeeId),
    );
  }

  /// Query to fetch chronological salary revision history for an employee
  Query<List<HrmsSalaryApiModel>> getSalaryHistoryQuery(String employeeId) {
    return Query<List<HrmsSalaryApiModel>>(
      key: HrmsQueryKeys.salaryHistory(employeeId),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getSalaryHistory(employeeId),
    );
  }

  /// Query to fetch active current salary package for an employee
  Query<HrmsSalaryApiModel> getCurrentSalaryQuery(String employeeId) {
    return Query<HrmsSalaryApiModel>(
      key: HrmsQueryKeys.currentSalary(employeeId),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getCurrentSalary(employeeId),
    );
  }

  // ==========================================
  // MUTATIONS: EMPLOYEE
  // ==========================================

  /// Mutation: Create employee with optional avatar upload
  Mutation<HrmsEmployeeApiModel, ({Map<String, dynamic> data, List<int>? avatarBytes, String? avatarFileName})>
      getCreateEmployeeMutation({
    void Function(HrmsEmployeeApiModel employee)? onSuccess,
  }) {
    return Mutation<HrmsEmployeeApiModel, ({Map<String, dynamic> data, List<int>? avatarBytes, String? avatarFileName})>(
      mutationFn: (args) => _repository.createEmployee(
        args.data,
        avatarBytes: args.avatarBytes,
        avatarFileName: args.avatarFileName,
      ),
      onSuccess: (emp, _) {
        invalidateEmployeesCache();
        ToastService.showSuccess('Employee ${emp.fullName} (${emp.employeeCode}) created successfully.');
        if (onSuccess != null) onSuccess(emp);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update employee profile with optional avatar upload
  Mutation<HrmsEmployeeApiModel, ({String id, Map<String, dynamic> data, List<int>? avatarBytes, String? avatarFileName})>
      getUpdateEmployeeMutation({
    void Function(HrmsEmployeeApiModel employee)? onSuccess,
  }) {
    return Mutation<HrmsEmployeeApiModel, ({String id, Map<String, dynamic> data, List<int>? avatarBytes, String? avatarFileName})>(
      mutationFn: (args) => _repository.updateEmployee(
        args.id,
        args.data,
        avatarBytes: args.avatarBytes,
        avatarFileName: args.avatarFileName,
      ),
      onSuccess: (emp, args) {
        invalidateEmployeesCache();
        invalidateEmployeeDetailCache(args.id);
        ToastService.showSuccess('Employee ${emp.fullName} updated successfully.');
        if (onSuccess != null) onSuccess(emp);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Soft-delete employee
  Mutation<void, String> getDeleteEmployeeMutation({
    void Function(String id)? onSuccess,
  }) {
    return Mutation<void, String>(
      mutationFn: (id) => _repository.deleteEmployee(id),
      onSuccess: (_, id) {
        invalidateEmployeesCache();
        invalidateEmployeeDetailCache(id);
        ToastService.showSuccess('Employee removed successfully.');
        if (onSuccess != null) onSuccess(id);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  // ==========================================
  // MUTATIONS: SALARY & REVISIONS
  // ==========================================

  /// Mutation: Record initial salary or create a salary revision (closes previous active period)
  Mutation<HrmsSalaryApiModel, ({String employeeId, Map<String, dynamic> data, List<int>? documentBytes, String? documentFileName})>
      getCreateSalaryRevisionMutation({
    void Function(HrmsSalaryApiModel salary)? onSuccess,
  }) {
    return Mutation<HrmsSalaryApiModel, ({String employeeId, Map<String, dynamic> data, List<int>? documentBytes, String? documentFileName})>(
      mutationFn: (args) => _repository.createSalaryRevision(
        args.employeeId,
        args.data,
        documentBytes: args.documentBytes,
        documentFileName: args.documentFileName,
      ),
      onSuccess: (salary, args) {
        invalidateSalaryCache(args.employeeId);
        ToastService.showSuccess('Salary revision recorded successfully.');
        if (onSuccess != null) onSuccess(salary);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update a salary structure record
  Mutation<HrmsSalaryApiModel, ({String employeeId, String salaryId, Map<String, dynamic> data, List<int>? documentBytes, String? documentFileName})>
      getUpdateSalaryMutation({
    void Function(HrmsSalaryApiModel salary)? onSuccess,
  }) {
    return Mutation<HrmsSalaryApiModel, ({String employeeId, String salaryId, Map<String, dynamic> data, List<int>? documentBytes, String? documentFileName})>(
      mutationFn: (args) => _repository.updateSalary(
        args.employeeId,
        args.salaryId,
        args.data,
        documentBytes: args.documentBytes,
        documentFileName: args.documentFileName,
      ),
      onSuccess: (salary, args) {
        invalidateSalaryCache(args.employeeId);
        ToastService.showSuccess('Salary structure updated successfully.');
        if (onSuccess != null) onSuccess(salary);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Delete / archive salary structure record
  Mutation<void, ({String employeeId, String salaryId})> getDeleteSalaryMutation({
    void Function(String salaryId)? onSuccess,
  }) {
    return Mutation<void, ({String employeeId, String salaryId})>(
      mutationFn: (args) => _repository.deleteSalary(args.salaryId),
      onSuccess: (_, args) {
        invalidateSalaryCache(args.employeeId);
        ToastService.showSuccess('Salary record archived.');
        if (onSuccess != null) onSuccess(args.salaryId);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  // ==========================================
  // QUERIES: DEPARTMENTS & TEAMS
  // ==========================================

  /// Query to fetch paginated departments list
  Query<PaginatedDepartmentsResponse> getDepartmentsQuery({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) {
    final key = '${HrmsQueryKeys.departmentsList}_${page}_${search ?? ''}_${status ?? ''}';

    return Query<PaginatedDepartmentsResponse>(
      key: key,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getDepartments(
        page: page,
        limit: limit,
        search: search,
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );
  }

  /// Query to fetch single department details
  Query<HrmsDepartmentApiModel> getDepartmentDetailQuery(String id) {
    return Query<HrmsDepartmentApiModel>(
      key: HrmsQueryKeys.departmentDetail(id),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getDepartmentById(id),
    );
  }

  /// Query to fetch members of a department
  Query<List<HrmsDepartmentMemberApiModel>> getDepartmentMembersQuery(String departmentId) {
    return Query<List<HrmsDepartmentMemberApiModel>>(
      key: HrmsQueryKeys.departmentMembers(departmentId),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getDepartmentMembers(departmentId),
    );
  }

  /// Query to fetch paginated teams list across organization
  Query<PaginatedTeamsResponse> getTeamsQuery({
    int page = 1,
    int limit = 20,
    String? departmentId,
    String? search,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) {
    final key = '${HrmsQueryKeys.teamsList}_${page}_${departmentId ?? ''}_${search ?? ''}_${status ?? ''}';

    return Query<PaginatedTeamsResponse>(
      key: key,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getTeams(
        page: page,
        limit: limit,
        departmentId: departmentId,
        search: search,
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );
  }

  /// Query to fetch teams under a specific department
  Query<List<HrmsTeamApiModel>> getDepartmentTeamsQuery(String departmentId) {
    return Query<List<HrmsTeamApiModel>>(
      key: HrmsQueryKeys.departmentTeams(departmentId),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getDepartmentTeams(departmentId),
    );
  }

  /// Query to fetch single team detail
  Query<HrmsTeamApiModel> getTeamDetailQuery(String id) {
    return Query<HrmsTeamApiModel>(
      key: HrmsQueryKeys.teamDetail(id),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getTeamById(id),
    );
  }

  /// Query to fetch members of a team
  Query<List<HrmsTeamMemberApiModel>> getTeamMembersQuery(String teamId) {
    return Query<List<HrmsTeamMemberApiModel>>(
      key: HrmsQueryKeys.teamMembers(teamId),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 5),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _repository.getTeamMembers(teamId),
    );
  }

  // ==========================================
  // MUTATIONS: DEPARTMENTS & TEAMS
  // ==========================================

  /// Mutation: Create department
  Mutation<HrmsDepartmentApiModel, Map<String, dynamic>> getCreateDepartmentMutation({
    void Function(HrmsDepartmentApiModel department)? onSuccess,
  }) {
    return Mutation<HrmsDepartmentApiModel, Map<String, dynamic>>(
      mutationFn: (data) => _repository.createDepartment(data),
      onSuccess: (dept, _) {
        invalidateDepartmentsCache();
        ToastService.showSuccess('Department "${dept.name}" created successfully.');
        if (onSuccess != null) onSuccess(dept);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update department
  Mutation<HrmsDepartmentApiModel, ({String id, Map<String, dynamic> data})> getUpdateDepartmentMutation({
    void Function(HrmsDepartmentApiModel department)? onSuccess,
  }) {
    return Mutation<HrmsDepartmentApiModel, ({String id, Map<String, dynamic> data})>(
      mutationFn: (args) => _repository.updateDepartment(args.id, args.data),
      onSuccess: (dept, _) {
        invalidateDepartmentsCache();
        ToastService.showSuccess('Department "${dept.name}" updated successfully.');
        if (onSuccess != null) onSuccess(dept);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Soft delete department
  Mutation<void, String> getDeleteDepartmentMutation({
    void Function(String id)? onSuccess,
  }) {
    return Mutation<void, String>(
      mutationFn: (id) => _repository.deleteDepartment(id),
      onSuccess: (_, id) {
        invalidateDepartmentsCache();
        ToastService.showSuccess('Department removed successfully.');
        if (onSuccess != null) onSuccess(id);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Create team
  Mutation<HrmsTeamApiModel, ({String departmentId, Map<String, dynamic> data})> getCreateTeamMutation({
    void Function(HrmsTeamApiModel team)? onSuccess,
  }) {
    return Mutation<HrmsTeamApiModel, ({String departmentId, Map<String, dynamic> data})>(
      mutationFn: (args) => _repository.createTeam(departmentId: args.departmentId, data: args.data),
      onSuccess: (team, _) {
        invalidateTeamsCache();
        invalidateDepartmentsCache();
        ToastService.showSuccess('Team "${team.name}" created successfully.');
        if (onSuccess != null) onSuccess(team);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update team
  Mutation<HrmsTeamApiModel, ({String id, Map<String, dynamic> data})> getUpdateTeamMutation({
    void Function(HrmsTeamApiModel team)? onSuccess,
  }) {
    return Mutation<HrmsTeamApiModel, ({String id, Map<String, dynamic> data})>(
      mutationFn: (args) => _repository.updateTeam(args.id, args.data),
      onSuccess: (team, _) {
        invalidateTeamsCache();
        ToastService.showSuccess('Team "${team.name}" updated successfully.');
        if (onSuccess != null) onSuccess(team);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Soft delete team
  Mutation<void, String> getDeleteTeamMutation({
    void Function(String id)? onSuccess,
  }) {
    return Mutation<void, String>(
      mutationFn: (id) => _repository.deleteTeam(id),
      onSuccess: (_, id) {
        invalidateTeamsCache();
        invalidateDepartmentsCache();
        ToastService.showSuccess('Team removed successfully.');
        if (onSuccess != null) onSuccess(id);
      },
      onError: (arg, error, fallback) {
        ToastService.showError(error);
      },
    );
  }
}

final hrmsQueries = HrmsQueries();
