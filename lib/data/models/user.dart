class UserModel {
  final String nickname;
  final String password;
  final bool verified;
  final int xp;
  final int lvl;
  final int numTasksCreate;
  final String? image;
  final String index;
  final int uniId;
  final int trustLevel;

  UserModel({
    required this.nickname,
    required this.password,
    required this.verified,
    required this.xp,
    required this.lvl,
    required this.numTasksCreate,
    this.image,
    required this.index,
    required this.uniId,
    required this.trustLevel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        nickname: json['nickname'],
        password: json['password'],
        verified: json['verified'],
        xp: json['xp'],
        lvl: json['lvl'],
        numTasksCreate: json['num_tasks_create'],
        image: json['image'],
        index: json['index'],
        uniId: json['uni_id'],
        trustLevel: json['trust_level'],
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