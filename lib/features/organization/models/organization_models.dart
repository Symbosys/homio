// Domain models for Module 3: Organization, Department & Role Hierarchy

import '../../hrms/models/hrms_models.dart';

export '../../hrms/models/hrms_models.dart' show DepartmentType, HierarchyLevel, AccessScope;

class DepartmentEntity {
  final String id;
  final String name;
  final DepartmentType type;
  final String headOfDepartment;
  final String headEmail;
  final String headPhone;
  final int headcount;
  final String targetKpi;
  final double monthlyBudgetPool;
  final String description;
  final List<String> coreFunctions;

  const DepartmentEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.headOfDepartment,
    required this.headEmail,
    required this.headPhone,
    required this.headcount,
    required this.targetKpi,
    required this.monthlyBudgetPool,
    required this.description,
    required this.coreFunctions,
  });

  DepartmentEntity copyWith({
    String? id,
    String? name,
    DepartmentType? type,
    String? headOfDepartment,
    String? headEmail,
    String? headPhone,
    int? headcount,
    String? targetKpi,
    double? monthlyBudgetPool,
    String? description,
    List<String>? coreFunctions,
  }) {
    return DepartmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      headOfDepartment: headOfDepartment ?? this.headOfDepartment,
      headEmail: headEmail ?? this.headEmail,
      headPhone: headPhone ?? this.headPhone,
      headcount: headcount ?? this.headcount,
      targetKpi: targetKpi ?? this.targetKpi,
      monthlyBudgetPool: monthlyBudgetPool ?? this.monthlyBudgetPool,
      description: description ?? this.description,
      coreFunctions: coreFunctions ?? this.coreFunctions,
    );
  }
}

class RoleDefinition {
  final String id;
  final DepartmentType departmentType;
  final String roleTitle;
  final HierarchyLevel hierarchyLevel;
  final String reportingToRole;
  final List<String> responsibilities;
  final double minSalary;
  final double maxSalary;
  final AccessScope defaultScope;
  final int activeMembersCount;

  const RoleDefinition({
    required this.id,
    required this.departmentType,
    required this.roleTitle,
    required this.hierarchyLevel,
    required this.reportingToRole,
    required this.responsibilities,
    required this.minSalary,
    required this.maxSalary,
    required this.defaultScope,
    required this.activeMembersCount,
  });

  RoleDefinition copyWith({
    String? id,
    DepartmentType? departmentType,
    String? roleTitle,
    HierarchyLevel? hierarchyLevel,
    String? reportingToRole,
    List<String>? responsibilities,
    double? minSalary,
    double? maxSalary,
    AccessScope? defaultScope,
    int? activeMembersCount,
  }) {
    return RoleDefinition(
      id: id ?? this.id,
      departmentType: departmentType ?? this.departmentType,
      roleTitle: roleTitle ?? this.roleTitle,
      hierarchyLevel: hierarchyLevel ?? this.hierarchyLevel,
      reportingToRole: reportingToRole ?? this.reportingToRole,
      responsibilities: responsibilities ?? this.responsibilities,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      defaultScope: defaultScope ?? this.defaultScope,
      activeMembersCount: activeMembersCount ?? this.activeMembersCount,
    );
  }
}

class ModulePermission {
  final String id;
  final String moduleCode;
  final String moduleName;
  final String description;
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final bool canExport;
  final bool canApprove;
  final bool isFieldIsolated; // Enforces "My Leads / Tasks Only"

  const ModulePermission({
    required this.id,
    required this.moduleCode,
    required this.moduleName,
    required this.description,
    required this.canView,
    required this.canCreate,
    required this.canEdit,
    required this.canDelete,
    required this.canExport,
    required this.canApprove,
    this.isFieldIsolated = false,
  });

  ModulePermission copyWith({
    String? id,
    String? moduleCode,
    String? moduleName,
    String? description,
    bool? canView,
    bool? canCreate,
    bool? canEdit,
    bool? canDelete,
    bool? canExport,
    bool? canApprove,
    bool? isFieldIsolated,
  }) {
    return ModulePermission(
      id: id ?? this.id,
      moduleCode: moduleCode ?? this.moduleCode,
      moduleName: moduleName ?? this.moduleName,
      description: description ?? this.description,
      canView: canView ?? this.canView,
      canCreate: canCreate ?? this.canCreate,
      canEdit: canEdit ?? this.canEdit,
      canDelete: canDelete ?? this.canDelete,
      canExport: canExport ?? this.canExport,
      canApprove: canApprove ?? this.canApprove,
      isFieldIsolated: isFieldIsolated ?? this.isFieldIsolated,
    );
  }
}
