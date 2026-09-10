import 'package:flutter/material.dart';
import '../models/ai_suite_models.dart';
import '../models/ai_suite_mock_data.dart';

class AiSuiteRepository extends ChangeNotifier {
  static final AiSuiteRepository instance = AiSuiteRepository._internal();
  AiSuiteRepository._internal();

  int totalCredits = 685;
  int freeDoubtQueriesRemaining = 3;
  AiCommercialConfig commercialConfig = AiSuiteMockData.defaultCommercialConfig;

  final List<AiJobEntity> jobs = List.from(AiSuiteMockData.initialJobs);
  final List<WalletTransaction> transactions = List.from(AiSuiteMockData.walletTransactions);
  final List<CreditPackage> packages = List.from(AiSuiteMockData.creditPackages);
  final List<AiAuditRecord> auditRecords = List.from(AiSuiteMockData.auditRecords);
  final List<AiRoomDesignEntity> roomDesigns = List.from(AiSuiteMockData.mockRoomDesigns);
  final List<AiVastuReportEntity> vastuReports = List.from(AiSuiteMockData.mockVastuReports);
  final List<AiBudgetEstimateEntity> budgetEstimates = List.from(AiSuiteMockData.mockBudgetEstimates);
  final List<AiDoubtConversationEntity> doubtConversations = List.from(AiSuiteMockData.mockDoubtConversations);
  final List<DesignerProfile> designers = List.from(AiSuiteMockData.mockDesigners);
  final List<ConsultationBookingEntity> consultations = List.from(AiSuiteMockData.mockConsultations);

  // Computed Financials & Operational KPIs
  double get totalGrossRevenue => transactions
      .where((t) => t.type == WalletTransactionType.purchase || t.type == WalletTransactionType.consultationDebit)
      .fold(0.0, (acc, t) => acc + t.rupeeAmount);

  double get platformNetShare => transactions
      .fold(0.0, (acc, t) => acc + (t.platformShare > 0 ? t.platformShare : (t.type == WalletTransactionType.purchase ? t.rupeeAmount : 0.0)));

  double get designerPayouts => transactions
      .fold(0.0, (acc, t) => acc + t.designerShare);

  int get creditsSold => transactions
      .where((t) => t.type == WalletTransactionType.purchase)
      .fold(0, (acc, t) => acc + t.credits);

  int get creditsConsumed => transactions
      .where((t) => t.credits < 0)
      .fold(0, (acc, t) => acc + t.credits.abs());

  double get jobSuccessRate {
    if (jobs.isEmpty) return 100.0;
    final successful = jobs.where((j) => j.status == AiJobStatus.completed).length;
    return (successful / jobs.length) * 100.0;
  }

  int get pendingFailedJobsCount => jobs.where((j) => j.status == AiJobStatus.failed).length;

  List<CreditPackage> get creditPackages => packages;

  // ==========================================================================
  // CREDITS & WALLET METHODS
  // ==========================================================================

  void purchaseCredits(CreditPackage package, {String? couponCode, String? paymentMethod}) {
    final bonus = couponCode?.trim().toUpperCase() == 'HOMIOAI20'
        ? (package.totalCredits * 0.2).round()
        : package.bonusCredits;
    final awarded = package.credits + bonus;

    totalCredits += awarded;
    final txn = WalletTransaction(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      date: DateTime.now(),
      title: '${package.title} Recharge (+$awarded Credits)',
      type: WalletTransactionType.purchase,
      credits: awarded,
      rupeeAmount: package.price,
      referenceId: 'GATEWAY_${DateTime.now().millisecondsSinceEpoch}',
      clientName: 'Rahul Sharma',
    );
    transactions.insert(0, txn);

    auditRecords.insert(
      0,
      AiAuditRecord(
        id: 'AUD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        action: 'Credit Purchase',
        user: 'Rahul Sharma',
        entity: 'AiWallet',
        previousValue: '${totalCredits - awarded} Credits',
        newValue: '$totalCredits Credits',
        timestamp: DateTime.now(),
        reason: 'Online top-up via checkout (${package.title})',
      ),
    );

    notifyListeners();
  }

  bool deductCredits({
    required int amount,
    required String title,
    required String referenceId,
    required WalletTransactionType type,
    double rupeeEquivalent = 0.0,
    String? designerName,
    double platformShare = 0.0,
    double designerShare = 0.0,
  }) {
    if (totalCredits < amount) return false;
    totalCredits -= amount;

    final txn = WalletTransaction(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      date: DateTime.now(),
      title: title,
      type: type,
      credits: -amount,
      rupeeAmount: rupeeEquivalent,
      referenceId: referenceId,
      clientName: 'Rahul Sharma',
      designerName: designerName,
      platformShare: platformShare,
      designerShare: designerShare,
    );
    transactions.insert(0, txn);

    notifyListeners();
    return true;
  }

  bool useFreeDoubtQuery() {
    if (freeDoubtQueriesRemaining > 0) {
      freeDoubtQueriesRemaining--;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ==========================================================================
  // JOBS QUEUE & TRIAGE METHODS
  // ==========================================================================

  AiJobEntity enqueueJob({
    required String productType,
    required String title,
    required String prompt,
    required int creditsCharged,
  }) {
    final job = AiJobEntity(
      id: 'JOB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      productType: productType,
      title: title,
      user: 'Rahul Sharma',
      createdAt: DateTime.now(),
      startedAt: DateTime.now(),
      status: AiJobStatus.processing,
      creditsCharged: creditsCharged,
      prompt: prompt,
    );
    jobs.insert(0, job);

    // Simulate fast processing -> completed
    Future.delayed(const Duration(seconds: 3), () {
      job.status = AiJobStatus.completed;
      job.completedAt = DateTime.now();
      notifyListeners();
    });

    notifyListeners();
    return job;
  }

  void retryJob(String jobId) {
    final job = jobs.firstWhere((j) => j.id == jobId);
    job.status = AiJobStatus.processing;
    job.startedAt = DateTime.now();
    job.failureReason = null;
    job.retryCount++;

    auditRecords.insert(
      0,
      AiAuditRecord(
        id: 'AUD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        action: 'Job Manual Retry',
        user: 'Operations Admin',
        entity: jobId,
        previousValue: 'Failed',
        newValue: 'Queued for Re-run',
        timestamp: DateTime.now(),
        reason: 'Admin initiated manual retry from Failed Jobs triage desk',
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      job.status = AiJobStatus.completed;
      job.completedAt = DateTime.now();
      notifyListeners();
    });

    notifyListeners();
  }

  void refundFailedJob({
    required String jobId,
    required String reason,
    String? adminUser,
    String? actorEmail,
  }) {
    final effectiveUser = adminUser ?? actorEmail ?? 'Operations Admin';
    final job = jobs.firstWhere((j) => j.id == jobId);
    job.status = AiJobStatus.refunded;
    totalCredits += job.creditsCharged;

    final txn = WalletTransaction(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      date: DateTime.now(),
      title: 'Refund for Failed Job $jobId',
      type: WalletTransactionType.refund,
      credits: job.creditsCharged,
      rupeeAmount: job.creditsCharged * 5.0,
      referenceId: jobId,
      clientName: job.user,
    );
    transactions.insert(0, txn);

    auditRecords.insert(
      0,
      AiAuditRecord(
        id: 'AUD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        action: 'Credit Refund Issued',
        user: effectiveUser,
        entity: jobId,
        previousValue: '${totalCredits - job.creditsCharged} Credits',
        newValue: '$totalCredits Credits (+${job.creditsCharged})',
        timestamp: DateTime.now(),
        reason: reason,
      ),
    );

    notifyListeners();
  }

  // ==========================================================================
  // ROOM DESIGNER CRUD
  // ==========================================================================

  void saveRoomDesign(AiRoomDesignEntity design) {
    final index = roomDesigns.indexWhere((d) => d.id == design.id);
    if (index >= 0) {
      roomDesigns[index] = design;
    } else {
      roomDesigns.insert(0, design);
    }
    notifyListeners();
  }

  void deleteRoomDesign(String id) {
    roomDesigns.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  AiRoomDesignEntity createRoomDesignVariation(String id) {
    final parent = roomDesigns.firstWhere((d) => d.id == id);
    final variation = parent.copyWith(
      id: 'DES-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: '${parent.title} (Variation B)',
      createdAt: DateTime.now(),
    );
    roomDesigns.insert(0, variation);
    notifyListeners();
    return variation;
  }

  // ==========================================================================
  // VASTU REPORTS CRUD
  // ==========================================================================

  void saveVastuReport(AiVastuReportEntity report) {
    vastuReports.insert(0, report);
    notifyListeners();
  }

  // ==========================================================================
  // BUDGET ESTIMATES CRUD
  // ==========================================================================

  void saveBudgetEstimate(AiBudgetEstimateEntity estimate) {
    budgetEstimates.insert(0, estimate);
    notifyListeners();
  }

  // ==========================================================================
  // DOUBT SOLVER CHAT
  // ==========================================================================

  void addDoubtMessage({
    required String conversationId,
    required String userQuestion,
    required String aiAnswer,
    List<String>? sources,
    List<String>? followUpChips,
    bool isPaid = false,
    double fee = 0.0,
  }) {
    final conv = doubtConversations.firstWhere((c) => c.id == conversationId);
    final userMsg = AiDoubtMessage(
      id: 'MSG-${DateTime.now().millisecondsSinceEpoch}',
      isUser: true,
      text: userQuestion,
      timestamp: DateTime.now(),
      isPaid: isPaid,
      feeCharged: fee,
    );
    final aiMsg = AiDoubtMessage(
      id: 'MSG-${DateTime.now().millisecondsSinceEpoch + 1}',
      isUser: false,
      text: aiAnswer,
      timestamp: DateTime.now().add(const Duration(seconds: 1)),
      sources: sources,
      followUpChips: followUpChips,
    );

    conv.messages.add(userMsg);
    conv.messages.add(aiMsg);
    notifyListeners();
  }

  AiDoubtConversationEntity startNewDoubtConversation({
    required String title,
    required String projectContext,
    required String roomContext,
  }) {
    final newConv = AiDoubtConversationEntity(
      id: 'CONV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: title,
      projectContext: projectContext,
      roomContext: roomContext,
      updatedAt: DateTime.now(),
      messages: [],
      totalQuestions: 0,
      creditsConsumed: 0,
    );
    doubtConversations.insert(0, newConv);
    notifyListeners();
    return newConv;
  }

  // ==========================================================================
  // DESIGNER CONSULTATIONS
  // ==========================================================================

  ConsultationBookingEntity bookConsultation({
    required DesignerProfile designer,
    required String clientName,
    required String clientPhone,
    required String clientEmail,
    required String projectName,
    required String consultationType,
    required DateTime scheduledDate,
    required String timeSlot,
    required String topic,
    required String description,
    required double fee,
    List<String> attachments = const [],
  }) {
    final platformShare = fee * (commercialConfig.platformRevenueSharePercent / 100.0);
    final designerShare = fee * (commercialConfig.designerRevenueSharePercent / 100.0);

    final booking = ConsultationBookingEntity(
      id: 'CNS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      designer: designer,
      clientName: clientName,
      clientPhone: clientPhone,
      clientEmail: clientEmail,
      projectName: projectName,
      consultationType: consultationType,
      scheduledDate: scheduledDate,
      timeSlot: timeSlot,
      topic: topic,
      description: description,
      fee: fee,
      platformShare: platformShare,
      designerShare: designerShare,
      meetingUrl: 'https://meet.homio.in/cns-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      attachments: attachments,
    );

    consultations.insert(0, booking);

    // Record transaction
    transactions.insert(
      0,
      WalletTransaction(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        date: DateTime.now(),
        title: '30-Min Consultation - ${designer.name}',
        type: WalletTransactionType.consultationDebit,
        credits: 0,
        rupeeAmount: fee,
        referenceId: booking.id,
        clientName: clientName,
        designerName: designer.name,
        platformShare: platformShare,
        designerShare: designerShare,
      ),
    );

    auditRecords.insert(
      0,
      AiAuditRecord(
        id: 'AUD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        action: 'Consultation Booked',
        user: clientName,
        entity: booking.id,
        previousValue: 'None',
        newValue: 'Booked ₹$fee (50/50 Split)',
        timestamp: DateTime.now(),
        reason: 'Client scheduled video consultation with ${designer.name}',
      ),
    );

    notifyListeners();
    return booking;
  }

  void submitConsultationFeedback({
    required String bookingId,
    required int rating,
    required String feedback,
  }) {
    final index = consultations.indexWhere((c) => c.id == bookingId);
    if (index >= 0) {
      final old = consultations[index];
      consultations[index] = ConsultationBookingEntity(
        id: old.id,
        designer: old.designer,
        clientName: old.clientName,
        clientPhone: old.clientPhone,
        clientEmail: old.clientEmail,
        projectName: old.projectName,
        consultationType: old.consultationType,
        scheduledDate: old.scheduledDate,
        timeSlot: old.timeSlot,
        durationMinutes: old.durationMinutes,
        topic: old.topic,
        description: old.description,
        fee: old.fee,
        platformShare: old.platformShare,
        designerShare: old.designerShare,
        meetingStatus: 'Completed',
        paymentStatus: old.paymentStatus,
        meetingUrl: old.meetingUrl,
        attachments: old.attachments,
        ratingGiven: rating,
        feedbackText: feedback,
      );
      notifyListeners();
    }
  }

  void rescheduleConsultation({
    required String bookingId,
    required DateTime newDate,
    required String newTimeSlot,
  }) {
    final index = consultations.indexWhere((c) => c.id == bookingId);
    if (index >= 0) {
      final old = consultations[index];
      consultations[index] = ConsultationBookingEntity(
        id: old.id,
        designer: old.designer,
        clientName: old.clientName,
        clientPhone: old.clientPhone,
        clientEmail: old.clientEmail,
        projectName: old.projectName,
        consultationType: old.consultationType,
        scheduledDate: newDate,
        timeSlot: newTimeSlot,
        durationMinutes: old.durationMinutes,
        topic: old.topic,
        description: old.description,
        fee: old.fee,
        platformShare: old.platformShare,
        designerShare: old.designerShare,
        meetingStatus: 'Rescheduled',
        paymentStatus: old.paymentStatus,
        meetingUrl: old.meetingUrl,
        attachments: old.attachments,
      );
      notifyListeners();
    }
  }

  void cancelConsultation({required String bookingId, required String reason}) {
    final index = consultations.indexWhere((c) => c.id == bookingId);
    if (index >= 0) {
      final old = consultations[index];
      consultations[index] = ConsultationBookingEntity(
        id: old.id,
        designer: old.designer,
        clientName: old.clientName,
        clientPhone: old.clientPhone,
        clientEmail: old.clientEmail,
        projectName: old.projectName,
        consultationType: old.consultationType,
        scheduledDate: old.scheduledDate,
        timeSlot: old.timeSlot,
        durationMinutes: old.durationMinutes,
        topic: old.topic,
        description: old.description,
        fee: old.fee,
        platformShare: 0,
        designerShare: 0,
        meetingStatus: 'Cancelled',
        paymentStatus: 'Refunded',
        meetingUrl: old.meetingUrl,
        attachments: old.attachments,
      );

      auditRecords.insert(
        0,
        AiAuditRecord(
          id: 'AUD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          action: 'Consultation Cancelled',
          user: 'Customer Support',
          entity: bookingId,
          previousValue: 'Scheduled',
          newValue: 'Cancelled / Refund Initiated',
          timestamp: DateTime.now(),
          reason: reason,
        ),
      );

      notifyListeners();
    }
  }

  // ==========================================================================
  // COMMERCIAL CONFIG & ADMIN ADJUSTMENTS
  // ==========================================================================

  void updateCommercialConfig(
    AiCommercialConfig newConfig, {
    String? adminUser,
    String? actorEmail,
    required String reason,
  }) {
    final effectiveUser = adminUser ?? actorEmail ?? 'admin@homio.in';
    commercialConfig = newConfig;

    auditRecords.insert(
      0,
      AiAuditRecord(
        id: 'AUD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        action: 'Commercial Rules Update',
        user: effectiveUser,
        entity: 'AiCommercialConfig',
        previousValue: 'Platform: ${commercialConfig.platformRevenueSharePercent}% / Designer: ${commercialConfig.designerRevenueSharePercent}%',
        newValue: 'Platform: ${newConfig.platformRevenueSharePercent}% / Designer: ${newConfig.designerRevenueSharePercent}%',
        timestamp: DateTime.now(),
        reason: reason,
      ),
    );

    notifyListeners();
  }
}
