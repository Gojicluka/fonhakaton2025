class UserModel {
  final int id;
  final String name;
  final String indexNumber;
  final String fakultet;
  final int xp;
  final int trustLevel;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.indexNumber,
    required this.fakultet,
    this.xp = 0,
    this.trustLevel = 0,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      indexNumber: json['index_number'],
      fakultet: json['fakultet'],
      xp: json['xp'] ?? 0,
      trustLevel: json['trust_level'] ?? 0,
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'index_number': indexNumber,
      'fakultet': fakultet,
      'xp': xp,
      'trust_level': trustLevel,
      'avatar_url': avatarUrl,
    };
  }
}
