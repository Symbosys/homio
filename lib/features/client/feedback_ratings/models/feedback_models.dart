import 'package:flutter/material.dart';

/// Category rating within a structured feedback submission
class FeedbackCategoryRating {
  final String key;
  final String title;
  final String question;
  double score;

  FeedbackCategoryRating({
    required this.key,
    required this.title,
    required this.question,
    this.score = 5.0,
  });

  FeedbackCategoryRating copyWith({double? score}) {
    return FeedbackCategoryRating(
      key: key,
      title: title,
      question: question,
      score: score ?? this.score,
    );
  }
}

/// Sentiment or descriptive tag for fast customer feedback
class FeedbackTag {
  final String label;
  final bool isPositive;

  const FeedbackTag({
    required this.label,
    this.isPositive = true,
  });
}

/// A completed, customer-submitted feedback item
class CustomerFeedbackItem {
  final String id;
  final String targetType; // 'Project', 'Milestone', 'Service', 'Designer', 'Labour'
  final String title;
  final String targetEntity;
  final String date;
  final double overallScore;
  final Map<String, double> categoryScores;
  final String comments;
  final List<String> tags;
  final String? recommendation; // 'Yes', 'Neutral', 'No'
  final String reviewerName;
  final bool isVerified;
  final List<String> attachments;

  const CustomerFeedbackItem({
    required this.id,
    required this.targetType,
    required this.title,
    required this.targetEntity,
    required this.date,
    required this.overallScore,
    required this.categoryScores,
    required this.comments,
    required this.tags,
    this.recommendation = 'Yes',
    this.reviewerName = 'Amit Kumar',
    this.isVerified = true,
    this.attachments = const [],
  });
}

/// An actionable prompt requesting customer feedback
class PendingFeedbackPrompt {
  final String id;
  final String categoryLabel;
  final String title;
  final String subtitle;
  final String date;
  final String targetType;
  final String? providerName;
  final String? projectId;
  final bool isUrgent;
  final IconData icon;
  final Color badgeColor;

  const PendingFeedbackPrompt({
    required this.id,
    required this.categoryLabel,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.targetType,
    this.providerName,
    this.projectId,
    this.isUrgent = false,
    required this.icon,
    required this.badgeColor,
  });
}

/// In-memory repository for client feedback and ratings data
class FeedbackRepository {
  FeedbackRepository._();
  static final FeedbackRepository instance = FeedbackRepository._();

  final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);

  final List<PendingFeedbackPrompt> _pendingPrompts = [
    const PendingFeedbackPrompt(
      id: 'pnd_design_living',
      categoryLabel: 'DESIGN EXPERIENCE',
      title: 'Living Room 3D Photorealistic Design',
      subtitle: 'Your 3D design has been approved. How was your experience with Ar. Pooja Hegde?',
      date: '12 Sep 2026',
      targetType: 'Designer',
      providerName: 'Pooja Hegde',
      projectId: 'proj_3bhk_dhanbad',
      isUrgent: true,
      icon: Icons.view_in_ar_rounded,
      badgeColor: Color(0xFF8B5CF6),
    ),
    const PendingFeedbackPrompt(
      id: 'pnd_service_carpentry',
      categoryLabel: 'SERVICE COMPLETED',
      title: 'Custom Modular Kitchen Joinery',
      subtitle: 'Carpentry & hardware fittings completed by Rajesh Kumar (Master Carpenter).',
      date: '10 Sep 2026',
      targetType: 'Labour',
      providerName: 'Rajesh Kumar',
      projectId: 'proj_3bhk_dhanbad',
      isUrgent: false,
      icon: Icons.carpenter_rounded,
      badgeColor: Color(0xFF0EA5E9),
    ),
  ];

  final List<CustomerFeedbackItem> _submittedFeedback = [
    const CustomerFeedbackItem(
      id: 'fb_001',
      targetType: 'Milestone',
      title: 'Stage 4: Italian Marble Flooring & Wall Cladding',
      targetEntity: 'Rajesh Verma (Supervisor) & Ar. Pooja Hegde',
      date: 'Aug 28, 2026',
      overallScore: 4.9,
      categoryScores: {
        'Quality': 5.0,
        'Timeline': 4.8,
        'Communication': 5.0,
        'Professionalism': 5.0,
        'Materials': 4.8,
      },
      comments:
          'Statuario bookmatch polish is breathtaking. The team maintained strict dust barriers and cleared debris daily.',
      tags: ['#ImpeccableFinish', '#CleanSite', '#PunctualDelivery', '#LaserPrecision'],
      recommendation: 'Yes',
      reviewerName: 'Amit Kumar',
    ),
    const CustomerFeedbackItem(
      id: 'fb_002',
      targetType: 'Milestone',
      title: 'Stage 3: Gypsum False Ceiling & Cove Lighting',
      targetEntity: 'Site Execution Team',
      date: 'Aug 14, 2026',
      overallScore: 5.0,
      categoryScores: {
        'Quality': 5.0,
        'Timeline': 5.0,
        'Communication': 5.0,
        'Professionalism': 5.0,
        'Materials': 5.0,
      },
      comments:
          'Laser leveling on the double-height ceiling was executed to perfection. Magnetic track lights look stunning.',
      tags: ['#ZeroDefects', '#PromptUpdates', '#ProfessionalTeam'],
      recommendation: 'Yes',
      reviewerName: 'Amit Kumar',
    ),
    const CustomerFeedbackItem(
      id: 'fb_003',
      targetType: 'Service',
      title: 'Deep Electrical Concealed Conduit Testing',
      targetEntity: 'Sunil Sharma (Senior Electrician)',
      date: 'Jul 29, 2026',
      overallScore: 4.8,
      categoryScores: {
        'Quality': 4.8,
        'Timeline': 4.7,
        'Communication': 4.9,
        'Professionalism': 5.0,
        'Materials': 4.8,
      },
      comments:
          'Schneider electric breakers and Havells conduits installed cleanly. Megger resistance test certified on site.',
      tags: ['#SafetyFirst', '#CleanWiring', '#VerifiedTechnician'],
      recommendation: 'Yes',
      reviewerName: 'Amit Kumar',
    ),
    const CustomerFeedbackItem(
      id: 'fb_004',
      targetType: 'Milestone',
      title: 'Stage 1: Civil Demolition & Core Masonry',
      targetEntity: 'Ar. Sameer Mehta & Site Team',
      date: 'Jul 12, 2026',
      overallScore: 4.7,
      categoryScores: {
        'Quality': 4.8,
        'Timeline': 4.5,
        'Communication': 4.8,
        'Professionalism': 4.9,
        'Materials': 4.6,
      },
      comments:
          'Society permissions were handled without any hassle. Demolition was carried out safely with zero neighbor disturbance.',
      tags: ['#StructuralSafety', '#PoliteCrew', '#SmoothClearance'],
      recommendation: 'Yes',
      reviewerName: 'Amit Kumar',
    ),
  ];

  List<PendingFeedbackPrompt> get pendingPrompts => List.unmodifiable(_pendingPrompts);
  List<CustomerFeedbackItem> get submittedFeedback => List.unmodifiable(_submittedFeedback);

  int get pendingCount => _pendingPrompts.length;
  int get submittedCount => _submittedFeedback.length;

  double get averageRating {
    if (_submittedFeedback.isEmpty) return 5.0;
    final total = _submittedFeedback.fold<double>(0, (sum, item) => sum + item.overallScore);
    return double.parse((total / _submittedFeedback.length).toStringAsFixed(1));
  }

  void submitFeedback({
    required PendingFeedbackPrompt? prompt,
    required String title,
    required String targetEntity,
    required String targetType,
    required double overallScore,
    required Map<String, double> categoryScores,
    required String comments,
    required List<String> tags,
    required String recommendation,
    List<String> attachments = const [],
  }) {
    if (prompt != null) {
      _pendingPrompts.removeWhere((p) => p.id == prompt.id);
    }
    final newItem = CustomerFeedbackItem(
      id: 'fb_${DateTime.now().millisecondsSinceEpoch}',
      targetType: targetType,
      title: title,
      targetEntity: targetEntity,
      date: 'Today, ${_formatToday()}',
      overallScore: overallScore,
      categoryScores: categoryScores,
      comments: comments.trim().isEmpty
          ? 'Exceptional workmanship and very professional coordination throughout.'
          : comments.trim(),
      tags: tags.isEmpty ? ['#HighQuality', '#ProfessionalTeam'] : tags,
      recommendation: recommendation,
      reviewerName: 'Amit Kumar',
      attachments: attachments,
    );
    _submittedFeedback.insert(0, newItem);
    changeNotifier.value++;
  }

  static String _formatToday() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
