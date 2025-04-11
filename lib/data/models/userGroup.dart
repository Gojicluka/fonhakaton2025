class UserGroup {
  final String nickname;
  final int groupId;

  UserGroup({required this.nickname, required this.groupId});

  // Factory constructor to create a UserGroup instance from JSON
  factory UserGroup.fromJson(Map<String, dynamic> json) => UserGroup(
        nickname: json['nickname'],
        groupId: json['group_id'],
      );

  // Method to convert a UserGroup instance to JSON
  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'group_id': groupId,
      };
}