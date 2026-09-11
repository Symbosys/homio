import 'package:flutter/material.dart';

// ============================================================================
// 1. USERS & RBAC MODELS
// ============================================================================

enum UserAccountStatus {
  active('Active', Color(0xFF10B981)),
  inactive('Inactive', Color(0xFF64748B)),
  pendingInvite('Pending Invite', Color(0xFFF59E0B)),
  suspended('Suspended', Color(0xFFEF4444));

  final String label;
  final Color color;
  const UserAccountStatus(this.label, this.color);
}

enum EmploymentType {
  fullTime('Full-Time (Permanent)'),
  contract('Contractor / Freelancer'),
  probation('Probationary'),
  intern('Intern');

  final String label;
  const EmploymentType(this.label);
}

enum DataScopeType {
  myRecords('My Records Only', 'User can only view records explicitly assigned to them'),
  myTeam('My Team', 'User can view records belonging to their assigned squad/team'),
  myDepartment('My Department', 'User can view all records within their functional department'),
  assignedProjects('Assigned Projects', 'User can view cross-functional records for their tagged projects'),
  organization('Organization-Wide', 'Full visibility across all departments and locations'),
  customScope('Custom Granular Scope', 'Rule-based scope configured per module and branch');

  final String label;
  final String description;
  const DataScopeType(this.label, this.description);
}

enum GranularAction {
  view('View', Icons.visibility_outlined),
  create('Create', Icons.add_circle_outline),
  edit('Edit', Icons.edit_outlined),
  delete('Delete', Icons.delete_outline),
  approve('Approve', Icons.check_circle_outline),
  reject('Reject', Icons.cancel_outlined),
  assign('Assign', Icons.person_add_outlined),
  export('Export', Icons.download_outlined),
  download('Download', Icons.file_download_outlined),
  share('Share', Icons.share_outlined),
  pay('Pay / Disburse', Icons.payments_outlined),
  requestPayment('Request Payment', Icons.request_quote_outlined),
  sendCommunication('Send Message', Icons.send_outlined),
  configure('Configure / Master', Icons.tune_outlined);

  final String label;
  final IconData icon;
  const GranularAction(this.label, this.icon);
}

class ModulePermissionMatrix {
  final String moduleId;
  final String moduleName;
  final String category;
  final Map<GranularAction, bool> actions;
  final DataScopeType dataScope;
  final bool phoneMasked;
  final bool marginMasked;

  const ModulePermissionMatrix({
    required this.moduleId,
    required this.moduleName,
    required this.category,
    required this.actions,
    this.dataScope = DataScopeType.myRecords,
    this.phoneMasked = false,
    this.marginMasked = false,
  });

  bool can(GranularAction action) => actions[action] ?? false;

  ModulePermissionMatrix copyWith({
    String? moduleId,
    String? moduleName,
    String? category,
    Map<GranularAction, bool>? actions,
    DataScopeType? dataScope,
    bool? phoneMasked,
    bool? marginMasked,
  }) {
    return ModulePermissionMatrix(
      moduleId: moduleId ?? this.moduleId,
      moduleName: moduleName ?? this.moduleName,
      category: category ?? this.category,
      actions: actions ?? Map.from(this.actions),
      dataScope: dataScope ?? this.dataScope,
      phoneMasked: phoneMasked ?? this.phoneMasked,
      marginMasked: marginMasked ?? this.marginMasked,
    );
  }
}

class AdminRole {
  final String id;
  final String roleCode;
  final String roleName;
  final String departmentId;
  final String departmentName;
  final String description;
  final String? parentRoleId;
  final String? parentRoleName;
  final DataScopeType defaultScope;
  final String approvalAuthority;
  final bool isActive;
  final int usersAssignedCount;
  final List<ModulePermissionMatrix> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminRole({
    required this.id,
    required this.roleCode,
    required this.roleName,
    required this.departmentId,
    required this.departmentName,
    required this.description,
    this.parentRoleId,
    this.parentRoleName,
    this.defaultScope = DataScopeType.myTeam,
    required this.approvalAuthority,
    this.isActive = true,
    this.usersAssignedCount = 0,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  AdminRole copyWith({
    String? id,
    String? roleCode,
    String? roleName,
    String? departmentId,
    String? departmentName,
    String? description,
    String? parentRoleId,
    String? parentRoleName,
    DataScopeType? defaultScope,
    String? approvalAuthority,
    bool? isActive,
    int? usersAssignedCount,
    List<ModulePermissionMatrix>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminRole(
      id: id ?? this.id,
      roleCode: roleCode ?? this.roleCode,
      roleName: roleName ?? this.roleName,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      description: description ?? this.description,
      parentRoleId: parentRoleId ?? this.parentRoleId,
      parentRoleName: parentRoleName ?? this.parentRoleName,
      defaultScope: defaultScope ?? this.defaultScope,
      approvalAuthority: approvalAuthority ?? this.approvalAuthority,
      isActive: isActive ?? this.isActive,
      usersAssignedCount: usersAssignedCount ?? this.usersAssignedCount,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserActivityLog {
  final String id;
  final String actionTitle;
  final String actionCategory;
  final String details;
  final String performedBy;
  final DateTime timestamp;

  const UserActivityLog({
    required this.id,
    required this.actionTitle,
    required this.actionCategory,
    required this.details,
    required this.performedBy,
    required this.timestamp,
  });
}

class AdminUser {
  final String id;
  final String employeeId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String displayName;
  final String? avatarUrl;
  final String gender;
  final DateTime? dateOfBirth;
  final String jobTitle;
  final EmploymentType employmentType;
  final UserAccountStatus accountStatus;

  // Contact Information
  final String primaryMobile;
  final String? alternateMobile;
  final String email;
  final String? alternateEmail;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  // Organization Assignment
  final String departmentId;
  final String departmentName;
  final String teamId;
  final String teamName;
  final String roleId;
  final String roleName;
  final String? reportingManagerId;
  final String? reportingManagerName;
  final String workLocation;
  final DateTime joiningDate;

  // Access Configuration
  final DataScopeType accessScope;
  final List<String> allowedModules;
  final List<String> assignedProjectIds;
  final String defaultLandingPage;
  final String approvalAuthority;

  // Notification Preferences
  final bool notifyEmail;
  final bool notifyWhatsApp;
  final bool notifyPush;
  final bool notifySms;
  final String preferredChannel;

  // Security & Authentication
  final String authMethod;
  final bool isTwoFactorEnabled;
  final bool forcePasswordChange;
  final DateTime? lastLogin;
  final DateTime? accessStartDate;
  final DateTime? accessExpiryDate;
  final String sessionSecurityStatus;
  final List<UserActivityLog> activityHistory;

  const AdminUser({
    required this.id,
    required this.employeeId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.displayName,
    this.avatarUrl,
    this.gender = 'Not Specified',
    this.dateOfBirth,
    required this.jobTitle,
    this.employmentType = EmploymentType.fullTime,
    this.accountStatus = UserAccountStatus.active,
    required this.primaryMobile,
    this.alternateMobile,
    required this.email,
    this.alternateEmail,
    required this.address,
    required this.city,
    required this.state,
    this.country = 'India',
    required this.postalCode,
    required this.departmentId,
    required this.departmentName,
    required this.teamId,
    required this.teamName,
    required this.roleId,
    required this.roleName,
    this.reportingManagerId,
    this.reportingManagerName,
    required this.workLocation,
    required this.joiningDate,
    this.accessScope = DataScopeType.myTeam,
    this.allowedModules = const [],
    this.assignedProjectIds = const [],
    this.defaultLandingPage = '/dashboard',
    this.approvalAuthority = 'Standard Tier 1 (Up to ₹50,000)',
    this.notifyEmail = true,
    this.notifyWhatsApp = true,
    this.notifyPush = true,
    this.notifySms = false,
    this.preferredChannel = 'WhatsApp',
    this.authMethod = 'Password + OTP',
    this.isTwoFactorEnabled = true,
    this.forcePasswordChange = false,
    this.lastLogin,
    this.accessStartDate,
    this.accessExpiryDate,
    this.sessionSecurityStatus = 'Healthy (Active Web Session)',
    this.activityHistory = const [],
  });

  String get fullName => middleName == null || middleName!.isEmpty
      ? '$firstName $lastName'
      : '$firstName $middleName $lastName';

  AdminUser copyWith({
    String? id,
    String? employeeId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? displayName,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? jobTitle,
    EmploymentType? employmentType,
    UserAccountStatus? accountStatus,
    String? primaryMobile,
    String? alternateMobile,
    String? email,
    String? alternateEmail,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? departmentId,
    String? departmentName,
    String? teamId,
    String? teamName,
    String? roleId,
    String? roleName,
    String? reportingManagerId,
    String? reportingManagerName,
    String? workLocation,
    DateTime? joiningDate,
    DataScopeType? accessScope,
    List<String>? allowedModules,
    List<String>? assignedProjectIds,
    String? defaultLandingPage,
    String? approvalAuthority,
    bool? notifyEmail,
    bool? notifyWhatsApp,
    bool? notifyPush,
    bool? notifySms,
    String? preferredChannel,
    String? authMethod,
    bool? isTwoFactorEnabled,
    bool? forcePasswordChange,
    DateTime? lastLogin,
    DateTime? accessStartDate,
    DateTime? accessExpiryDate,
    String? sessionSecurityStatus,
    List<UserActivityLog>? activityHistory,
  }) {
    return AdminUser(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      jobTitle: jobTitle ?? this.jobTitle,
      employmentType: employmentType ?? this.employmentType,
      accountStatus: accountStatus ?? this.accountStatus,
      primaryMobile: primaryMobile ?? this.primaryMobile,
      alternateMobile: alternateMobile ?? this.alternateMobile,
      email: email ?? this.email,
      alternateEmail: alternateEmail ?? this.alternateEmail,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      reportingManagerId: reportingManagerId ?? this.reportingManagerId,
      reportingManagerName: reportingManagerName ?? this.reportingManagerName,
      workLocation: workLocation ?? this.workLocation,
      joiningDate: joiningDate ?? this.joiningDate,
      accessScope: accessScope ?? this.accessScope,
      allowedModules: allowedModules ?? this.allowedModules,
      assignedProjectIds: assignedProjectIds ?? this.assignedProjectIds,
      defaultLandingPage: defaultLandingPage ?? this.defaultLandingPage,
      approvalAuthority: approvalAuthority ?? this.approvalAuthority,
      notifyEmail: notifyEmail ?? this.notifyEmail,
      notifyWhatsApp: notifyWhatsApp ?? this.notifyWhatsApp,
      notifyPush: notifyPush ?? this.notifyPush,
      notifySms: notifySms ?? this.notifySms,
      preferredChannel: preferredChannel ?? this.preferredChannel,
      authMethod: authMethod ?? this.authMethod,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      forcePasswordChange: forcePasswordChange ?? this.forcePasswordChange,
      lastLogin: lastLogin ?? this.lastLogin,
      accessStartDate: accessStartDate ?? this.accessStartDate,
      accessExpiryDate: accessExpiryDate ?? this.accessExpiryDate,
      sessionSecurityStatus: sessionSecurityStatus ?? this.sessionSecurityStatus,
      activityHistory: activityHistory ?? this.activityHistory,
    );
  }
}

class AdminDepartment {
  final String id;
  final String code;
  final String name;
  final String description;
  final String headOfDepartment;
  final int activeTeamsCount;
  final int activeEmployeesCount;
  final bool isActive;

  const AdminDepartment({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.headOfDepartment,
    required this.activeTeamsCount,
    required this.activeEmployeesCount,
    this.isActive = true,
  });
}

class AdminTeam {
  final String id;
  final String code;
  final String name;
  final String departmentId;
  final String departmentName;
  final String teamLead;
  final String description;
  final List<String> memberNames;
  final bool isActive;

  const AdminTeam({
    required this.id,
    required this.code,
    required this.name,
    required this.departmentId,
    required this.departmentName,
    required this.teamLead,
    required this.description,
    required this.memberNames,
    this.isActive = true,
  });
}

// ============================================================================
// 2. MASTER DATA MODELS
// ============================================================================

enum MasterGroupCategory {
  crm('CRM & Sales', Icons.people_alt_outlined),
  projects('Projects & Execution', Icons.construction_outlined),
  commercial('Commercial & Pricing', Icons.account_balance_outlined),
  procurement('Procurement & Materials', Icons.local_shipping_outlined),
  workforce('Workforce & Field Ops', Icons.badge_outlined),
  marketplace('Marketplace & Stores', Icons.storefront_outlined),
  custom('Custom Organization Masters', Icons.dataset_outlined);

  final String label;
  final IconData icon;
  const MasterGroupCategory(this.label, this.icon);
}

class MasterCategoryItem {
  final String id;
  final MasterGroupCategory group;
  final String code;
  final String name;
  final String description;
  final int recordCount;
  final bool allowCustomAdd;

  const MasterCategoryItem({
    required this.id,
    required this.group,
    required this.code,
    required this.name,
    required this.description,
    required this.recordCount,
    this.allowCustomAdd = true,
  });
}

class MasterRecord {
  final String id;
  final String categoryId;
  final String categoryName;
  final String code;
  final String name;
  final String description;
  final String? parentCategory;
  final int displayOrder;
  final bool isActive;
  final bool isSystemDefined;
  final DateTime effectiveDate;
  final int usageCount;
  final String usageContextDescription;
  final Map<String, String> customAttributes;

  const MasterRecord({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.code,
    required this.name,
    required this.description,
    this.parentCategory,
    required this.displayOrder,
    this.isActive = true,
    this.isSystemDefined = false,
    required this.effectiveDate,
    this.usageCount = 0,
    required this.usageContextDescription,
    this.customAttributes = const {},
  });

  MasterRecord copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    String? code,
    String? name,
    String? description,
    String? parentCategory,
    int? displayOrder,
    bool? isActive,
    bool? isSystemDefined,
    DateTime? effectiveDate,
    int? usageCount,
    String? usageContextDescription,
    Map<String, String>? customAttributes,
  }) {
    return MasterRecord(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      parentCategory: parentCategory ?? this.parentCategory,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      isSystemDefined: isSystemDefined ?? this.isSystemDefined,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      usageCount: usageCount ?? this.usageCount,
      usageContextDescription: usageContextDescription ?? this.usageContextDescription,
      customAttributes: customAttributes ?? this.customAttributes,
    );
  }
}

// ============================================================================
// 3. ITEM / RATE MASTERS MODELS
// ============================================================================

enum RateUnitBasis {
  sqFt('Sq. Ft.', 'Square Feet (Area measurement)'),
  runningFt('Running Ft.', 'Linear / Running Feet (Perimeter, skirting)'),
  pieceNos('Piece / Nos', 'Single Item Quantity'),
  lumpSum('Lump Sum', 'Fixed project package or consolidated service'),
  sqMeter('Sq. Meter', 'Metric Area measurement'),
  cubicFt('Cubic Ft.', 'Volume basis (Excavation, concrete)'),
  custom('Custom Unit', 'Configurable organizational unit');

  final String label;
  final String description;
  const RateUnitBasis(this.label, this.description);
}

enum MarginCalculationType {
  percentage('Percentage Markup (%)'),
  fixedAmount('Fixed Currency Amount (₹)');

  final String label;
  const MarginCalculationType(this.label);
}

class TechSpecifications {
  final String material;
  final String coreMaterial;
  final String finish;
  final String thickness;
  final String dimensions;
  final String hardware;
  final String brand;
  final String grade;
  final String color;
  final String warrantyPeriod;
  final String technicalNotes;
  final Map<String, String> additionalAttributes;

  const TechSpecifications({
    required this.material,
    required this.coreMaterial,
    required this.finish,
    required this.thickness,
    required this.dimensions,
    required this.hardware,
    required this.brand,
    required this.grade,
    required this.color,
    required this.warrantyPeriod,
    required this.technicalNotes,
    this.additionalAttributes = const {},
  });

  TechSpecifications copyWith({
    String? material,
    String? coreMaterial,
    String? finish,
    String? thickness,
    String? dimensions,
    String? hardware,
    String? brand,
    String? grade,
    String? color,
    String? warrantyPeriod,
    String? technicalNotes,
    Map<String, String>? additionalAttributes,
  }) {
    return TechSpecifications(
      material: material ?? this.material,
      coreMaterial: coreMaterial ?? this.coreMaterial,
      finish: finish ?? this.finish,
      thickness: thickness ?? this.thickness,
      dimensions: dimensions ?? this.dimensions,
      hardware: hardware ?? this.hardware,
      brand: brand ?? this.brand,
      grade: grade ?? this.grade,
      color: color ?? this.color,
      warrantyPeriod: warrantyPeriod ?? this.warrantyPeriod,
      technicalNotes: technicalNotes ?? this.technicalNotes,
      additionalAttributes: additionalAttributes ?? this.additionalAttributes,
    );
  }
}

class RateHistoryEntry {
  final String id;
  final String itemId;
  final double previousRate;
  final double newRate;
  final DateTime effectiveDate;
  final String changedBy;
  final String reason;
  final bool isScheduled;
  final String status; // 'Applied', 'Scheduled', 'Superseded'

  const RateHistoryEntry({
    required this.id,
    required this.itemId,
    required this.previousRate,
    required this.newRate,
    required this.effectiveDate,
    required this.changedBy,
    required this.reason,
    this.isScheduled = false,
    this.status = 'Applied',
  });
}

class RateMasterItem {
  final String id;
  final String itemCode;
  final String itemName;
  final String category;
  final String subCategory;
  final String brand;
  final String modelVariant;
  final String shortDescription;
  final String detailedDescription;
  final String imageUrl;
  final List<String> galleryImages;
  final bool isActive;

  // Commercial Units
  final RateUnitBasis unit;
  final String? secondaryUnit;
  final double secondaryUnitRatio;

  // Technical Specs
  final TechSpecifications specs;

  // Pricing Architecture
  final double baseMaterialCost;
  final double baseLaborCost;
  final double sellingRate;
  final MarginCalculationType marginType;
  final double marginValue;
  final DateTime effectiveFrom;
  final DateTime? effectiveUntil;
  final double taxGstPercent;
  final bool discountEligible;
  final bool customerVisibleRate;
  final bool internalCostVisible;

  // Operational references
  final int quotationReferencesCount;
  final int activeCataloguesCount;
  final List<RateHistoryEntry> rateHistory;
  final DateTime lastUpdated;

  const RateMasterItem({
    required this.id,
    required this.itemCode,
    required this.itemName,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.modelVariant,
    required this.shortDescription,
    required this.detailedDescription,
    required this.imageUrl,
    this.galleryImages = const [],
    this.isActive = true,
    required this.unit,
    this.secondaryUnit,
    this.secondaryUnitRatio = 1.0,
    required this.specs,
    required this.baseMaterialCost,
    required this.baseLaborCost,
    required this.sellingRate,
    this.marginType = MarginCalculationType.percentage,
    required this.marginValue,
    required this.effectiveFrom,
    this.effectiveUntil,
    this.taxGstPercent = 18.0,
    this.discountEligible = true,
    this.customerVisibleRate = true,
    this.internalCostVisible = false,
    this.quotationReferencesCount = 0,
    this.activeCataloguesCount = 1,
    this.rateHistory = const [],
    required this.lastUpdated,
  });

  double get totalBaseCost => baseMaterialCost + baseLaborCost;

  double get grossMarginPercentage {
    if (sellingRate <= 0) return 0;
    return ((sellingRate - totalBaseCost) / sellingRate) * 100;
  }

  RateMasterItem copyWith({
    String? id,
    String? itemCode,
    String? itemName,
    String? category,
    String? subCategory,
    String? brand,
    String? modelVariant,
    String? shortDescription,
    String? detailedDescription,
    String? imageUrl,
    List<String>? galleryImages,
    bool? isActive,
    RateUnitBasis? unit,
    String? secondaryUnit,
    double? secondaryUnitRatio,
    TechSpecifications? specs,
    double? baseMaterialCost,
    double? baseLaborCost,
    double? sellingRate,
    MarginCalculationType? marginType,
    double? marginValue,
    DateTime? effectiveFrom,
    DateTime? effectiveUntil,
    double? taxGstPercent,
    bool? discountEligible,
    bool? customerVisibleRate,
    bool? internalCostVisible,
    int? quotationReferencesCount,
    int? activeCataloguesCount,
    List<RateHistoryEntry>? rateHistory,
    DateTime? lastUpdated,
  }) {
    return RateMasterItem(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      brand: brand ?? this.brand,
      modelVariant: modelVariant ?? this.modelVariant,
      shortDescription: shortDescription ?? this.shortDescription,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      imageUrl: imageUrl ?? this.imageUrl,
      galleryImages: galleryImages ?? this.galleryImages,
      isActive: isActive ?? this.isActive,
      unit: unit ?? this.unit,
      secondaryUnit: secondaryUnit ?? this.secondaryUnit,
      secondaryUnitRatio: secondaryUnitRatio ?? this.secondaryUnitRatio,
      specs: specs ?? this.specs,
      baseMaterialCost: baseMaterialCost ?? this.baseMaterialCost,
      baseLaborCost: baseLaborCost ?? this.baseLaborCost,
      sellingRate: sellingRate ?? this.sellingRate,
      marginType: marginType ?? this.marginType,
      marginValue: marginValue ?? this.marginValue,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveUntil: effectiveUntil ?? this.effectiveUntil,
      taxGstPercent: taxGstPercent ?? this.taxGstPercent,
      discountEligible: discountEligible ?? this.discountEligible,
      customerVisibleRate: customerVisibleRate ?? this.customerVisibleRate,
      internalCostVisible: internalCostVisible ?? this.internalCostVisible,
      quotationReferencesCount: quotationReferencesCount ?? this.quotationReferencesCount,
      activeCataloguesCount: activeCataloguesCount ?? this.activeCataloguesCount,
      rateHistory: rateHistory ?? this.rateHistory,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// ============================================================================
// 4. MESSAGE TEMPLATES MODELS
// ============================================================================

enum TemplateChannel {
  whatsApp('WhatsApp Cloud', Icons.chat_bubble_outline, Color(0xFF25D366)),
  email('Corporate Email', Icons.mail_outline, Color(0xFF3B82F6)),
  sms('Transactional SMS', Icons.sms_outlined, Color(0xFFF59E0B)),
  push('Mobile App Push', Icons.notifications_active_outlined, Color(0xFF8B5CF6));

  final String label;
  final IconData icon;
  final Color brandColor;
  const TemplateChannel(this.label, this.icon, this.brandColor);
}

enum TemplateApprovalState {
  draft('Draft', Color(0xFF64748B)),
  pendingApproval('Pending Review', Color(0xFFF59E0B)),
  approved('Approved', Color(0xFF10B981)),
  published('Published & Live', Color(0xFF4F46E5)),
  archived('Archived', Color(0xFF94A3B8));

  final String label;
  final Color color;
  const TemplateApprovalState(this.label, this.color);
}

class TemplateVariable {
  final String key;
  final String label;
  final String category;
  final String sampleValue;

  const TemplateVariable({
    required this.key,
    required this.label,
    required this.category,
    required this.sampleValue,
  });
}

class TemplateButtonAction {
  final String id;
  final String buttonType; // 'Quick Reply', 'Call To Action (URL)', 'Phone Number'
  final String label;
  final String value;

  const TemplateButtonAction({
    required this.id,
    required this.buttonType,
    required this.label,
    required this.value,
  });
}

class MessageTemplate {
  final String id;
  final String code;
  final String name;
  final String category;
  final String description;
  final TemplateChannel channel;
  final String language;
  final TemplateApprovalState status;
  final String triggerEvent;
  final String internalNotes;
  final String messageBody;
  final List<String> usedVariables;
  final List<TemplateButtonAction> buttons;
  final String? attachmentType;
  final String? sampleAttachmentUrl;
  final int activeAutomationsCount;
  final DateTime updatedAt;
  final String updatedBy;

  const MessageTemplate({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.description,
    required this.channel,
    this.language = 'English (en_IN)',
    this.status = TemplateApprovalState.published,
    required this.triggerEvent,
    this.internalNotes = '',
    required this.messageBody,
    this.usedVariables = const [],
    this.buttons = const [],
    this.attachmentType,
    this.sampleAttachmentUrl,
    this.activeAutomationsCount = 0,
    required this.updatedAt,
    required this.updatedBy,
  });

  MessageTemplate copyWith({
    String? id,
    String? code,
    String? name,
    String? category,
    String? description,
    TemplateChannel? channel,
    String? language,
    TemplateApprovalState? status,
    String? triggerEvent,
    String? internalNotes,
    String? messageBody,
    List<String>? usedVariables,
    List<TemplateButtonAction>? buttons,
    String? attachmentType,
    String? sampleAttachmentUrl,
    int? activeAutomationsCount,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return MessageTemplate(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      channel: channel ?? this.channel,
      language: language ?? this.language,
      status: status ?? this.status,
      triggerEvent: triggerEvent ?? this.triggerEvent,
      internalNotes: internalNotes ?? this.internalNotes,
      messageBody: messageBody ?? this.messageBody,
      usedVariables: usedVariables ?? this.usedVariables,
      buttons: buttons ?? this.buttons,
      attachmentType: attachmentType ?? this.attachmentType,
      sampleAttachmentUrl: sampleAttachmentUrl ?? this.sampleAttachmentUrl,
      activeAutomationsCount: activeAutomationsCount ?? this.activeAutomationsCount,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}

// ============================================================================
// 5. AI TRAINING MODELS
// ============================================================================

enum KnowledgeSourceType {
  faq('Structured FAQ', Icons.quiz_outlined),
  companyPolicy('Company & Policies', Icons.corporate_fare_outlined),
  portfolioCase('Portfolio & Projects', Icons.photo_library_outlined),
  pricingGuardrails('Pricing Guardrails', Icons.verified_user_outlined),
  document('PDF / Document Upload', Icons.description_outlined),
  urlScrape('Live URL Scraping', Icons.language_outlined);

  final String label;
  final IconData icon;
  const KnowledgeSourceType(this.label, this.icon);
}

class AiPricingGuardrail {
  final String id;
  final String topic;
  final String rule;
  final String allowedDisclosure;
  final String forbiddenDisclosure;
  final double minimumSqFtFloor;
  final double maximumDiscountAllowed;
  final bool isStrictNonNegotiable;

  const AiPricingGuardrail({
    required this.id,
    required this.topic,
    required this.rule,
    required this.allowedDisclosure,
    required this.forbiddenDisclosure,
    required this.minimumSqFtFloor,
    required this.maximumDiscountAllowed,
    this.isStrictNonNegotiable = true,
  });
}

class AiFaqItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final List<String> keywords;
  final String language;
  final int priority; // 1 (Highest) - 5 (Lowest)
  final bool isActive;
  final bool escalationRequired;
  final String internalNotes;
  final DateTime lastUpdated;

  const AiFaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.keywords = const [],
    this.language = 'en_IN',
    this.priority = 1,
    this.isActive = true,
    this.escalationRequired = false,
    this.internalNotes = '',
    required this.lastUpdated,
  });

  AiFaqItem copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    List<String>? keywords,
    String? language,
    int? priority,
    bool? isActive,
    bool? escalationRequired,
    String? internalNotes,
    DateTime? lastUpdated,
  }) {
    return AiFaqItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      keywords: keywords ?? this.keywords,
      language: language ?? this.language,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      escalationRequired: escalationRequired ?? this.escalationRequired,
      internalNotes: internalNotes ?? this.internalNotes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class AiKnowledgeSource {
  final String id;
  final String name;
  final KnowledgeSourceType type;
  final String category;
  final String status; // 'Published', 'Draft', 'Syncing', 'Flagged'
  final String version;
  final String createdBy;
  final DateTime lastUpdated;
  final DateTime lastIndexed;
  final String summary;
  final int tokensCount;

  const AiKnowledgeSource({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.status,
    required this.version,
    required this.createdBy,
    required this.lastUpdated,
    required this.lastIndexed,
    required this.summary,
    required this.tokensCount,
  });
}

class AiTestingSimulation {
  final String customerQuery;
  final String aiResponse;
  final String matchedKnowledgeSource;
  final double confidenceScore; // 0.0 - 1.0
  final bool escalationDecision;
  final String suggestedHumanAction;

  const AiTestingSimulation({
    required this.customerQuery,
    required this.aiResponse,
    required this.matchedKnowledgeSource,
    required this.confidenceScore,
    required this.escalationDecision,
    required this.suggestedHumanAction,
  });
}

// ============================================================================
// 6. INTEGRATIONS MODELS
// ============================================================================

enum IntegrationCategory {
  crmLeadSources('CRM & Ad Lead Sources', Icons.ads_click_outlined),
  communication('Customer Communication', Icons.forum_outlined),
  calling('Telephony & AI Calling', Icons.call_outlined),
  payments('Payment Gateways', Icons.payment_outlined),
  storage('Cloud Object Storage', Icons.cloud_queue_outlined),
  mapsLocation('Maps & Geolocation', Icons.place_outlined),
  aiProviders('AI & Generative Engines', Icons.psychology_outlined),
  calendarVideo('Calendar & Meetings', Icons.video_camera_front_outlined);

  final String label;
  final IconData icon;
  const IntegrationCategory(this.label, this.icon);
}

enum IntegrationConnectionStatus {
  connected('Connected', Color(0xFF10B981)),
  notConnected('Not Connected', Color(0xFF64748B)),
  actionRequired('Action Required', Color(0xFFF59E0B)),
  connectionError('Connection Error', Color(0xFFEF4444)),
  expired('Token Expired', Color(0xFFEA580C)),
  disabled('Disabled', Color(0xFF94A3B8));

  final String label;
  final Color color;
  const IntegrationConnectionStatus(this.label, this.color);
}

class IntegrationFieldMapping {
  final String id;
  final String externalField;
  final String homioField;
  final String defaultValue;
  final bool isRequired;
  final String sampleData;

  const IntegrationFieldMapping({
    required this.id,
    required this.externalField,
    required this.homioField,
    this.defaultValue = '',
    this.isRequired = false,
    this.sampleData = '',
  });

  IntegrationFieldMapping copyWith({
    String? id,
    String? externalField,
    String? homioField,
    String? defaultValue,
    bool? isRequired,
    String? sampleData,
  }) {
    return IntegrationFieldMapping(
      id: id ?? this.id,
      externalField: externalField ?? this.externalField,
      homioField: homioField ?? this.homioField,
      defaultValue: defaultValue ?? this.defaultValue,
      isRequired: isRequired ?? this.isRequired,
      sampleData: sampleData ?? this.sampleData,
    );
  }
}

class IntegrationHealthMetrics {
  final double uptimePercent;
  final int totalRequests24h;
  final int successfulRequests24h;
  final int failedRequests24h;
  final int latencyMs;
  final String lastErrorSummary;
  final DateTime? lastErrorTimestamp;

  const IntegrationHealthMetrics({
    required this.uptimePercent,
    required this.totalRequests24h,
    required this.successfulRequests24h,
    required this.failedRequests24h,
    required this.latencyMs,
    this.lastErrorSummary = 'None (0 errors in last 24h)',
    this.lastErrorTimestamp,
  });
}

class IntegrationService {
  final String id;
  final String providerKey;
  final String name;
  final IntegrationCategory category;
  final String description;
  final String iconUrl;
  final IntegrationConnectionStatus connectionStatus;
  final String environment; // 'Production', 'Sandbox / Test'
  final DateTime? connectedSince;
  final DateTime? lastSyncTimestamp;
  final String connectionOwner;
  final Map<String, String> credentialsMap; // Masked representation
  final Map<String, dynamic> providerConfig;
  final List<IntegrationFieldMapping> fieldMappings;
  final IntegrationHealthMetrics healthMetrics;
  final List<String> affectedWorkflowsOnDisable;

  const IntegrationService({
    required this.id,
    required this.providerKey,
    required this.name,
    required this.category,
    required this.description,
    required this.iconUrl,
    required this.connectionStatus,
    this.environment = 'Production',
    this.connectedSince,
    this.lastSyncTimestamp,
    required this.connectionOwner,
    required this.credentialsMap,
    this.providerConfig = const {},
    this.fieldMappings = const [],
    required this.healthMetrics,
    this.affectedWorkflowsOnDisable = const [],
  });

  IntegrationService copyWith({
    String? id,
    String? providerKey,
    String? name,
    IntegrationCategory? category,
    String? description,
    String? iconUrl,
    IntegrationConnectionStatus? connectionStatus,
    String? environment,
    DateTime? connectedSince,
    DateTime? lastSyncTimestamp,
    String? connectionOwner,
    Map<String, String>? credentialsMap,
    Map<String, dynamic>? providerConfig,
    List<IntegrationFieldMapping>? fieldMappings,
    IntegrationHealthMetrics? healthMetrics,
    List<String>? affectedWorkflowsOnDisable,
  }) {
    return IntegrationService(
      id: id ?? this.id,
      providerKey: providerKey ?? this.providerKey,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      environment: environment ?? this.environment,
      connectedSince: connectedSince ?? this.connectedSince,
      lastSyncTimestamp: lastSyncTimestamp ?? this.lastSyncTimestamp,
      connectionOwner: connectionOwner ?? this.connectionOwner,
      credentialsMap: credentialsMap ?? this.credentialsMap,
      providerConfig: providerConfig ?? this.providerConfig,
      fieldMappings: fieldMappings ?? this.fieldMappings,
      healthMetrics: healthMetrics ?? this.healthMetrics,
      affectedWorkflowsOnDisable: affectedWorkflowsOnDisable ?? this.affectedWorkflowsOnDisable,
    );
  }
}
