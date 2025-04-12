class UserModel {
  final String nickname;
  final String? password;
  final bool? verified;
  final int xp;
  final int? lvl;
  final int? numTasksCreate;
  final String? image;
  final String? index;
  final int? uniId;
  final int? trustLevel;

  UserModel({
    required this.nickname,
    this.password,
    this.verified,
    required this.xp,
    this.lvl,
    this.numTasksCreate,
    this.image,
    this.index,
    this.uniId,
    this.trustLevel,
  });

  // New constructor with optional fields
  UserModel.optional({
    this.nickname = '',
    this.password,
    this.verified,
    this.xp = 0,
    this.lvl,
    this.numTasksCreate,
    this.image,
    this.index,
    this.uniId,
    this.trustLevel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        nickname: json['nickname'], // Default to empty string if null
        password: json['password'] ?? '', // Optional field
        verified: json['verified'] ?? false, // Optional field
        xp: json['xp'] ?? 0, // Default to 0 if null
        lvl: json['lvl'] ?? 0, // Optional field
        numTasksCreate: json['num_tasks_create'] ?? 0, // Optional field
        image: json['image'] ?? '', // Optional field
        index: json['index'] ?? '', // Optional field
        uniId: json['uni_id'] ?? 0, // Optional field
        trustLevel: json['trust_level'] ?? 0, // Optional field
      );

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'password': password,
        'verified': verified,
        'xp': xp,
        'lvl': lvl,
        'num_tasks_create': numTasksCreate,
        'image': image,
        'index': index,
        'uni_id': uniId,
        'trust_level': trustLevel,
      };
}
