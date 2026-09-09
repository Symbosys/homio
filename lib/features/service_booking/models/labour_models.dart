import 'package:flutter/material.dart';

enum TradeType {
  carpentry,
  masonry,
  electrical,
  plumbing,
  painting,
  popFalseCeiling,
  fabrication,
  tiling,
  hvac,
}

extension TradeTypeExtension on TradeType {
  String get label {
    switch (this) {
      case TradeType.carpentry:
        return 'Carpentry & Woodwork';
      case TradeType.masonry:
        return 'Masonry & Civil Works';
      case TradeType.electrical:
        return 'Electrical & Lighting';
      case TradeType.plumbing:
        return 'Plumbing & Sanitary';
      case TradeType.painting:
        return 'Painting & PU Polish';
      case TradeType.popFalseCeiling:
        return 'POP & False Ceiling';
      case TradeType.fabrication:
        return 'Metal Fabrication & Grills';
      case TradeType.tiling:
        return 'Tile & Granite Laying';
      case TradeType.hvac:
        return 'HVAC & Ducting';
    }
  }

  IconData get icon {
    switch (this) {
      case TradeType.carpentry:
        return Icons.carpenter_outlined;
      case TradeType.masonry:
        return Icons.foundation_outlined;
      case TradeType.electrical:
        return Icons.electrical_services_outlined;
      case TradeType.plumbing:
        return Icons.plumbing_outlined;
      case TradeType.painting:
        return Icons.format_paint_outlined;
      case TradeType.popFalseCeiling:
        return Icons.grid_view_outlined;
      case TradeType.fabrication:
        return Icons.precision_manufacturing_outlined;
      case TradeType.tiling:
        return Icons.dashboard_outlined;
      case TradeType.hvac:
        return Icons.ac_unit_outlined;
    }
  }

  Color get color {
    switch (this) {
      case TradeType.carpentry:
        return const Color(0xFFD97706); // Amber
      case TradeType.masonry:
        return const Color(0xFF475569); // Slate
      case TradeType.electrical:
        return const Color(0xFFF59E0B); // Yellow
      case TradeType.plumbing:
        return const Color(0xFF0284C7); // Sky Blue
      case TradeType.painting:
        return const Color(0xFF8B5CF6); // Violet
      case TradeType.popFalseCeiling:
        return const Color(0xFF10B981); // Emerald
      case TradeType.fabrication:
        return const Color(0xFF6366F1); // Indigo
      case TradeType.tiling:
        return const Color(0xFFEC4899); // Pink
      case TradeType.hvac:
        return const Color(0xFF06B6D4); // Cyan
    }
  }
}

enum SkillLevel {
  beginner,
  intermediate,
  skilled,
  expert,
  specialist,
}

extension SkillLevelExtension on SkillLevel {
  String get label {
    switch (this) {
      case SkillLevel.beginner:
        return 'Beginner (Helper)';
      case SkillLevel.intermediate:
        return 'Intermediate (Assistant)';
      case SkillLevel.skilled:
        return 'Skilled (Independent)';
      case SkillLevel.expert:
        return 'Expert (Master Craftsman)';
      case SkillLevel.specialist:
        return 'Specialist (Lead/Foreman)';
    }
  }

  Color get color {
    switch (this) {
      case SkillLevel.beginner:
        return const Color(0xFF94A3B8);
      case SkillLevel.intermediate:
        return const Color(0xFF38BDF8);
      case SkillLevel.skilled:
        return const Color(0xFF10B981);
      case SkillLevel.expert:
        return const Color(0xFF8B5CF6);
      case SkillLevel.specialist:
        return const Color(0xFFF59E0B);
    }
  }
}

enum RateUnit {
  perDay,
  perHour,
  perSqft,
  lumpSum,
}

extension RateUnitExtension on RateUnit {
  String get label {
    switch (this) {
      case RateUnit.perDay:
        return '₹ / Day (8 Hrs)';
      case RateUnit.perHour:
        return '₹ / Hour';
      case RateUnit.perSqft:
        return '₹ / Sqft';
      case RateUnit.lumpSum:
        return '₹ Lump Sum / Job';
    }
  }
}

enum LabourStatus {
  available,
  onSite,
  booked,
  onLeave,
  blacklisted,
}

extension LabourStatusExtension on LabourStatus {
  String get label {
    switch (this) {
      case LabourStatus.available:
        return 'Available Now';
      case LabourStatus.onSite:
        return 'Active on Site';
      case LabourStatus.booked:
        return 'Pre-Booked';
      case LabourStatus.onLeave:
        return 'On Leave';
      case LabourStatus.blacklisted:
        return 'Blacklisted';
    }
  }

  Color get color {
    switch (this) {
      case LabourStatus.available:
        return const Color(0xFF10B981);
      case LabourStatus.onSite:
        return const Color(0xFF3B82F6);
      case LabourStatus.booked:
        return const Color(0xFFF59E0B);
      case LabourStatus.onLeave:
        return const Color(0xFF64748B);
      case LabourStatus.blacklisted:
        return const Color(0xFFEF4444);
    }
  }
}

enum ExtendedLabourStatus {
  pendingOnboarding,
  kycPending,
  underVerification,
  approved,
  active,
  temporarilyUnavailable,
  onJob,
  suspended,
  blacklisted,
  inactive,
  rejected,
}

extension ExtendedLabourStatusExtension on ExtendedLabourStatus {
  String get label {
    switch (this) {
      case ExtendedLabourStatus.pendingOnboarding:
        return 'Pending Onboarding';
      case ExtendedLabourStatus.kycPending:
        return 'KYC Pending';
      case ExtendedLabourStatus.underVerification:
        return 'Under Verification';
      case ExtendedLabourStatus.approved:
        return 'Approved';
      case ExtendedLabourStatus.active:
        return 'Active';
      case ExtendedLabourStatus.temporarilyUnavailable:
        return 'Temporarily Unavailable';
      case ExtendedLabourStatus.onJob:
        return 'On Job';
      case ExtendedLabourStatus.suspended:
        return 'Suspended';
      case ExtendedLabourStatus.blacklisted:
        return 'Blacklisted';
      case ExtendedLabourStatus.inactive:
        return 'Inactive';
      case ExtendedLabourStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case ExtendedLabourStatus.pendingOnboarding:
        return const Color(0xFF94A3B8);
      case ExtendedLabourStatus.kycPending:
        return const Color(0xFFF59E0B);
      case ExtendedLabourStatus.underVerification:
        return const Color(0xFF6366F1);
      case ExtendedLabourStatus.approved:
        return const Color(0xFF10B981);
      case ExtendedLabourStatus.active:
        return const Color(0xFF059669);
      case ExtendedLabourStatus.temporarilyUnavailable:
        return const Color(0xFFD97706);
      case ExtendedLabourStatus.onJob:
        return const Color(0xFF3B82F6);
      case ExtendedLabourStatus.suspended:
        return const Color(0xFFDC2626);
      case ExtendedLabourStatus.blacklisted:
        return const Color(0xFF7F1D1D);
      case ExtendedLabourStatus.inactive:
        return const Color(0xFF64748B);
      case ExtendedLabourStatus.rejected:
        return const Color(0xFFEF4444);
    }
  }
}

enum KycStatus {
  pending,
  underReview,
  biometricsVerified,
  approved,
  rejected,
}

extension KycStatusExtension on KycStatus {
  String get label {
    switch (this) {
      case KycStatus.pending:
        return 'Pending Verification';
      case KycStatus.underReview:
        return 'Under OCR Review';
      case KycStatus.biometricsVerified:
        return 'Biometrics Verified';
      case KycStatus.approved:
        return 'KYC Approved & Verified';
      case KycStatus.rejected:
        return 'Rejected / Incomplete';
    }
  }

  Color get color {
    switch (this) {
      case KycStatus.pending:
        return const Color(0xFFF59E0B);
      case KycStatus.underReview:
        return const Color(0xFF6366F1);
      case KycStatus.biometricsVerified:
        return const Color(0xFF06B6D4);
      case KycStatus.approved:
        return const Color(0xFF10B981);
      case KycStatus.rejected:
        return const Color(0xFFEF4444);
    }
  }
}

enum BookingStatus {
  requested,
  accepted,
  inProgress,
  checklistSigned,
  completed,
  disputed,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.requested:
        return 'Dispatch Requested';
      case BookingStatus.accepted:
        return 'Accepted by Worker';
      case BookingStatus.inProgress:
        return 'Work In Progress';
      case BookingStatus.checklistSigned:
        return 'Checklist Signed';
      case BookingStatus.completed:
        return 'Completed & Settled';
      case BookingStatus.disputed:
        return 'Under Legal Dispute';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.requested:
        return const Color(0xFF8B5CF6);
      case BookingStatus.accepted:
        return const Color(0xFF3B82F6);
      case BookingStatus.inProgress:
        return const Color(0xFF0284C7);
      case BookingStatus.checklistSigned:
        return const Color(0xFF10B981);
      case BookingStatus.completed:
        return const Color(0xFF059669);
      case BookingStatus.disputed:
        return const Color(0xFFEF4444);
      case BookingStatus.cancelled:
        return const Color(0xFF64748B);
    }
  }
}

enum ActiveJobStatus {
  assigned,
  accepted,
  awaitingCheckin,
  checkedIn,
  workStarted,
  inProgress,
  delayed,
  awaitingVerification,
  correctionRequired,
  completed,
  paymentPending,
  settled,
  disputed,
  cancelled,
}

extension ActiveJobStatusExtension on ActiveJobStatus {
  String get label {
    switch (this) {
      case ActiveJobStatus.assigned:
        return 'Assigned';
      case ActiveJobStatus.accepted:
        return 'Accepted';
      case ActiveJobStatus.awaitingCheckin:
        return 'Awaiting Check-in';
      case ActiveJobStatus.checkedIn:
        return 'Checked In';
      case ActiveJobStatus.workStarted:
        return 'Work Started';
      case ActiveJobStatus.inProgress:
        return 'In Progress';
      case ActiveJobStatus.delayed:
        return 'Delayed';
      case ActiveJobStatus.awaitingVerification:
        return 'Awaiting Verification';
      case ActiveJobStatus.correctionRequired:
        return 'Correction Required';
      case ActiveJobStatus.completed:
        return 'Completed';
      case ActiveJobStatus.paymentPending:
        return 'Payment Pending';
      case ActiveJobStatus.settled:
        return 'Settled';
      case ActiveJobStatus.disputed:
        return 'Disputed';
      case ActiveJobStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case ActiveJobStatus.assigned:
        return const Color(0xFF94A3B8);
      case ActiveJobStatus.accepted:
        return const Color(0xFF38BDF8);
      case ActiveJobStatus.awaitingCheckin:
        return const Color(0xFFF59E0B);
      case ActiveJobStatus.checkedIn:
        return const Color(0xFF06B6D4);
      case ActiveJobStatus.workStarted:
        return const Color(0xFF3B82F6);
      case ActiveJobStatus.inProgress:
        return const Color(0xFF0284C7);
      case ActiveJobStatus.delayed:
        return const Color(0xFFEF4444);
      case ActiveJobStatus.awaitingVerification:
        return const Color(0xFF8B5CF6);
      case ActiveJobStatus.correctionRequired:
        return const Color(0xFFF97316);
      case ActiveJobStatus.completed:
        return const Color(0xFF10B981);
      case ActiveJobStatus.paymentPending:
        return const Color(0xFFEAB308);
      case ActiveJobStatus.settled:
        return const Color(0xFF059669);
      case ActiveJobStatus.disputed:
        return const Color(0xFFB91C1C);
      case ActiveJobStatus.cancelled:
        return const Color(0xFF64748B);
    }
  }
}

enum DisputeScenario {
  clientNonPayment,
  labourAbandonment,
  qualityBreach,
  safetyViolation,
  scopeBreach,
}

extension DisputeScenarioExtension on DisputeScenario {
  String get label {
    switch (this) {
      case DisputeScenario.clientNonPayment:
        return 'Client Non-Payment / Default';
      case DisputeScenario.labourAbandonment:
        return 'Labour Abandonment';
      case DisputeScenario.qualityBreach:
        return 'Quality & Craftsmanship Breach';
      case DisputeScenario.safetyViolation:
        return 'Site Safety / Negligence';
      case DisputeScenario.scopeBreach:
        return 'Scope & Timeline Violation';
    }
  }
}

enum DisputeLegalStatus {
  internalReview,
  legalNoticeSent,
  labourCourtFiled,
  arbitrationSettled,
  blacklisted,
}

extension DisputeLegalStatusExtension on DisputeLegalStatus {
  String get label {
    switch (this) {
      case DisputeLegalStatus.internalReview:
        return 'Internal Mediation Review';
      case DisputeLegalStatus.legalNoticeSent:
        return 'Statutory Notice Sent';
      case DisputeLegalStatus.labourCourtFiled:
        return 'Labour Court Case Filed';
      case DisputeLegalStatus.arbitrationSettled:
        return 'Settled in Arbitration';
      case DisputeLegalStatus.blacklisted:
        return 'Blacklisted & Locked';
    }
  }

  Color get color {
    switch (this) {
      case DisputeLegalStatus.internalReview:
        return const Color(0xFFF59E0B);
      case DisputeLegalStatus.legalNoticeSent:
        return const Color(0xFFEC4899);
      case DisputeLegalStatus.labourCourtFiled:
        return const Color(0xFFEF4444);
      case DisputeLegalStatus.arbitrationSettled:
        return const Color(0xFF10B981);
      case DisputeLegalStatus.blacklisted:
        return const Color(0xFF7F1D1D);
    }
  }
}

// -----------------------------------------------------------------------------
// CORE DOMAIN ENTITIES
// -----------------------------------------------------------------------------

class TradeMaster {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<SkillLevel> skillLevels;
  final RateUnit defaultRateUnit;
  final bool isActive;
  final List<String> requiredKycDocs;
  final List<String> certifications;

  const TradeMaster({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.skillLevels,
    required this.defaultRateUnit,
    this.isActive = true,
    this.requiredKycDocs = const ['Aadhaar Card', 'Police Verification Certificate'],
    this.certifications = const [],
  });
}

class WeeklyDaySchedule {
  final String dayName;
  final bool isAvailable;
  final String startTime;
  final String endTime;
  final bool isFullDay;

  const WeeklyDaySchedule({
    required this.dayName,
    required this.isAvailable,
    this.startTime = '09:00 AM',
    this.endTime = '06:00 PM',
    this.isFullDay = true,
  });
}

class LabourProfile {
  final String id;
  final String legalName;
  final String alias;
  final String phone;
  final TradeType trade;
  final List<String> secondarySkills;
  final int experienceYears;
  final double rating;
  final int totalReviews;
  final int completedJobs;
  final double punctualityScore;
  final double dailyRate;
  final double sqftRate;
  final double overtimeHourlyRate;
  final String city;
  final String zone;
  final double distanceKm;
  final KycStatus kycStatus;
  final LabourStatus labourStatus;
  final String aadhaarMasked;
  final String policeVerificationNo;
  final String photoUrl;
  final String emergencyContact;
  final String emergencyPhone;
  final List<String> skillBadges;
  final String currentSiteAssigned;
  final double walletBalance;

  // Extended Specification Fields
  final String displayName;
  final String altPhone;
  final String email;
  final String gender;
  final String address;
  final String state;
  final String pincode;
  final List<String> operatingAreas;
  final double preferredRadiusKm;
  final String emergencyRelationship;
  final SkillLevel skillLevel;
  final RateUnit rateUnit;
  final double minJobAmount;
  final double travelCharge;
  final bool isNegotiable;
  final ExtendedLabourStatus extendedStatus;
  final double onTimePercentage;
  final double qualityScore;
  final double behaviourScore;
  final double reliabilityScore;
  final int activeJobsCount;
  final int disputeCount;
  final int strikesCount;
  final DateTime? onboardingDate;
  final String lastActivity;

  const LabourProfile({
    required this.id,
    required this.legalName,
    required this.alias,
    required this.phone,
    required this.trade,
    this.secondarySkills = const [],
    required this.experienceYears,
    required this.rating,
    required this.totalReviews,
    required this.completedJobs,
    required this.punctualityScore,
    required this.dailyRate,
    required this.sqftRate,
    required this.overtimeHourlyRate,
    required this.city,
    required this.zone,
    required this.distanceKm,
    required this.kycStatus,
    required this.labourStatus,
    required this.aadhaarMasked,
    required this.policeVerificationNo,
    required this.photoUrl,
    required this.emergencyContact,
    required this.emergencyPhone,
    this.skillBadges = const [],
    this.currentSiteAssigned = '',
    this.walletBalance = 0.0,
    // Defaults for extended fields
    this.displayName = '',
    this.altPhone = '',
    this.email = '',
    this.gender = 'Male',
    this.address = '',
    this.state = 'Karnataka',
    this.pincode = '560001',
    this.operatingAreas = const [],
    this.preferredRadiusKm = 15.0,
    this.emergencyRelationship = 'Spouse',
    this.skillLevel = SkillLevel.skilled,
    this.rateUnit = RateUnit.perDay,
    this.minJobAmount = 500.0,
    this.travelCharge = 150.0,
    this.isNegotiable = false,
    this.extendedStatus = ExtendedLabourStatus.active,
    this.onTimePercentage = 95.0,
    this.qualityScore = 4.8,
    this.behaviourScore = 4.7,
    this.reliabilityScore = 4.9,
    this.activeJobsCount = 0,
    this.disputeCount = 0,
    this.strikesCount = 0,
    this.onboardingDate,
    this.lastActivity = 'Active 10 mins ago',
  });

  LabourProfile copyWith({
    String? id,
    String? legalName,
    String? alias,
    String? phone,
    TradeType? trade,
    List<String>? secondarySkills,
    int? experienceYears,
    double? rating,
    int? totalReviews,
    int? completedJobs,
    double? punctualityScore,
    double? dailyRate,
    double? sqftRate,
    double? overtimeHourlyRate,
    String? city,
    String? zone,
    double? distanceKm,
    KycStatus? kycStatus,
    LabourStatus? labourStatus,
    String? aadhaarMasked,
    String? policeVerificationNo,
    String? photoUrl,
    String? emergencyContact,
    String? emergencyPhone,
    List<String>? skillBadges,
    String? currentSiteAssigned,
    double? walletBalance,
    String? displayName,
    String? altPhone,
    String? email,
    String? gender,
    String? address,
    String? state,
    String? pincode,
    List<String>? operatingAreas,
    double? preferredRadiusKm,
    String? emergencyRelationship,
    SkillLevel? skillLevel,
    RateUnit? rateUnit,
    double? minJobAmount,
    double? travelCharge,
    bool? isNegotiable,
    ExtendedLabourStatus? extendedStatus,
    double? onTimePercentage,
    double? qualityScore,
    double? behaviourScore,
    double? reliabilityScore,
    int? activeJobsCount,
    int? disputeCount,
    int? strikesCount,
    DateTime? onboardingDate,
    String? lastActivity,
  }) {
    return LabourProfile(
      id: id ?? this.id,
      legalName: legalName ?? this.legalName,
      alias: alias ?? this.alias,
      phone: phone ?? this.phone,
      trade: trade ?? this.trade,
      secondarySkills: secondarySkills ?? this.secondarySkills,
      experienceYears: experienceYears ?? this.experienceYears,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      completedJobs: completedJobs ?? this.completedJobs,
      punctualityScore: punctualityScore ?? this.punctualityScore,
      dailyRate: dailyRate ?? this.dailyRate,
      sqftRate: sqftRate ?? this.sqftRate,
      overtimeHourlyRate: overtimeHourlyRate ?? this.overtimeHourlyRate,
      city: city ?? this.city,
      zone: zone ?? this.zone,
      distanceKm: distanceKm ?? this.distanceKm,
      kycStatus: kycStatus ?? this.kycStatus,
      labourStatus: labourStatus ?? this.labourStatus,
      aadhaarMasked: aadhaarMasked ?? this.aadhaarMasked,
      policeVerificationNo: policeVerificationNo ?? this.policeVerificationNo,
      photoUrl: photoUrl ?? this.photoUrl,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      skillBadges: skillBadges ?? this.skillBadges,
      currentSiteAssigned: currentSiteAssigned ?? this.currentSiteAssigned,
      walletBalance: walletBalance ?? this.walletBalance,
      displayName: displayName ?? this.displayName,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      operatingAreas: operatingAreas ?? this.operatingAreas,
      preferredRadiusKm: preferredRadiusKm ?? this.preferredRadiusKm,
      emergencyRelationship: emergencyRelationship ?? this.emergencyRelationship,
      skillLevel: skillLevel ?? this.skillLevel,
      rateUnit: rateUnit ?? this.rateUnit,
      minJobAmount: minJobAmount ?? this.minJobAmount,
      travelCharge: travelCharge ?? this.travelCharge,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      extendedStatus: extendedStatus ?? this.extendedStatus,
      onTimePercentage: onTimePercentage ?? this.onTimePercentage,
      qualityScore: qualityScore ?? this.qualityScore,
      behaviourScore: behaviourScore ?? this.behaviourScore,
      reliabilityScore: reliabilityScore ?? this.reliabilityScore,
      activeJobsCount: activeJobsCount ?? this.activeJobsCount,
      disputeCount: disputeCount ?? this.disputeCount,
      strikesCount: strikesCount ?? this.strikesCount,
      onboardingDate: onboardingDate ?? this.onboardingDate,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}

class KycAuditEntry {
  final String id;
  final String action;
  final String actor;
  final DateTime timestamp;
  final String previousStatus;
  final String newStatus;
  final String reason;
  final String notes;

  const KycAuditEntry({
    required this.id,
    required this.action,
    required this.actor,
    required this.timestamp,
    required this.previousStatus,
    required this.newStatus,
    this.reason = '',
    this.notes = '',
  });
}

class LabourKycDocument {
  final String id;
  final String workerId;
  final String workerName;
  final String aadhaarNumber;
  final String aadhaarDocUrl;
  final String selfiePhotoUrl;
  final String policeClearanceUrl;
  final String policeStationName;
  final String bankAccountNo;
  final String ifscCode;
  final String accountHolderName;
  final String upiId;
  final double tradeTestScore;
  final String tradeGrade;
  final String riskLevel;
  final String verificationNotes;
  final DateTime submissionDate;
  final DateTime? verifiedAt;
  final String verifiedByAdmin;
  final KycStatus status;
  final String rejectionReason;
  final String correctionRequiredAction;
  final List<KycAuditEntry> auditTrail;

  const LabourKycDocument({
    required this.id,
    required this.workerId,
    required this.workerName,
    required this.aadhaarNumber,
    required this.aadhaarDocUrl,
    required this.selfiePhotoUrl,
    required this.policeClearanceUrl,
    required this.policeStationName,
    required this.bankAccountNo,
    required this.ifscCode,
    required this.accountHolderName,
    required this.upiId,
    required this.tradeTestScore,
    required this.tradeGrade,
    required this.riskLevel,
    required this.verificationNotes,
    required this.submissionDate,
    this.verifiedAt,
    required this.verifiedByAdmin,
    required this.status,
    this.rejectionReason = '',
    this.correctionRequiredAction = '',
    this.auditTrail = const [],
  });

  LabourKycDocument copyWith({
    String? id,
    String? workerId,
    String? workerName,
    String? aadhaarNumber,
    String? aadhaarDocUrl,
    String? selfiePhotoUrl,
    String? policeClearanceUrl,
    String? policeStationName,
    String? bankAccountNo,
    String? ifscCode,
    String? accountHolderName,
    String? upiId,
    double? tradeTestScore,
    String? tradeGrade,
    String? riskLevel,
    String? verificationNotes,
    DateTime? submissionDate,
    DateTime? verifiedAt,
    String? verifiedByAdmin,
    KycStatus? status,
    String? rejectionReason,
    String? correctionRequiredAction,
    List<KycAuditEntry>? auditTrail,
  }) {
    return LabourKycDocument(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      aadhaarDocUrl: aadhaarDocUrl ?? this.aadhaarDocUrl,
      selfiePhotoUrl: selfiePhotoUrl ?? this.selfiePhotoUrl,
      policeClearanceUrl: policeClearanceUrl ?? this.policeClearanceUrl,
      policeStationName: policeStationName ?? this.policeStationName,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      ifscCode: ifscCode ?? this.ifscCode,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      upiId: upiId ?? this.upiId,
      tradeTestScore: tradeTestScore ?? this.tradeTestScore,
      tradeGrade: tradeGrade ?? this.tradeGrade,
      riskLevel: riskLevel ?? this.riskLevel,
      verificationNotes: verificationNotes ?? this.verificationNotes,
      submissionDate: submissionDate ?? this.submissionDate,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verifiedByAdmin: verifiedByAdmin ?? this.verifiedByAdmin,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      correctionRequiredAction: correctionRequiredAction ?? this.correctionRequiredAction,
      auditTrail: auditTrail ?? this.auditTrail,
    );
  }
}

class DailyChecklistItem {
  final String id;
  final String title;
  final bool isCompleted;
  final String? notes;

  const DailyChecklistItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.notes,
  });

  DailyChecklistItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? notes,
  }) {
    return DailyChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}

class JobCheckInRecord {
  final String id;
  final String jobId;
  final String workerId;
  final String workerName;
  final DateTime checkInTime;
  final double latitude;
  final double longitude;
  final String address;
  final String selfiePhotoUrl;
  final String deviceInfo;
  final bool isApproved;

  const JobCheckInRecord({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.workerName,
    required this.checkInTime,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.selfiePhotoUrl,
    this.deviceInfo = 'OnePlus Nord Android 14 (Field App)',
    this.isApproved = true,
  });
}

class DailyWorkUpdate {
  final String id;
  final String jobId;
  final DateTime workDate;
  final double hoursWorked;
  final String workCompleted;
  final String workRemaining;
  final double progressPercentage;
  final String blockers;
  final String materialRequirements;
  final List<String> photoUrls;
  final String submittedBy;
  final DateTime submittedAt;

  const DailyWorkUpdate({
    required this.id,
    required this.jobId,
    required this.workDate,
    required this.hoursWorked,
    required this.workCompleted,
    required this.workRemaining,
    required this.progressPercentage,
    this.blockers = '',
    this.materialRequirements = '',
    this.photoUrls = const [],
    required this.submittedBy,
    required this.submittedAt,
  });
}

class WorkVerificationRecord {
  final String id;
  final String jobId;
  final String supervisorName;
  final String status; // 'Approved', 'Correction Required', 'Rejected'
  final String assessmentNotes;
  final String correctionInstructions;
  final int correctionCycleCount;
  final DateTime verifiedAt;
  final double qualityScore;

  const WorkVerificationRecord({
    required this.id,
    required this.jobId,
    required this.supervisorName,
    required this.status,
    required this.assessmentNotes,
    this.correctionInstructions = '',
    this.correctionCycleCount = 0,
    required this.verifiedAt,
    this.qualityScore = 5.0,
  });
}

class ReassignmentRecord {
  final String id;
  final String jobId;
  final String previousWorkerId;
  final String previousWorkerName;
  final String replacementWorkerId;
  final String replacementWorkerName;
  final String reason;
  final String workCompletedBefore;
  final String outstandingWork;
  final double additionalCost;
  final String approvedBy;
  final DateTime timestamp;

  const ReassignmentRecord({
    required this.id,
    required this.jobId,
    required this.previousWorkerId,
    required this.previousWorkerName,
    required this.replacementWorkerId,
    required this.replacementWorkerName,
    required this.reason,
    required this.workCompletedBefore,
    required this.outstandingWork,
    this.additionalCost = 0.0,
    required this.approvedBy,
    required this.timestamp,
  });
}

class ServiceBooking {
  final String id;
  final String bookingNumber;
  final String projectId;
  final String projectName;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String supervisorId;
  final String supervisorName;
  final String tradesmanId;
  final String tradesmanName;
  final String tradesmanPhone;
  final TradeType trade;
  final SkillLevel skillLevel;
  final String scopeDescription;
  final int tradesmenCount;
  final double dealValue;
  final double advancePaid;
  final double balanceDue;
  final double platformCommission;
  final BookingStatus status;
  final ActiveJobStatus activeJobStatus;
  final DateTime startDate;
  final DateTime endDate;
  final String siteLocation;
  final String gpsCheckInStamp;
  final List<DailyChecklistItem> dailyChecklist;
  final List<String> sitePhotos;
  final double? clientRating;
  final double? workerRating;
  final bool termsAccepted;
  final String autoReassignTimer;
  final String supervisorSignOffName;

  // Work specification & Field progress
  final String workTitle;
  final String expectedOutput;
  final String siteInstructions;
  final String qualityRequirements;
  final String materialResponsibility;
  final double progressPercent;
  final bool isDelayed;
  final int delayDays;
  final String delayReason;
  final JobCheckInRecord? checkInRecord;
  final List<DailyWorkUpdate> dailyUpdates;
  final WorkVerificationRecord? workVerification;
  final List<ReassignmentRecord> reassignmentHistory;

  const ServiceBooking({
    required this.id,
    required this.bookingNumber,
    required this.projectId,
    required this.projectName,
    required this.clientId,
    required this.clientName,
    this.clientPhone = '+91 98450 12345',
    required this.supervisorId,
    required this.supervisorName,
    required this.tradesmanId,
    required this.tradesmanName,
    required this.tradesmanPhone,
    required this.trade,
    this.skillLevel = SkillLevel.skilled,
    required this.scopeDescription,
    this.tradesmenCount = 1,
    required this.dealValue,
    required this.advancePaid,
    required this.balanceDue,
    required this.platformCommission,
    required this.status,
    this.activeJobStatus = ActiveJobStatus.workStarted,
    required this.startDate,
    required this.endDate,
    required this.siteLocation,
    required this.gpsCheckInStamp,
    this.dailyChecklist = const [],
    this.sitePhotos = const [],
    this.clientRating,
    this.workerRating,
    this.termsAccepted = true,
    this.autoReassignTimer = '15:00',
    this.supervisorSignOffName = '',
    this.workTitle = 'Skilled Trade Service Work',
    this.expectedOutput = 'Finish according to approved architectural drawing',
    this.siteInstructions = 'Wear safety helmet & boots at all times on site',
    this.qualityRequirements = 'Surface smoothness and joint precision +/- 1mm',
    this.materialResponsibility = 'Contractor provides tools; Homio provides plywood & laminate',
    this.progressPercent = 65.0,
    this.isDelayed = false,
    this.delayDays = 0,
    this.delayReason = '',
    this.checkInRecord,
    this.dailyUpdates = const [],
    this.workVerification,
    this.reassignmentHistory = const [],
  });

  ServiceBooking copyWith({
    String? id,
    String? bookingNumber,
    String? projectId,
    String? projectName,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? supervisorId,
    String? supervisorName,
    String? tradesmanId,
    String? tradesmanName,
    String? tradesmanPhone,
    TradeType? trade,
    SkillLevel? skillLevel,
    String? scopeDescription,
    int? tradesmenCount,
    double? dealValue,
    double? advancePaid,
    double? balanceDue,
    double? platformCommission,
    BookingStatus? status,
    ActiveJobStatus? activeJobStatus,
    DateTime? startDate,
    DateTime? endDate,
    String? siteLocation,
    String? gpsCheckInStamp,
    List<DailyChecklistItem>? dailyChecklist,
    List<String>? sitePhotos,
    double? clientRating,
    double? workerRating,
    bool? termsAccepted,
    String? autoReassignTimer,
    String? supervisorSignOffName,
    String? workTitle,
    String? expectedOutput,
    String? siteInstructions,
    String? qualityRequirements,
    String? materialResponsibility,
    double? progressPercent,
    bool? isDelayed,
    int? delayDays,
    String? delayReason,
    JobCheckInRecord? checkInRecord,
    List<DailyWorkUpdate>? dailyUpdates,
    WorkVerificationRecord? workVerification,
    List<ReassignmentRecord>? reassignmentHistory,
  }) {
    return ServiceBooking(
      id: id ?? this.id,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      supervisorId: supervisorId ?? this.supervisorId,
      supervisorName: supervisorName ?? this.supervisorName,
      tradesmanId: tradesmanId ?? this.tradesmanId,
      tradesmanName: tradesmanName ?? this.tradesmanName,
      tradesmanPhone: tradesmanPhone ?? this.tradesmanPhone,
      trade: trade ?? this.trade,
      skillLevel: skillLevel ?? this.skillLevel,
      scopeDescription: scopeDescription ?? this.scopeDescription,
      tradesmenCount: tradesmenCount ?? this.tradesmenCount,
      dealValue: dealValue ?? this.dealValue,
      advancePaid: advancePaid ?? this.advancePaid,
      balanceDue: balanceDue ?? this.balanceDue,
      platformCommission: platformCommission ?? this.platformCommission,
      status: status ?? this.status,
      activeJobStatus: activeJobStatus ?? this.activeJobStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      siteLocation: siteLocation ?? this.siteLocation,
      gpsCheckInStamp: gpsCheckInStamp ?? this.gpsCheckInStamp,
      dailyChecklist: dailyChecklist ?? this.dailyChecklist,
      sitePhotos: sitePhotos ?? this.sitePhotos,
      clientRating: clientRating ?? this.clientRating,
      workerRating: workerRating ?? this.workerRating,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      autoReassignTimer: autoReassignTimer ?? this.autoReassignTimer,
      supervisorSignOffName: supervisorSignOffName ?? this.supervisorSignOffName,
      workTitle: workTitle ?? this.workTitle,
      expectedOutput: expectedOutput ?? this.expectedOutput,
      siteInstructions: siteInstructions ?? this.siteInstructions,
      qualityRequirements: qualityRequirements ?? this.qualityRequirements,
      materialResponsibility: materialResponsibility ?? this.materialResponsibility,
      progressPercent: progressPercent ?? this.progressPercent,
      isDelayed: isDelayed ?? this.isDelayed,
      delayDays: delayDays ?? this.delayDays,
      delayReason: delayReason ?? this.delayReason,
      checkInRecord: checkInRecord ?? this.checkInRecord,
      dailyUpdates: dailyUpdates ?? this.dailyUpdates,
      workVerification: workVerification ?? this.workVerification,
      reassignmentHistory: reassignmentHistory ?? this.reassignmentHistory,
    );
  }
}

// -----------------------------------------------------------------------------
// PAYMENTS, RATINGS & DISPUTE ENTITIES
// -----------------------------------------------------------------------------

class LabourPaymentRecord {
  final String id;
  final String bookingId;
  final String bookingNumber;
  final String workerId;
  final String workerName;
  final String clientName;
  final String projectName;
  final String workDescription;
  final String billingPeriod;
  final double grossAmount;
  final double deductions;
  final double adjustments;
  final double platformCommission;
  final double netPayable;
  final double amountPaid;
  final double amountDue;
  final DateTime paymentDate;
  final String paymentMethod;
  final String transactionRef;
  final String status; // 'Paid', 'Pending Approval', 'Processing', 'Settled'
  final String remarks;

  const LabourPaymentRecord({
    required this.id,
    required this.bookingId,
    required this.bookingNumber,
    required this.workerId,
    required this.workerName,
    required this.clientName,
    required this.projectName,
    required this.workDescription,
    required this.billingPeriod,
    required this.grossAmount,
    this.deductions = 0.0,
    this.adjustments = 0.0,
    required this.platformCommission,
    required this.netPayable,
    required this.amountPaid,
    required this.amountDue,
    required this.paymentDate,
    this.paymentMethod = 'IMPS / Direct Bank Transfer',
    required this.transactionRef,
    required this.status,
    this.remarks = 'Weekly labour settlement',
  });
}

class PaymentClaim {
  final String id;
  final String bookingId;
  final String bookingNumber;
  final String workerId;
  final String workerName;
  final String workSummary;
  final String billingPeriod;
  final double amountClaimed;
  final String invoiceDocumentUrl;
  final String status; // 'Submitted', 'Under Review', 'Approved', 'Paid'
  final DateTime submittedDate;
  final String supervisorConfirmation;

  const PaymentClaim({
    required this.id,
    required this.bookingId,
    required this.bookingNumber,
    required this.workerId,
    required this.workerName,
    required this.workSummary,
    required this.billingPeriod,
    required this.amountClaimed,
    this.invoiceDocumentUrl = 'https://homio.app/docs/claim_invoice.pdf',
    required this.status,
    required this.submittedDate,
    required this.supervisorConfirmation,
  });
}

class LabourRatingRecord {
  final String id;
  final String bookingId;
  final String bookingNumber;
  final String workerId;
  final String workerName;
  final TradeType trade;
  final String reviewerName;
  final String reviewerRole; // 'Customer', 'Site Supervisor', 'Service Manager'
  final double qualityScore;
  final double timelineScore;
  final double behaviourScore;
  final double reliabilityScore;
  final double overallScore;
  final String reviewNotes;
  final DateTime date;
  final bool isAlertTriggered;

  const LabourRatingRecord({
    required this.id,
    required this.bookingId,
    required this.bookingNumber,
    required this.workerId,
    required this.workerName,
    required this.trade,
    required this.reviewerName,
    required this.reviewerRole,
    required this.qualityScore,
    required this.timelineScore,
    required this.behaviourScore,
    required this.reliabilityScore,
    required this.overallScore,
    required this.reviewNotes,
    required this.date,
    this.isAlertTriggered = false,
  });
}

class DisputeCase {
  final String id;
  final String caseNumber;
  final String bookingId;
  final String projectId;
  final String projectName;
  final String initiator;
  final String respondent;
  final DisputeScenario disputeType;
  final double amountInDispute;
  final DateTime dateFiled;
  final String assignedLawyerName;
  final String lawyerBarCouncilNo;
  final String courtJurisdiction;
  final DisputeLegalStatus legalStatus;
  final String evidenceDossierUrl;
  final int strikesCount;
  final bool replacementDispatched;
  final String resolutionSummary;
  final List<String> auditTrail;
  final bool isClientBlacklisted;
  final bool isLabourBlacklisted;
  final String nextHearingDate;
  final String statutoryNoticeRef;

  const DisputeCase({
    required this.id,
    required this.caseNumber,
    required this.bookingId,
    required this.projectId,
    required this.projectName,
    required this.initiator,
    required this.respondent,
    required this.disputeType,
    required this.amountInDispute,
    required this.dateFiled,
    required this.assignedLawyerName,
    required this.lawyerBarCouncilNo,
    required this.courtJurisdiction,
    required this.legalStatus,
    required this.evidenceDossierUrl,
    this.strikesCount = 0,
    this.replacementDispatched = false,
    required this.resolutionSummary,
    this.auditTrail = const [],
    this.isClientBlacklisted = false,
    this.isLabourBlacklisted = false,
    this.nextHearingDate = '24 Sep 2026',
    this.statutoryNoticeRef = 'NOT/2026/LEG/8812',
  });

  DisputeCase copyWith({
    String? id,
    String? caseNumber,
    String? bookingId,
    String? projectId,
    String? projectName,
    String? initiator,
    String? respondent,
    DisputeScenario? disputeType,
    double? amountInDispute,
    DateTime? dateFiled,
    String? assignedLawyerName,
    String? lawyerBarCouncilNo,
    String? courtJurisdiction,
    DisputeLegalStatus? legalStatus,
    String? evidenceDossierUrl,
    int? strikesCount,
    bool? replacementDispatched,
    String? resolutionSummary,
    List<String>? auditTrail,
    bool? isClientBlacklisted,
    bool? isLabourBlacklisted,
    String? nextHearingDate,
    String? statutoryNoticeRef,
  }) {
    return DisputeCase(
      id: id ?? this.id,
      caseNumber: caseNumber ?? this.caseNumber,
      bookingId: bookingId ?? this.bookingId,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      initiator: initiator ?? this.initiator,
      respondent: respondent ?? this.respondent,
      disputeType: disputeType ?? this.disputeType,
      amountInDispute: amountInDispute ?? this.amountInDispute,
      dateFiled: dateFiled ?? this.dateFiled,
      assignedLawyerName: assignedLawyerName ?? this.assignedLawyerName,
      lawyerBarCouncilNo: lawyerBarCouncilNo ?? this.lawyerBarCouncilNo,
      courtJurisdiction: courtJurisdiction ?? this.courtJurisdiction,
      legalStatus: legalStatus ?? this.legalStatus,
      evidenceDossierUrl: evidenceDossierUrl ?? this.evidenceDossierUrl,
      strikesCount: strikesCount ?? this.strikesCount,
      replacementDispatched: replacementDispatched ?? this.replacementDispatched,
      resolutionSummary: resolutionSummary ?? this.resolutionSummary,
      auditTrail: auditTrail ?? this.auditTrail,
      isClientBlacklisted: isClientBlacklisted ?? this.isClientBlacklisted,
      isLabourBlacklisted: isLabourBlacklisted ?? this.isLabourBlacklisted,
      nextHearingDate: nextHearingDate ?? this.nextHearingDate,
      statutoryNoticeRef: statutoryNoticeRef ?? this.statutoryNoticeRef,
    );
  }
}

class PanelLawyer {
  final String id;
  final String name;
  final String barCouncilNo;
  final String specialization;
  final String courtJurisdiction;
  final int activeCases;
  final String phone;
  final String email;
  final double rating;

  const PanelLawyer({
    required this.id,
    required this.name,
    required this.barCouncilNo,
    required this.specialization,
    required this.courtJurisdiction,
    required this.activeCases,
    required this.phone,
    required this.email,
    required this.rating,
  });
}

class BlacklistRecord {
  final String id;
  final String entityName;
  final String entityType; // 'CLIENT' or 'LABOUR'
  final String reason;
  final String identifier; // Aadhaar / Phone
  final DateTime blacklistedAt;
  final String lockedByAdmin;
  final double defaultAmount;

  const BlacklistRecord({
    required this.id,
    required this.entityName,
    required this.entityType,
    required this.reason,
    required this.identifier,
    required this.blacklistedAt,
    required this.lockedByAdmin,
    required this.defaultAmount,
  });
}
