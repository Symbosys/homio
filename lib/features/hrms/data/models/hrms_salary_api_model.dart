/// Industry Standard Salary Structure & Revision Model
class HrmsSalaryApiModel {
  final String id;
  final String organizationId;
  final String employeeId;

  // Temporal Validity / Effective Dating (SCD Type 2)
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final bool isCurrent;

  // Revision Metadata
  final String revisionReason;
  final DateTime revisionDate;
  final double? percentageHike;
  final String? remarks;
  final String? incrementLetterUrl;

  // Currency & Cadence
  final String currency;
  final String payFrequency;

  // Key Aggregates
  final double annualCtc;
  final double monthlyGross;
  final double? monthlyNet;

  // Monthly Earnings Breakdown
  final double basicSalary;
  final double hra;
  final double dearnessAllowance;
  final double conveyanceAllowance;
  final double specialAllowance;
  final double medicalAllowance;
  final double otherAllowances;

  // Monthly Deductions Breakdown
  final double pfEmployee;
  final double esiEmployee;
  final double professionalTax;
  final double tdsMonthly;

  // Monthly Employer Contributions Breakdown (Part of CTC)
  final double pfEmployer;
  final double esiEmployer;
  final double gratuityMonthly;
  final double insuranceMonthly;

  // Dynamic / Extensible Custom Components
  final List<dynamic>? customComponents;

  final DateTime createdAt;
  final DateTime updatedAt;

  const HrmsSalaryApiModel({
    required this.id,
    required this.organizationId,
    required this.employeeId,
    required this.effectiveFrom,
    this.effectiveTo,
    required this.isCurrent,
    required this.revisionReason,
    required this.revisionDate,
    this.percentageHike,
    this.remarks,
    this.incrementLetterUrl,
    required this.currency,
    required this.payFrequency,
    required this.annualCtc,
    required this.monthlyGross,
    this.monthlyNet,
    required this.basicSalary,
    required this.hra,
    required this.dearnessAllowance,
    required this.conveyanceAllowance,
    required this.specialAllowance,
    required this.medicalAllowance,
    required this.otherAllowances,
    required this.pfEmployee,
    required this.esiEmployee,
    required this.professionalTax,
    required this.tdsMonthly,
    required this.pfEmployer,
    required this.esiEmployer,
    required this.gratuityMonthly,
    required this.insuranceMonthly,
    this.customComponents,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Helper to safely extract image/document URL from JSON map or raw string
  static String? _parseDocumentUrl(dynamic val) {
    if (val == null) return null;
    if (val is String) return val;
    if (val is Map<String, dynamic>) {
      return val['url'] as String? ?? val['secureUrl'] as String?;
    }
    return null;
  }

  static double _parseDouble(dynamic val, [double fallback = 0.0]) {
    if (val == null) return fallback;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? fallback;
    return fallback;
  }

  static double? _parseOptionalDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val);
    return null;
  }

  factory HrmsSalaryApiModel.fromJson(Map<String, dynamic> json) {
    return HrmsSalaryApiModel(
      id: json['id']?.toString() ?? '',
      organizationId: json['organizationId']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      effectiveFrom: json['effectiveFrom'] != null
          ? DateTime.tryParse(json['effectiveFrom'].toString()) ?? DateTime.now()
          : DateTime.now(),
      effectiveTo: json['effectiveTo'] != null
          ? DateTime.tryParse(json['effectiveTo'].toString())
          : null,
      isCurrent: json['isCurrent'] == true,
      revisionReason: json['revisionReason']?.toString() ?? 'NEW_HIRE',
      revisionDate: json['revisionDate'] != null
          ? DateTime.tryParse(json['revisionDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      percentageHike: _parseOptionalDouble(json['percentageHike']),
      remarks: json['remarks']?.toString(),
      incrementLetterUrl: _parseDocumentUrl(json['incrementLetterUrl']),
      currency: json['currency']?.toString() ?? 'INR',
      payFrequency: json['payFrequency']?.toString() ?? 'MONTHLY',
      annualCtc: _parseDouble(json['annualCtc']),
      monthlyGross: _parseDouble(json['monthlyGross']),
      monthlyNet: _parseOptionalDouble(json['monthlyNet']),
      basicSalary: _parseDouble(json['basicSalary']),
      hra: _parseDouble(json['hra']),
      dearnessAllowance: _parseDouble(json['dearnessAllowance']),
      conveyanceAllowance: _parseDouble(json['conveyanceAllowance']),
      specialAllowance: _parseDouble(json['specialAllowance']),
      medicalAllowance: _parseDouble(json['medicalAllowance']),
      otherAllowances: _parseDouble(json['otherAllowances']),
      pfEmployee: _parseDouble(json['pfEmployee']),
      esiEmployee: _parseDouble(json['esiEmployee']),
      professionalTax: _parseDouble(json['professionalTax']),
      tdsMonthly: _parseDouble(json['tdsMonthly']),
      pfEmployer: _parseDouble(json['pfEmployer']),
      esiEmployer: _parseDouble(json['esiEmployer']),
      gratuityMonthly: _parseDouble(json['gratuityMonthly']),
      insuranceMonthly: _parseDouble(json['insuranceMonthly']),
      customComponents: json['customComponents'] is List ? json['customComponents'] as List<dynamic> : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'effectiveFrom': effectiveFrom.toIso8601String().split('T')[0],
      if (effectiveTo != null) 'effectiveTo': effectiveTo!.toIso8601String().split('T')[0],
      'isCurrent': isCurrent,
      'revisionReason': revisionReason,
      'revisionDate': revisionDate.toIso8601String().split('T')[0],
      if (percentageHike != null) 'percentageHike': percentageHike,
      if (remarks != null) 'remarks': remarks,
      'currency': currency,
      'payFrequency': payFrequency,
      'annualCtc': annualCtc,
      'monthlyGross': monthlyGross,
      if (monthlyNet != null) 'monthlyNet': monthlyNet,
      'basicSalary': basicSalary,
      'hra': hra,
      'dearnessAllowance': dearnessAllowance,
      'conveyanceAllowance': conveyanceAllowance,
      'specialAllowance': specialAllowance,
      'medicalAllowance': medicalAllowance,
      'otherAllowances': otherAllowances,
      'pfEmployee': pfEmployee,
      'esiEmployee': esiEmployee,
      'professionalTax': professionalTax,
      'tdsMonthly': tdsMonthly,
      'pfEmployer': pfEmployer,
      'esiEmployer': esiEmployer,
      'gratuityMonthly': gratuityMonthly,
      'insuranceMonthly': insuranceMonthly,
      if (customComponents != null) 'customComponents': customComponents,
    };
  }
}
