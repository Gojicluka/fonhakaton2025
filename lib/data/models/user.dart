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

UserModel user1 = UserModel(
  id: 1,
  name: "pera35",
  indexNumber: "2021/0345",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  trustLevel: 10,
  avatarUrl: "../../../../assets/user1.jpg"
);
UserModel user2 = UserModel(
  id: 2,
  name: "anas98",
  indexNumber: "2020/0123",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  trustLevel: 5,
  avatarUrl: "../../../../assets/user2.jpg"
);
UserModel user3 = UserModel(
  id: 3,
  name: "jojo",
  indexNumber: "2022/0045",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  trustLevel: 10,
  avatarUrl: "../../../../assets/user3.jpg"
);
UserModel user4 = UserModel(
  id: 4,
  name: "p1p1",
  indexNumber: "2022/0005",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  avatarUrl: "../../../../assets/user4.jpg"
);
UserModel user5 = UserModel(
  id: 5,
  name: "irkee",
  indexNumber: "2021/0005",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  avatarUrl: "../../../../assets/user5.jpg"
);
UserModel user6 = UserModel(
  id: 6,
  name: "keks",
  indexNumber: "2021/0115",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  avatarUrl: "../../../../assets/user6.jpg"
);
UserModel user7 = UserModel(
  id: 7,
  name: "anica",
  indexNumber: "2023/0111",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  trustLevel: 10,
  avatarUrl: "../../../../assets/user7.jpg"
);
UserModel user8 = UserModel(
  id: 8,
  name: "skocko",
  indexNumber: "2020/0216",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  trustLevel: 10,
  avatarUrl: "../../../../assets/user8.jpg"
);
UserModel user9 = UserModel(
  id: 9,
  name: "anastP2",
  indexNumber: "2020/0118",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  avatarUrl: "../../../../assets/user9.jpg"
);
UserModel user10 = UserModel(
  id: 10,
  name: "milkaa",
  indexNumber: "2023/0006",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  avatarUrl: "../../../../assets/user10.png"
);
UserModel user11 = UserModel(
  id:11,
  name: "ns999",
  indexNumber: "2021/0016",
  fakultet: "Pravni fakultet Univerziteta u Beogradu",
  avatarUrl: "../../../../assets/user11.jpg"
);

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
