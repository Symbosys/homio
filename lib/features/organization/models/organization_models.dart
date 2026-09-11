// Domain models for Homio CRM: Organization Module
// Central administrative layer for Department & Team structures, Employee Directory & Assignments,
// Roles, Granular Permissions Registry, and Data Access Scopes.

enum OrgStatus {
  active,
  inactive,
  archived;

  String get displayName {
    switch (this) {
      case OrgStatus.active:
        return 'Active';
      case OrgStatus.inactive:
        return 'Inactive';
      case OrgStatus.archived:
        return 'Archived';
    }
  }
}

enum DepartmentType {
  marketing,
  sales,
  design,
  execution,
  afterSales,
  finance,
  hr,
  operations;

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
      case DepartmentType.finance:
        return 'Finance & Accounts';
      case DepartmentType.hr:
        return 'Human Resources';
      case DepartmentType.operations:
        return 'Operations & Supply Chain';
    }
  }
}

enum HierarchyLevel {
  director,
  departmentHead,
  lead,
  manager,
  specialist,
  fieldLead,
  executive,
  junior,
  intern;

  String get displayName {
    switch (this) {
      case HierarchyLevel.director:
        return 'Director / CXO';
      case HierarchyLevel.departmentHead:
      case HierarchyLevel.lead:
        return 'Dept Head / Lead';
      case HierarchyLevel.manager:
        return 'Manager';
      case HierarchyLevel.specialist:
      case HierarchyLevel.fieldLead:
        return 'Field Lead / Specialist';
      case HierarchyLevel.executive:
        return 'Executive';
      case HierarchyLevel.junior:
        return 'Junior Associate';
      case HierarchyLevel.intern:
        return 'Intern';
    }
  }
}

enum AccessScopeLevel {
  ownRecords,
  assignedRecords,
  ownTeam,
  department,
  branch,
  region,
  businessUnit,
  organization,
  customScope;

  String get displayName {
    switch (this) {
      case AccessScopeLevel.ownRecords:
        return 'Own Records';
      case AccessScopeLevel.assignedRecords:
        return 'Assigned Records';
      case AccessScopeLevel.ownTeam:
        return 'Own Team';
      case AccessScopeLevel.department:
        return 'Department Scope';
      case AccessScopeLevel.branch:
        return 'Branch / Hub';
      case AccessScopeLevel.region:
        return 'Regional Scope';
      case AccessScopeLevel.businessUnit:
        return 'Business Unit';
      case AccessScopeLevel.organization:
        return 'Organization-Wide';
      case AccessScopeLevel.customScope:
        return 'Custom Boundary';
    }
  }

  String get description {
    switch (this) {
      case AccessScopeLevel.ownRecords:
        return 'User can only view and modify records they personally created.';
      case AccessScopeLevel.assignedRecords:
        return 'User can access records explicitly assigned to them as lead/owner.';
      case AccessScopeLevel.ownTeam:
        return 'User can view and operate on records within their immediate team.';
      case AccessScopeLevel.department:
        return 'User has visibility over all teams and projects in their department.';
      case AccessScopeLevel.branch:
        return 'User can access all operations within their specific city/branch hub.';
      case AccessScopeLevel.region:
        return 'Visibility spans multiple branches within a geographical zone.';
      case AccessScopeLevel.businessUnit:
        return 'Scope applies to the entire operational business unit.';
      case AccessScopeLevel.organization:
        return 'Global visibility across the entire enterprise (Executive / Admin).';
      case AccessScopeLevel.customScope:
        return 'Custom multi-rule matrix combining department, branch, and role filters.';
    }
  }
}

// Legacy AccessScope enum for backward compatibility
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

enum AccountStatus {
  active,
  invited,
  pendingActivation,
  suspended,
  deactivated;

  String get displayName {
    switch (this) {
      case AccountStatus.active:
        return 'Active';
      case AccountStatus.invited:
        return 'Invited';
      case AccountStatus.pendingActivation:
        return 'Pending Activation';
      case AccountStatus.suspended:
        return 'Suspended';
      case AccountStatus.deactivated:
        return 'Deactivated';
    }
  }
}

enum EmploymentStatus {
  fullTime,
  contract,
  partTime,
  probation;

  String get displayName {
    switch (this) {
      case EmploymentStatus.fullTime:
        return 'Full-Time';
      case EmploymentStatus.contract:
        return 'Contractor';
      case EmploymentStatus.partTime:
        return 'Part-Time';
      case EmploymentStatus.probation:
        return 'On Probation';
    }
  }
}

enum RoleType {
  system,
  custom;

  String get displayName {
    switch (this) {
      case RoleType.system:
        return 'System Role';
      case RoleType.custom:
        return 'Custom Role';
    }
  }
}

enum PermissionModule {
  crm,
  sales,
  quotation,
  projects,
  designs,
  finance,
  hrms,
  service,
  organization,
  systemAdmin;

  String get displayName {
    switch (this) {
      case PermissionModule.crm:
        return 'CRM & Leads';
      case PermissionModule.sales:
        return 'Sales & Deals';
      case PermissionModule.quotation:
        return 'Quotation & Estimation';
      case PermissionModule.projects:
        return 'Projects & Execution';
      case PermissionModule.designs:
        return 'Design Studio & DAM';
      case PermissionModule.finance:
        return 'Finance & Accounts';
      case PermissionModule.hrms:
        return 'HRMS & Field Ops';
      case PermissionModule.service:
        return 'After-Sales & Warranty';
      case PermissionModule.organization:
        return 'Organization Governance';
      case PermissionModule.systemAdmin:
        return 'System Administration';
    }
  }
}

enum PermissionAction {
  view,
  create,
  edit,
  delete,
  export,
  approve,
  assign,
  import;

  String get displayName {
    switch (this) {
      case PermissionAction.view:
        return 'View';
      case PermissionAction.create:
        return 'Create';
      case PermissionAction.edit:
        return 'Edit';
      case PermissionAction.delete:
        return 'Delete';
      case PermissionAction.export:
        return 'Export';
      case PermissionAction.approve:
        return 'Approve';
      case PermissionAction.assign:
        return 'Assign';
      case PermissionAction.import:
        return 'Import';
    }
  }
}

/// 1. Department Entity
class OrganizationDepartment {
  final String id;
  final String code;
  final String name;
  final DepartmentType type;
  final String? parentDepartmentId;
  final String? parentDepartmentName;
  final String headOfDepartment;
  final String headEmail;
  final String headPhone;
  final String? deputyHead;
  final String description;
  final int teamCount;
  final int employeeCount;
  final OrgStatus status;
  final String email;
  final String phone;
  final String locationBranch;
  final String costCenter;
  final double monthlyBudgetPool;
  final bool allowTeamCreation;
  final String defaultAccessScopeId;
  final List<String> coreFunctions;
  final DateTime createdDate;
  final DateTime lastUpdated;

  const OrganizationDepartment({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    this.parentDepartmentId,
    this.parentDepartmentName,
    required this.headOfDepartment,
    required this.headEmail,
    required this.headPhone,
    this.deputyHead,
    required this.description,
    required this.teamCount,
    required this.employeeCount,
    this.status = OrgStatus.active,
    required this.email,
    required this.phone,
    required this.locationBranch,
    required this.costCenter,
    required this.monthlyBudgetPool,
    this.allowTeamCreation = true,
    required this.defaultAccessScopeId,
    required this.coreFunctions,
    required this.createdDate,
    required this.lastUpdated,
  });

  OrganizationDepartment copyWith({
    String? id,
    String? code,
    String? name,
    DepartmentType? type,
    String? parentDepartmentId,
    String? parentDepartmentName,
    String? headOfDepartment,
    String? headEmail,
    String? headPhone,
    String? deputyHead,
    String? description,
    int? teamCount,
    int? employeeCount,
    OrgStatus? status,
    String? email,
    String? phone,
    String? locationBranch,
    String? costCenter,
    double? monthlyBudgetPool,
    bool? allowTeamCreation,
    String? defaultAccessScopeId,
    List<String>? coreFunctions,
    DateTime? createdDate,
    DateTime? lastUpdated,
  }) {
    return OrganizationDepartment(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      parentDepartmentId: parentDepartmentId ?? this.parentDepartmentId,
      parentDepartmentName: parentDepartmentName ?? this.parentDepartmentName,
      headOfDepartment: headOfDepartment ?? this.headOfDepartment,
      headEmail: headEmail ?? this.headEmail,
      headPhone: headPhone ?? this.headPhone,
      deputyHead: deputyHead ?? this.deputyHead,
      description: description ?? this.description,
      teamCount: teamCount ?? this.teamCount,
      employeeCount: employeeCount ?? this.employeeCount,
      status: status ?? this.status,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      locationBranch: locationBranch ?? this.locationBranch,
      costCenter: costCenter ?? this.costCenter,
      monthlyBudgetPool: monthlyBudgetPool ?? this.monthlyBudgetPool,
      allowTeamCreation: allowTeamCreation ?? this.allowTeamCreation,
      defaultAccessScopeId: defaultAccessScopeId ?? this.defaultAccessScopeId,
      coreFunctions: coreFunctions ?? this.coreFunctions,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Backward-compatible DepartmentEntity wrapper
typedef DepartmentEntity = OrganizationDepartment;

/// 2. Team Entity
class OrganizationTeam {
  final String id;
  final String code;
  final String name;
  final String departmentId;
  final String departmentName;
  final String? parentTeamId;
  final String teamLead;
  final String teamLeadEmail;
  final String manager;
  final String managerEmail;
  final int memberCount;
  final OrgStatus status;
  final String branch;
  final String teamType;
  final int maxTeamSize;
  final String defaultAccessScopeId;
  final String description;
  final DateTime createdDate;
  final DateTime lastUpdated;

  const OrganizationTeam({
    required this.id,
    required this.code,
    required this.name,
    required this.departmentId,
    required this.departmentName,
    this.parentTeamId,
    required this.teamLead,
    required this.teamLeadEmail,
    required this.manager,
    required this.managerEmail,
    required this.memberCount,
    this.status = OrgStatus.active,
    required this.branch,
    required this.teamType,
    this.maxTeamSize = 20,
    required this.defaultAccessScopeId,
    required this.description,
    required this.createdDate,
    required this.lastUpdated,
  });

  OrganizationTeam copyWith({
    String? id,
    String? code,
    String? name,
    String? departmentId,
    String? departmentName,
    String? parentTeamId,
    String? teamLead,
    String? teamLeadEmail,
    String? manager,
    String? managerEmail,
    int? memberCount,
    OrgStatus? status,
    String? branch,
    String? teamType,
    int? maxTeamSize,
    String? defaultAccessScopeId,
    String? description,
    DateTime? createdDate,
    DateTime? lastUpdated,
  }) {
    return OrganizationTeam(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      parentTeamId: parentTeamId ?? this.parentTeamId,
      teamLead: teamLead ?? this.teamLead,
      teamLeadEmail: teamLeadEmail ?? this.teamLeadEmail,
      manager: manager ?? this.manager,
      managerEmail: managerEmail ?? this.managerEmail,
      memberCount: memberCount ?? this.memberCount,
      status: status ?? this.status,
      branch: branch ?? this.branch,
      teamType: teamType ?? this.teamType,
      maxTeamSize: maxTeamSize ?? this.maxTeamSize,
      defaultAccessScopeId: defaultAccessScopeId ?? this.defaultAccessScopeId,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// 3. Team Member Assignment Entity
class OrganizationTeamMember {
  final String id;
  final String employeeId;
  final String name;
  final String avatarUrl;
  final String roleTitle;
  final String departmentName;
  final String teamId;
  final String teamName;
  final String managerName;
  final OrgStatus status;
  final DateTime joinedDate;

  const OrganizationTeamMember({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.avatarUrl,
    required this.roleTitle,
    required this.departmentName,
    required this.teamId,
    required this.teamName,
    required this.managerName,
    this.status = OrgStatus.active,
    required this.joinedDate,
  });
}

/// 4. Employee Organization Directory Entity (Strictly Organizational, Not HR)
class OrganizationEmployee {
  final String id;
  final String employeeId;
  final String name;
  final String avatarUrl;
  final String workEmail;
  final String workPhone;
  final String jobTitle;
  final String departmentId;
  final String departmentName;
  final String? teamId;
  final String? teamName;
  final String? managerId;
  final String? managerName;
  final String? secondaryManagerName;
  final String roleId;
  final String roleTitle;
  final RoleType roleType;
  final EmploymentStatus employmentStatus;
  final AccountStatus accountStatus;
  final String accessScopeId;
  final String accessScopeName;
  final String branch;
  final String businessUnit;
  final DateTime? lastLogin;
  final DateTime joinedDate;

  const OrganizationEmployee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.avatarUrl,
    required this.workEmail,
    required this.workPhone,
    required this.jobTitle,
    required this.departmentId,
    required this.departmentName,
    this.teamId,
    this.teamName,
    this.managerId,
    this.managerName,
    this.secondaryManagerName,
    required this.roleId,
    required this.roleTitle,
    this.roleType = RoleType.system,
    this.employmentStatus = EmploymentStatus.fullTime,
    this.accountStatus = AccountStatus.active,
    required this.accessScopeId,
    required this.accessScopeName,
    required this.branch,
    required this.businessUnit,
    this.lastLogin,
    required this.joinedDate,
  });

  OrganizationEmployee copyWith({
    String? id,
    String? employeeId,
    String? name,
    String? avatarUrl,
    String? workEmail,
    String? workPhone,
    String? jobTitle,
    String? departmentId,
    String? departmentName,
    String? teamId,
    String? teamName,
    String? managerId,
    String? managerName,
    String? secondaryManagerName,
    String? roleId,
    String? roleTitle,
    RoleType? roleType,
    EmploymentStatus? employmentStatus,
    AccountStatus? accountStatus,
    String? accessScopeId,
    String? accessScopeName,
    String? branch,
    String? businessUnit,
    DateTime? lastLogin,
    DateTime? joinedDate,
  }) {
    return OrganizationEmployee(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      workEmail: workEmail ?? this.workEmail,
      workPhone: workPhone ?? this.workPhone,
      jobTitle: jobTitle ?? this.jobTitle,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      secondaryManagerName: secondaryManagerName ?? this.secondaryManagerName,
      roleId: roleId ?? this.roleId,
      roleTitle: roleTitle ?? this.roleTitle,
      roleType: roleType ?? this.roleType,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      accountStatus: accountStatus ?? this.accountStatus,
      accessScopeId: accessScopeId ?? this.accessScopeId,
      accessScopeName: accessScopeName ?? this.accessScopeName,
      branch: branch ?? this.branch,
      businessUnit: businessUnit ?? this.businessUnit,
      lastLogin: lastLogin ?? this.lastLogin,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}

/// 5. Role Definition Entity
class OrganizationRole {
  final String id;
  final String roleCode;
  final String roleTitle;
  final String description;
  final RoleType roleType;
  final DepartmentType departmentType;
  final HierarchyLevel hierarchyLevel;
  final String reportingToRole;
  final int userCount;
  final int permissionCount;
  final String defaultAccessScopeId;
  final String defaultAccessScopeName;
  final OrgStatus status;
  final List<String> applicableDepartmentIds;
  final List<String> applicableTeamIds;
  final Set<String> permissionIds;
  final List<String> responsibilities;
  final double minSalary;
  final double maxSalary;
  final DateTime createdDate;
  final DateTime lastUpdated;

  const OrganizationRole({
    required this.id,
    required this.roleCode,
    required this.roleTitle,
    required this.description,
    this.roleType = RoleType.system,
    required this.departmentType,
    required this.hierarchyLevel,
    required this.reportingToRole,
    required this.userCount,
    required this.permissionCount,
    required this.defaultAccessScopeId,
    required this.defaultAccessScopeName,
    this.status = OrgStatus.active,
    this.applicableDepartmentIds = const [],
    this.applicableTeamIds = const [],
    required this.permissionIds,
    this.responsibilities = const [],
    this.minSalary = 0,
    this.maxSalary = 0,
    required this.createdDate,
    required this.lastUpdated,
  });

  // Backward compatibility getter
  AccessScope get defaultScope {
    if (defaultAccessScopeId.contains('OWN')) return AccessScope.myLeadsTasks;
    if (defaultAccessScopeId.contains('TEAM')) return AccessScope.teamWide;
    return AccessScope.organizationWide;
  }

  // Backward compatibility getter
  int get activeMembersCount => userCount;

  OrganizationRole copyWith({
    String? id,
    String? roleCode,
    String? roleTitle,
    String? description,
    RoleType? roleType,
    DepartmentType? departmentType,
    HierarchyLevel? hierarchyLevel,
    String? reportingToRole,
    int? userCount,
    int? permissionCount,
    String? defaultAccessScopeId,
    String? defaultAccessScopeName,
    OrgStatus? status,
    List<String>? applicableDepartmentIds,
    List<String>? applicableTeamIds,
    Set<String>? permissionIds,
    List<String>? responsibilities,
    double? minSalary,
    double? maxSalary,
    DateTime? createdDate,
    DateTime? lastUpdated,
  }) {
    return OrganizationRole(
      id: id ?? this.id,
      roleCode: roleCode ?? this.roleCode,
      roleTitle: roleTitle ?? this.roleTitle,
      description: description ?? this.description,
      roleType: roleType ?? this.roleType,
      departmentType: departmentType ?? this.departmentType,
      hierarchyLevel: hierarchyLevel ?? this.hierarchyLevel,
      reportingToRole: reportingToRole ?? this.reportingToRole,
      userCount: userCount ?? this.userCount,
      permissionCount: permissionCount ?? this.permissionCount,
      defaultAccessScopeId: defaultAccessScopeId ?? this.defaultAccessScopeId,
      defaultAccessScopeName: defaultAccessScopeName ?? this.defaultAccessScopeName,
      status: status ?? this.status,
      applicableDepartmentIds: applicableDepartmentIds ?? this.applicableDepartmentIds,
      applicableTeamIds: applicableTeamIds ?? this.applicableTeamIds,
      permissionIds: permissionIds ?? this.permissionIds,
      responsibilities: responsibilities ?? this.responsibilities,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Backward-compatible RoleDefinition wrapper
typedef RoleDefinition = OrganizationRole;

/// 6. Permission Entity
class OrganizationPermission {
  final String id;
  final String code;
  final String name;
  final String description;
  final PermissionModule module;
  final String feature;
  final PermissionAction action;
  final bool isSystem;
  final OrgStatus status;
  final List<String> assignedRoleIds;
  final List<String> requiredDependencies;
  final DateTime createdDate;

  const OrganizationPermission({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.module,
    required this.feature,
    required this.action,
    this.isSystem = true,
    this.status = OrgStatus.active,
    this.assignedRoleIds = const [],
    this.requiredDependencies = const [],
    required this.createdDate,
  });

  // Backward compatibility getters
  String get moduleCode => module.name.toUpperCase();
  String get moduleName => module.displayName;
  bool get canView => action == PermissionAction.view;
  bool get canCreate => action == PermissionAction.create;
  bool get canEdit => action == PermissionAction.edit;
  bool get canDelete => action == PermissionAction.delete;
  bool get canExport => action == PermissionAction.export;
  bool get canApprove => action == PermissionAction.approve;
  bool get isFieldIsolated => false;
}

// Backward-compatible ModulePermission wrapper
typedef ModulePermission = OrganizationPermission;

/// 7. Access Scope Entity (Which Data Can User Access?)
class OrganizationAccessScope {
  final String id;
  final String code;
  final String name;
  final AccessScopeLevel scopeLevel;
  final String description;
  final OrgStatus status;
  final List<String> applicableRoleIds;
  final List<String> departmentIds;
  final List<String> teamIds;
  final List<String> branches;
  final List<String> regions;
  final int userCount;
  final List<PermissionModule> applicableModules;
  final String recordOwnershipRule;
  final DateTime createdDate;
  final DateTime lastUpdated;

  const OrganizationAccessScope({
    required this.id,
    required this.code,
    required this.name,
    required this.scopeLevel,
    required this.description,
    this.status = OrgStatus.active,
    this.applicableRoleIds = const [],
    this.departmentIds = const [],
    this.teamIds = const [],
    this.branches = const [],
    this.regions = const [],
    required this.userCount,
    this.applicableModules = const [],
    required this.recordOwnershipRule,
    required this.createdDate,
    required this.lastUpdated,
  });

  OrganizationAccessScope copyWith({
    String? id,
    String? code,
    String? name,
    AccessScopeLevel? scopeLevel,
    String? description,
    OrgStatus? status,
    List<String>? applicableRoleIds,
    List<String>? departmentIds,
    List<String>? teamIds,
    List<String>? branches,
    List<String>? regions,
    int? userCount,
    List<PermissionModule>? applicableModules,
    String? recordOwnershipRule,
    DateTime? createdDate,
    DateTime? lastUpdated,
  }) {
    return OrganizationAccessScope(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      scopeLevel: scopeLevel ?? this.scopeLevel,
      description: description ?? this.description,
      status: status ?? this.status,
      applicableRoleIds: applicableRoleIds ?? this.applicableRoleIds,
      departmentIds: departmentIds ?? this.departmentIds,
      teamIds: teamIds ?? this.teamIds,
      branches: branches ?? this.branches,
      regions: regions ?? this.regions,
      userCount: userCount ?? this.userCount,
      applicableModules: applicableModules ?? this.applicableModules,
      recordOwnershipRule: recordOwnershipRule ?? this.recordOwnershipRule,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// 8. Effective Access Evaluation Summary Model
class EffectiveAccessSummary {
  final String employeeId;
  final String employeeName;
  final String roleTitle;
  final String scopeName;
  final String humanReadableSummary;
  final Map<PermissionModule, List<OrganizationPermission>> permissionsByModule;
  final bool hasAdminPrivileges;

  const EffectiveAccessSummary({
    required this.employeeId,
    required this.employeeName,
    required this.roleTitle,
    required this.scopeName,
    required this.humanReadableSummary,
    required this.permissionsByModule,
    required this.hasAdminPrivileges,
  });
}

/// 9. Organization Audit Trail Record
class OrganizationAuditLog {
  final String id;
  final String entityType; // Department, Team, Employee, Role, Permission, Scope
  final String entityId;
  final String entityName;
  final String action; // Created, Updated, Assigned, Deactivated, ScopeChanged
  final String changedBy;
  final String previousValue;
  final String newValue;
  final DateTime timestamp;
  final String reason;

  const OrganizationAuditLog({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.action,
    required this.changedBy,
    required this.previousValue,
    required this.newValue,
    required this.timestamp,
    required this.reason,
  });
}
