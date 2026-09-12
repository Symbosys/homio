enum VideoCameraMotion {
  smoothFlythrough('Smooth Cinematic Flythrough', 'Glides through the room entrance towards balcony'),
  orbit360('360° Circular Orbit', 'Rotates around the central furniture/island counter'),
  dollyZoom('Slow Dolly In & Reveal', 'Creeps forward highlighting fine textures and fixtures'),
  panWide('Panoramic Horizon Pan', 'Sweeps horizontally across the living and dining breadth');

  final String title;
  final String subtitle;
  const VideoCameraMotion(this.title, this.subtitle);
}

class AiVideoJob {
  final String id;
  final String title;
  final String prompt;
  final VideoCameraMotion cameraMotion;
  final int durationSeconds; // 5 or 10 seconds
  final String resolution; // '1080p Full HD' or '4K Cinema'
  final String? sourceImageUrl;
  final String? videoStreamUrl;
  final String? thumbnailUrl;
  final int creditCost;
  final bool isCompleted;
  final bool isFailed;
  final String? statusMessage;
  final DateTime createdAt;

  const AiVideoJob({
    required this.id,
    required this.title,
    required this.prompt,
    required this.cameraMotion,
    this.durationSeconds = 6,
    this.resolution = '1080p 60fps',
    this.sourceImageUrl,
    this.videoStreamUrl,
    this.thumbnailUrl,
    this.creditCost = 8,
    this.isCompleted = false,
    this.isFailed = false,
    this.statusMessage,
    required this.createdAt,
  });

  AiVideoJob copyWith({
    String? id,
    String? title,
    String? prompt,
    VideoCameraMotion? cameraMotion,
    int? durationSeconds,
    String? resolution,
    String? sourceImageUrl,
    String? videoStreamUrl,
    String? thumbnailUrl,
    int? creditCost,
    bool? isCompleted,
    bool? isFailed,
    String? statusMessage,
    DateTime? createdAt,
  }) {
    return AiVideoJob(
      id: id ?? this.id,
      title: title ?? this.title,
      prompt: prompt ?? this.prompt,
      cameraMotion: cameraMotion ?? this.cameraMotion,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      resolution: resolution ?? this.resolution,
      sourceImageUrl: sourceImageUrl ?? this.sourceImageUrl,
      videoStreamUrl: videoStreamUrl ?? this.videoStreamUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      creditCost: creditCost ?? this.creditCost,
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
      statusMessage: statusMessage ?? this.statusMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
