// Domain models for Module 14 & Sidebar Cluster 16: System Administration

enum AdminModuleCategory {
  sales('Sales CRM & Funnels'),
  quotation('Quotation & Estimation'),
  dam('Design Vault & DAM'),
  execution('Site Execution & Civil'),
  service('After-Sales & Warranty'),
  hrms('HRMS & Field Ops'),
  accounting('Finance & Ledgers'),
  marketplace('Marketplace & Materials'),
  aiSuite('AI Architectural Suite');

  final String label;
  const AdminModuleCategory(this.label);
}

enum FieldMaskLevel {
  fullAccess('Full Access'),
  maskedPartial('Partial Masking'),
  hidden('Hidden / Restricted');

  final String label;
  const FieldMaskLevel(this.label);
}

enum RateUnitType {
  sqft('Sq. Ft.'),
  rft('Running Ft.'),
  nos('Nos / Units'),
  lumpsum('Lump-sum'),
  sqm('Sq. Meter');

  final String label;
  const RateUnitType(this.label);
}

enum RateCategory {
  civilFlooring('Civil & Tile Flooring'),
  falseCeiling('False Ceiling & Gyproc'),
  modularWoodwork('Modular Woodwork & Carcass'),
  electricalLighting('Electrical & Smart Automation'),
  plumbingSanitary('Plumbing & Sanitaryware'),
  paintingPolishing('Painting & Polish Finishing'),
  glassHardware('Glass, Mirrors & Hardware');

  final String label;
  const RateCategory(this.label);
}

enum BackupStatus {
  completed('Completed & Verified'),
  inProgress('Exporting & Encrypting'),
  failed('Dispatch Error'),
  scheduled('Upcoming Schedule');

  final String label;
  const BackupStatus(this.label);
}

class RbacPermissionRow {
  final String id;
  final String moduleCode;
  final String moduleName;
  final AdminModuleCategory category;
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final bool canExport;
  final bool canApprove;
  final bool isFieldIsolated; // Enforces "My Leads / Tasks Only"
  final FieldMaskLevel phoneMasking;
  final FieldMaskLevel marginVisibility;
  final bool canOverrideCost;

  const RbacPermissionRow({
    required this.id,
    required this.moduleCode,
    required this.moduleName,
    required this.category,
    required this.canView,
    required this.canCreate,
    required this.canEdit,
    required this.canDelete,
    required this.canExport,
    required this.canApprove,
    required this.isFieldIsolated,
    required this.phoneMasking,
    required this.marginVisibility,
    required this.canOverrideCost,
  });

  RbacPermissionRow copyWith({
    String? id,
    String? moduleCode,
    String? moduleName,
    AdminModuleCategory? category,
    bool? canView,
    bool? canCreate,
    bool? canEdit,
    bool? canDelete,
    bool? canExport,
    bool? canApprove,
    bool? isFieldIsolated,
    FieldMaskLevel? phoneMasking,
    FieldMaskLevel? marginVisibility,
    bool? canOverrideCost,
  }) {
    return RbacPermissionRow(
      id: id ?? this.id,
      moduleCode: moduleCode ?? this.moduleCode,
      moduleName: moduleName ?? this.moduleName,
      category: category ?? this.category,
      canView: canView ?? this.canView,
      canCreate: canCreate ?? this.canCreate,
      canEdit: canEdit ?? this.canEdit,
      canDelete: canDelete ?? this.canDelete,
      canExport: canExport ?? this.canExport,
      canApprove: canApprove ?? this.canApprove,
      isFieldIsolated: isFieldIsolated ?? this.isFieldIsolated,
      phoneMasking: phoneMasking ?? this.phoneMasking,
      marginVisibility: marginVisibility ?? this.marginVisibility,
      canOverrideCost: canOverrideCost ?? this.canOverrideCost,
    );
  }
}

class MasterRateCardItem {
  final String id;
  final String itemCode;
  final String itemName;
  final RateCategory category;
  final String subCategory;
  final RateUnitType unit;
  final double materialCost;
  final double contractorLaborRate;
  final double recommendedSellingPrice;
  final String preferredBrand;
  final String technicalSpecification;
  final DateTime lastUpdated;
  final bool isLockedByAdmin;

  const MasterRateCardItem({
    required this.id,
    required this.itemCode,
    required this.itemName,
    required this.category,
    required this.subCategory,
    required this.unit,
    required this.materialCost,
    required this.contractorLaborRate,
    required this.recommendedSellingPrice,
    required this.preferredBrand,
    required this.technicalSpecification,
    required this.lastUpdated,
    this.isLockedByAdmin = true,
  });

  double get totalBaseCost => materialCost + contractorLaborRate;

  double get activeMarginPercentage {
    if (recommendedSellingPrice <= 0) return 0;
    return ((recommendedSellingPrice - totalBaseCost) / recommendedSellingPrice) * 100;
  }

  MasterRateCardItem copyWith({
    String? id,
    String? itemCode,
    String? itemName,
    RateCategory? category,
    String? subCategory,
    RateUnitType? unit,
    double? materialCost,
    double? contractorLaborRate,
    double? recommendedSellingPrice,
    String? preferredBrand,
    String? technicalSpecification,
    DateTime? lastUpdated,
    bool? isLockedByAdmin,
  }) {
    return MasterRateCardItem(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      unit: unit ?? this.unit,
      materialCost: materialCost ?? this.materialCost,
      contractorLaborRate: contractorLaborRate ?? this.contractorLaborRate,
      recommendedSellingPrice: recommendedSellingPrice ?? this.recommendedSellingPrice,
      preferredBrand: preferredBrand ?? this.preferredBrand,
      technicalSpecification: technicalSpecification ?? this.technicalSpecification,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLockedByAdmin: isLockedByAdmin ?? this.isLockedByAdmin,
    );
  }
}

class MarginTierRule {
  final String id;
  final String tierName;
  final String budgetRange;
  final double targetGrossMargin;
  final double minimumFloorMargin;
  final String approverRole;

  const MarginTierRule({
    required this.id,
    required this.tierName,
    required this.budgetRange,
    required this.targetGrossMargin,
    required this.minimumFloorMargin,
    required this.approverRole,
  });
}

class AiKnowledgeSnippet {
  final String id;
  final String title;
  final String category; // 'FAQ', 'Case Study', 'Objection Handling', 'Policy'
  final String questionPattern;
  final String responseBody;
  final bool isVerified;
  final DateTime lastUpdated;

  const AiKnowledgeSnippet({
    required this.id,
    required this.title,
    required this.category,
    required this.questionPattern,
    required this.responseBody,
    required this.isVerified,
    required this.lastUpdated,
  });

  AiKnowledgeSnippet copyWith({
    String? id,
    String? title,
    String? category,
    String? questionPattern,
    String? responseBody,
    bool? isVerified,
    DateTime? lastUpdated,
  }) {
    return AiKnowledgeSnippet(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      questionPattern: questionPattern ?? this.questionPattern,
      responseBody: responseBody ?? this.responseBody,
      isVerified: isVerified ?? this.isVerified,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class AiTrainingConfig {
  final String systemPrompt;
  final String modelName;
  final double temperature;
  final double maxDiscountPercent;
  final String primaryTone;
  final List<String> supportedLanguages;
  final List<String> humanEscalationKeywords;
  final int activeSnippetsCount;

  const AiTrainingConfig({
    required this.systemPrompt,
    required this.modelName,
    required this.temperature,
    required this.maxDiscountPercent,
    required this.primaryTone,
    required this.supportedLanguages,
    required this.humanEscalationKeywords,
    required this.activeSnippetsCount,
  });

  AiTrainingConfig copyWith({
    String? systemPrompt,
    String? modelName,
    double? temperature,
    double? maxDiscountPercent,
    String? primaryTone,
    List<String>? supportedLanguages,
    List<String>? humanEscalationKeywords,
    int? activeSnippetsCount,
  }) {
    return AiTrainingConfig(
      systemPrompt: systemPrompt ?? this.systemPrompt,
      modelName: modelName ?? this.modelName,
      temperature: temperature ?? this.temperature,
      maxDiscountPercent: maxDiscountPercent ?? this.maxDiscountPercent,
      primaryTone: primaryTone ?? this.primaryTone,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      humanEscalationKeywords: humanEscalationKeywords ?? this.humanEscalationKeywords,
      activeSnippetsCount: activeSnippetsCount ?? this.activeSnippetsCount,
    );
  }
}

class DisasterBackupLog {
  final String id;
  final String backupCode;
  final DateTime timestamp;
  final String triggerType; // 'Weekly Automated Cron' or 'Ad-Hoc Manual Trigger'
  final double sizeMb;
  final List<String> includedFormats;
  final String sha256Checksum;
  final String destinationEmail;
  final BackupStatus status;
  final String durationFormatted;

  const DisasterBackupLog({
    required this.id,
    required this.backupCode,
    required this.timestamp,
    required this.triggerType,
    required this.sizeMb,
    required this.includedFormats,
    required this.sha256Checksum,
    required this.destinationEmail,
    required this.status,
    required this.durationFormatted,
  });
}
