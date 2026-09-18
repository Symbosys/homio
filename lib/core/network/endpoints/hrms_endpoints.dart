/// HRMS Module Endpoints (Employees, Salary Tracking, Departments & Teams)
abstract class HrmsEndpoints {
  // Employees Management
  static const String employees = '/hrms/employees';
  static const String employeeHierarchy = '/hrms/employees/hierarchy';
  static String employeeById(String id) => '/hrms/employees/$id';

  // Salary Structure & Revision Tracking
  static String employeeSalaries(String employeeId) => '/hrms/salaries/employee/$employeeId';
  static String employeeSalaryHistory(String employeeId) => '/hrms/salaries/employee/$employeeId/history';
  static String employeeCurrentSalary(String employeeId) => '/hrms/salaries/employee/$employeeId/current';
  static String salaryById(String id) => '/hrms/salaries/$id';
  static String updateSalary(String employeeId, String salaryId) => '/hrms/salaries/employee/$employeeId/$salaryId';

  // Departments & Sub-Teams
  static const String departments = '/hrms/departments';
  static String departmentById(String id) => '/hrms/departments/$id';
  static String departmentMembers(String id) => '/hrms/departments/$id/members';
  static String departmentTeams(String departmentId) => '/hrms/departments/$departmentId/teams';

  // Teams Management
  static const String teams = '/hrms/teams';
  static String teamById(String id) => '/hrms/teams/$id';
  static String teamMembers(String id) => '/hrms/teams/$id/members';
}
