enum ImageAspect {
  landscape16x9('16:9', 'Presentation / Desktop screen'),
  portrait9x16('9:16', 'Mobile Story / Wallpaper'),
  square1x1('1:1', 'Square Catalogue / Feed'),
  wide4x3('4:3', 'Architectural Photo View');

  final String ratio;
  final String label;
  const ImageAspect(this.ratio, this.label);
}

enum ImageRenderStyle {
  photorealistic('Photorealistic 8K', 'V-Ray / Corona high end interior render style'),
  architecturalSketch('Architectural Blueprint & Sketch', 'Hand-drawn ink & watercolor draft'),
  moodboardCollage('Curated Material Moodboard', 'Flatlay of swatches, finishes, and palettes'),
  isometric3D('Isometric 3D Cutaway', 'Miniature architectural dollhouse 3D view');

  final String label;
  final String description;
  const ImageRenderStyle(this.label, this.description);
}

class AiImageJob {
  final String id;
  final String prompt;
  final String negativePrompt;
  final ImageRenderStyle style;
  final ImageAspect aspect;
  final String? referenceImageUrl;
  final String? outputImageUrl;
  final int creditCost;
  final bool isCompleted;
  final bool isFailed;
  final String? errorMessage;
  final DateTime createdAt;
  final List<String> tags;

  const AiImageJob({
    required this.id,
    required this.prompt,
    this.negativePrompt = 'blurry, low quality, distorted walls, bad proportions, watermark',
    required this.style,
    required this.aspect,
    this.referenceImageUrl,
    this.outputImageUrl,
    this.creditCost = 2,
    this.isCompleted = false,
    this.isFailed = false,
    this.errorMessage,
    required this.createdAt,
    this.tags = const [],
  });

  AiImageJob copyWith({
    String? id,
    String? prompt,
    String? negativePrompt,
    ImageRenderStyle? style,
    ImageAspect? aspect,
    String? referenceImageUrl,
    String? outputImageUrl,
    int? creditCost,
    bool? isCompleted,
    bool? isFailed,
    String? errorMessage,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return AiImageJob(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      negativePrompt: negativePrompt ?? this.negativePrompt,
      style: style ?? this.style,
      aspect: aspect ?? this.aspect,
      referenceImageUrl: referenceImageUrl ?? this.referenceImageUrl,
      outputImageUrl: outputImageUrl ?? this.outputImageUrl,
      creditCost: creditCost ?? this.creditCost,
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }
}
