import 'package:flutter/material.dart';

enum TradeType {
  carpentry,
  masonry,
  electrical,
  plumbing,
  painting,
  popFalseCeiling,
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

enum DisputeScenario {
  clientNonPayment,
  labourAbandonment,
  qualityBreach,
  safetyViolation,
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
    );
  }
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
  });
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

class ServiceBooking {
  final String id;
  final String bookingNumber;
  final String projectId;
  final String projectName;
  final String clientId;
  final String clientName;
  final String supervisorId;
  final String supervisorName;
  final String tradesmanId;
  final String tradesmanName;
  final String tradesmanPhone;
  final TradeType trade;
  final String scopeDescription;
  final int tradesmenCount;
  final double dealValue;
  final double advancePaid;
  final double balanceDue;
  final double platformCommission;
  final BookingStatus status;
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

  const ServiceBooking({
    required this.id,
    required this.bookingNumber,
    required this.projectId,
    required this.projectName,
    required this.clientId,
    required this.clientName,
    required this.supervisorId,
    required this.supervisorName,
    required this.tradesmanId,
    required this.tradesmanName,
    required this.tradesmanPhone,
    required this.trade,
    required this.scopeDescription,
    this.tradesmenCount = 1,
    required this.dealValue,
    required this.advancePaid,
    required this.balanceDue,
    required this.platformCommission,
    required this.status,
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
  });

  ServiceBooking copyWith({
    String? id,
    String? bookingNumber,
    String? projectId,
    String? projectName,
    String? clientId,
    String? clientName,
    String? supervisorId,
    String? supervisorName,
    String? tradesmanId,
    String? tradesmanName,
    String? tradesmanPhone,
    TradeType? trade,
    String? scopeDescription,
    int? tradesmenCount,
    double? dealValue,
    double? advancePaid,
    double? balanceDue,
    double? platformCommission,
    BookingStatus? status,
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
  }) {
    return ServiceBooking(
      id: id ?? this.id,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      supervisorId: supervisorId ?? this.supervisorId,
      supervisorName: supervisorName ?? this.supervisorName,
      tradesmanId: tradesmanId ?? this.tradesmanId,
      tradesmanName: tradesmanName ?? this.tradesmanName,
      tradesmanPhone: tradesmanPhone ?? this.tradesmanPhone,
      trade: trade ?? this.trade,
      scopeDescription: scopeDescription ?? this.scopeDescription,
      tradesmenCount: tradesmenCount ?? this.tradesmenCount,
      dealValue: dealValue ?? this.dealValue,
      advancePaid: advancePaid ?? this.advancePaid,
      balanceDue: balanceDue ?? this.balanceDue,
      platformCommission: platformCommission ?? this.platformCommission,
      status: status ?? this.status,
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
    );
  }
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
