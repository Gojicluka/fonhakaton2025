class University {
  final int id;
  final String name;
  final String location;

  University({
    required this.id,
    required this.name,
    required this.location,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }
}
