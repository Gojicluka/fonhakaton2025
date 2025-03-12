class StudentGroup {
  final int id;
  final String name;
  final String? description;
  final int? universityId;
  final String? iconName; // Store icon as string
  final String color; // Store color as HEX string

  StudentGroup({
    required this.id,
    required this.name,
    this.description,
    this.universityId,
    this.iconName,
    this.color = "#FFFFFF", // Default color: white
  });

  /// Convert JSON to `StudentGroup`
  factory StudentGroup.fromJson(Map<String, dynamic> json) {
    return StudentGroup(
      id: json['id'],
      name: json['ime'],
      description: json['description'] ?? '',
      universityId: json['university_id'],
      iconName: json['icon'], // Stored as 'Icons.group'
      color: json['color'] ?? "#FFFFFF",
    );
  }

  /// Convert `StudentGroup` to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ime': name,
      'description': description,
      'university_id': universityId,
      'icon': iconName,
      'color': color,
    };
  }
}
