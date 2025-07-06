class TaskManagerModel {
  final String id;
  final String title;
  final String description;
  final String colorHex;
  final DateTime createdAt;
  final bool isPinned;

  TaskManagerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.createdAt,
    required this.isPinned,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isPinned': isPinned,
      'colorHex': colorHex,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskManagerModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskManagerModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isPinned: map['isPinned'] ?? '',
      colorHex: map['colorHex'] ?? '#FF6200EE',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Creates a new copy with updated fields
  TaskManagerModel copyWith({
    String? id,
    String? title,
    String? description,
    String? colorHex,
    bool? isPinned,
    DateTime? createdAt,
  }) {
    return TaskManagerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
