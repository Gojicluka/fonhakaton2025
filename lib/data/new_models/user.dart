class UserLogin {
  final String nickname;
  final String password;
  final bool verified;

  UserLogin(
      {required this.nickname, required this.password, required this.verified});

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        nickname: json['nickname'],
        password: json['password'],
        verified: json['verified'],
      );

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'password': password,
        'verified': verified,
      };
}
