enum AiArtifactType {
  roomRender('3D Room Visualization', '3D Photorealistic render'),
  imageJob('Custom Image Asset', 'AI image prompt output'),
  videoWalkthrough('Flythrough Animation', 'Cinematic video simulation'),
  vastuAudit('Vastu Floorplan Audit', 'Diagnostic energy score'),
  budgetSpec('Material & Budget BOQ', 'Financial package estimate'),
  technicalDoubt('Technical Query Resolution', 'Civil & interior advisory');

  final String label;
  final String description;
  const AiArtifactType(this.label, this.description);
}

class AiGenerationHistoryItem {
  final String id;
  final AiArtifactType type;
  final String title;
  final String subtitle;
  final String? previewImageUrl;
  final DateTime createdAt;
  final int creditsUsed;
  final bool isBookmarked;
  final String destinationRoute;
  final Map<String, dynamic> metadata;

  const AiGenerationHistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.previewImageUrl,
    required this.createdAt,
    required this.creditsUsed,
    this.isBookmarked = false,
    required this.destinationRoute,
    this.metadata = const {},
  });

  AiGenerationHistoryItem copyWith({
    String? id,
    AiArtifactType? type,
    String? title,
    String? subtitle,
    String? previewImageUrl,
    DateTime? createdAt,
    int? creditsUsed,
    bool? isBookmarked,
    String? destinationRoute,
    Map<String, dynamic>? metadata,
  }) {
    return AiGenerationHistoryItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      createdAt: createdAt ?? this.createdAt,
      creditsUsed: creditsUsed ?? this.creditsUsed,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      destinationRoute: destinationRoute ?? this.destinationRoute,
      metadata: metadata ?? this.metadata,
    );
  }
}
