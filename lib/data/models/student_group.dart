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

//DESCRIPTIONS SU OVDE KRATKI, ZA DUZE IDI U Group.dart
StudentGroup dnRed = StudentGroup(
  id: 101,
  name: "Dnevni red",
  description: "Radna grupa odgovorna za funkcionisanje plenuma i komunikaciju sa upravom.",//ZA DUZE OPISE IDI U GROUP.DART
  universityId: 1, // Example university ID
  iconName: "Icons.access_time", // Icon for the group (Flutter Icon)
  color: "#607D8B", 
);

StudentGroup komunikacije = StudentGroup(
  id: 102,
  name: "Komunikacije",
  description: "Radna grupa odgovorna za komunikaciju sa drugim fakultetima.",
  universityId: 1, // Example university ID
  iconName: "Icons.local_fire_department", // Icon for the group (Flutter Icon)
  color: "#F44336", 
);

StudentGroup logistika = StudentGroup(
  id: 103,
  name: "Logistika",
  description: "Radna grupa odgovorna za raspodelu sredstava.",
  universityId: 1, // Example university ID
  iconName: "Icons.water", // Icon for the group (Flutter Icon)
  color: "#2196F3", 
);

StudentGroup bezbednost = StudentGroup(
  id: 104,
  name: "Bezbednost",
  description: "Radna grupa odgovorna za bezbednost blokada.",
  universityId: 1, // Example university ID
  iconName: "Icons.shield", // Icon for the group (Flutter Icon)
  color: "#795548", 
);

StudentGroup agitMot = StudentGroup(
  id: 105,
  name: "Agitacija i motivacija",
  description: "Radna grupa odgovorna za povecanje angazovanja.",
  universityId: 1, // Example university ID
  iconName: "Icons.local_florist", // Icon for the group (Flutter Icon)
  color: "#E91E63", 
);

StudentGroup mediji = StudentGroup(
  id: 106,
  name: "Mediji",
  description: "Radna grupa odgovorna za informisanje.",
  universityId: 1, // Example university ID
  iconName: "Icons.auto_awesome", // Icon for the group (Flutter Icon)
  color: "#673AB7", 
);

}
