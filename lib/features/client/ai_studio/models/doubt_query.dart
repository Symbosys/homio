enum DoubtDomain {
  carpentry('Carpentry & Woodwork', 'Plywood grades, laminates, warping, hinge hardware'),
  waterproofing('Waterproofing & Civil', 'Seepage, bathroom floor slope, exterior crack treatments'),
  electrical('Electrical & Lighting', 'Circuit loads, wire gauge, profile lighting, earthing'),
  falseCeiling('False Ceiling & Gypsum', 'Channel thickness, cove LED heat, suspension spacing'),
  stoneFlooring('Countertops & Flooring', 'Quartz vs Granite, tile lippage, epoxy grouting'),
  contractorSLA('Contracts & Site Standards', 'Tolerances, execution checklists, milestone signoffs');

  final String title;
  final String description;
  const DoubtDomain(this.title, this.description);
}

class DoubtQuery {
  final String id;
  final DoubtDomain domain;
  final String question;
  final List<String> attachmentUrls;
  final String aiDetailedAnswer;
  final int confidencePercent;
  final String? humanVerifierName; // E.g. 'Er. Rajesh Iyer, Senior Technical Lead'
  final List<String> immediateChecklistSteps;
  final List<String> standardIndianCodesReferenced; // E.g. 'IS 3087: Particle Board standards'
  final int creditsUsed;
  final DateTime askedAt;

  const DoubtQuery({
    required this.id,
    required this.domain,
    required this.question,
    this.attachmentUrls = const [],
    required this.aiDetailedAnswer,
    this.confidencePercent = 98,
    this.humanVerifierName,
    this.immediateChecklistSteps = const [],
    this.standardIndianCodesReferenced = const [],
    this.creditsUsed = 1,
    required this.askedAt,
  });

  DoubtQuery copyWith({
    String? id,
    DoubtDomain? domain,
    String? question,
    List<String>? attachmentUrls,
    String? aiDetailedAnswer,
    int? confidencePercent,
    String? humanVerifierName,
    List<String>? immediateChecklistSteps,
    List<String>? standardIndianCodesReferenced,
    int? creditsUsed,
    DateTime? askedAt,
  }) {
    return DoubtQuery(
      id: id ?? this.id,
      domain: domain ?? this.domain,
      question: question ?? this.question,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      aiDetailedAnswer: aiDetailedAnswer ?? this.aiDetailedAnswer,
      confidencePercent: confidencePercent ?? this.confidencePercent,
      humanVerifierName: humanVerifierName ?? this.humanVerifierName,
      immediateChecklistSteps: immediateChecklistSteps ?? this.immediateChecklistSteps,
      standardIndianCodesReferenced:
          standardIndianCodesReferenced ?? this.standardIndianCodesReferenced,
      creditsUsed: creditsUsed ?? this.creditsUsed,
      askedAt: askedAt ?? this.askedAt,
    );
  }
}
