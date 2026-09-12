import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'ai_credit_service.dart';
import 'ai_studio_mock_data.dart';

/// Master orchestration service for HOMIO's AI Studio.
/// Exposes clean reactive streams and methods that interface with backend APIs or mock providers.
class AiStudioService extends ChangeNotifier {
  static final AiStudioService instance = AiStudioService._internal();

  factory AiStudioService() => instance;

  AiStudioService._internal() {
    _init();
  }

  // Active Project Context
  AiProjectContext _projectContext = AiProjectContext.mockDefault();
  AiProjectContext get projectContext => _projectContext;

  void updateProjectContext(AiProjectContext updated) {
    _projectContext = updated;
    notifyListeners();
  }

  // Tool Definitions
  late final List<AiToolDefinition> tools = AiStudioMockData.getToolDefinitions();

  // Materials Specification State
  final List<MaterialSpecificationItem> _materials = [];
  List<MaterialSpecificationItem> get materials => List.unmodifiable(_materials);

  // Vastu Report State
  late VastuAnalysisReport _vastuReport;
  VastuAnalysisReport get vastuReport => _vastuReport;

  // Budget Estimation State
  late BudgetCalculationResult _budgetResult;
  BudgetCalculationResult get budgetResult => _budgetResult;

  // Doubt Solver State
  final List<DoubtQuery> _doubts = [];
  List<DoubtQuery> get doubts => List.unmodifiable(_doubts);

  // Designer Bookings State
  final List<DesignerBooking> _designerBookings = [];
  List<DesignerBooking> get designerBookings => List.unmodifiable(_designerBookings);

  // Saved Designs State
  final List<SavedDesignItem> _savedDesigns = [];
  List<SavedDesignItem> get savedDesigns => List.unmodifiable(_savedDesigns);

  // Unified Generation History
  final List<AiGenerationHistoryItem> _history = [];
  List<AiGenerationHistoryItem> get history => List.unmodifiable(_history);

  void _init() {
    _materials.addAll(AiStudioMockData.getInitialMaterials());
    _vastuReport = AiStudioMockData.getInitialVastuReport();
    _budgetResult = AiStudioMockData.getInitialBudgetEstimate();
    _doubts.addAll(AiStudioMockData.getInitialDoubtQueries());
    _savedDesigns.addAll(AiStudioMockData.getInitialSavedDesigns());
    _history.addAll(AiStudioMockData.getInitialHistory());
  }

  // Material Actions
  void toggleMaterialBOQ(String materialId) {
    final index = _materials.indexWhere((m) => m.id == materialId);
    if (index != -1) {
      final current = _materials[index];
      _materials[index] = current.copyWith(isSavedToProjectBOQ: !current.isSavedToProjectBOQ);
      notifyListeners();
    }
  }

  void addCustomMaterial(MaterialSpecificationItem item) {
    _materials.insert(0, item);
    notifyListeners();
  }

  // Doubt Solver Actions
  Future<DoubtQuery> submitDoubtQuery({
    required DoubtDomain domain,
    required String question,
  }) async {
    // Deduct 1 credit
    AiCreditService.instance.deductCredits(
      amount: 1,
      toolName: 'Civil & Tech Doubt Solver',
      operationTitle: 'Technical Query: ${question.length > 30 ? "${question.substring(0, 30)}..." : question}',
    );

    final newDoubt = DoubtQuery(
      id: 'DBT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      domain: domain,
      question: question,
      aiDetailedAnswer:
          'Based on standard Indian interior execution protocols and NBC (National Building Code 2016):\n\n'
          '1. **Inspection Criteria**: Thoroughly verify surface prep, moisture content (<12% using a digital wood moisture meter), and substrate flatness.\n'
          '2. **Recommended Specification**: Always apply a moisture-resistant balancing laminate (minimum 0.8mm) on the rear face of all engineered panels to prevent bowing.\n'
          '3. **Hardware SLA**: Ensure all hinges are tested to at least 100,000 opening cycles with corrosion-resistant nickel plating.\n\n'
          'Your assigned site engineer and project manager have been tagged with this technical clarification.',
      confidencePercent: 98,
      humanVerifierName: 'Er. Sandeep Menon, Chief MEP Auditor',
      immediateChecklistSteps: [
        'Check physical substrate moisture reading before installation.',
        'Obtain signed warranty certificate from official brand dealer.',
      ],
      standardIndianCodesReferenced: [
        'IS 2046: High-pressure decorative laminates',
        'NBC 2016: Part 6 Structural Design',
      ],
      creditsUsed: 1,
      askedAt: DateTime.now(),
    );

    _doubts.insert(0, newDoubt);

    _history.insert(
      0,
      AiGenerationHistoryItem(
        id: 'HIST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        type: AiArtifactType.technicalDoubt,
        title: question.length > 35 ? '${question.substring(0, 35)}...' : question,
        subtitle: 'Domain: ${domain.title} · Answered with IS code references',
        createdAt: DateTime.now(),
        creditsUsed: 1,
        destinationRoute: '/client/ai-doubt-solver',
      ),
    );

    notifyListeners();
    return newDoubt;
  }

  // Designer Booking Actions
  void bookDesignerSession({
    required ExpertDesignerProfile designer,
    required DateTime scheduledDate,
    required String timeSlot,
    required String roomTopic,
  }) {
    final booking = DesignerBooking(
      id: 'BKG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      designer: designer,
      scheduledDateTime: scheduledDate,
      durationText: '30 Min Live Consultation ($timeSlot)',
      roomTopic: roomTopic,
      status: BookingStatus.confirmed,
      videoMeetingRoomUrl: 'https://meet.homio.ai/room-consult-${designer.id}',
    );

    _designerBookings.insert(0, booking);
    notifyListeners();
  }

  // Saved Designs Actions
  void toggleBookmarkDesign(SavedDesignItem item) {
    final exists = _savedDesigns.any((d) => d.id == item.id);
    if (exists) {
      _savedDesigns.removeWhere((d) => d.id == item.id);
    } else {
      _savedDesigns.insert(0, item);
    }
    notifyListeners();
  }

  void toggleShareWithDesigner(String savedItemId) {
    final index = _savedDesigns.indexWhere((d) => d.id == savedItemId);
    if (index != -1) {
      final current = _savedDesigns[index];
      _savedDesigns[index] =
          current.copyWith(isSharedWithDesigner: !current.isSharedWithDesigner);
      notifyListeners();
    }
  }

  // Add generation artifact to history
  void recordGeneration({
    required AiArtifactType type,
    required String title,
    required String subtitle,
    String? previewImageUrl,
    required int creditsUsed,
    required String destinationRoute,
  }) {
    _history.insert(
      0,
      AiGenerationHistoryItem(
        id: 'HIST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        type: type,
        title: title,
        subtitle: subtitle,
        previewImageUrl: previewImageUrl,
        createdAt: DateTime.now(),
        creditsUsed: creditsUsed,
        destinationRoute: destinationRoute,
      ),
    );
    notifyListeners();
  }
}
