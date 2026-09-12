class SavedDesignItem {
  final String id;
  final String title;
  final String category; // 'Living Room', 'Kitchen Island', 'Master Wardrobe', 'Pooja Unit'
  final String imageUrl;
  final List<String> colorPalette;
  final List<String> keyMaterials;
  final String personalNotes;
  final bool isSharedWithDesigner;
  final DateTime savedAt;

  const SavedDesignItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    this.colorPalette = const [],
    this.keyMaterials = const [],
    this.personalNotes = '',
    this.isSharedWithDesigner = false,
    required this.savedAt,
  });

  SavedDesignItem copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    List<String>? colorPalette,
    List<String>? keyMaterials,
    String? personalNotes,
    bool? isSharedWithDesigner,
    DateTime? savedAt,
  }) {
    return SavedDesignItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      colorPalette: colorPalette ?? this.colorPalette,
      keyMaterials: keyMaterials ?? this.keyMaterials,
      personalNotes: personalNotes ?? this.personalNotes,
      isSharedWithDesigner: isSharedWithDesigner ?? this.isSharedWithDesigner,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
