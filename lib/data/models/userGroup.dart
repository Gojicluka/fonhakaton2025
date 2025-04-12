enum UserGroupRole { user, admin }

List<String> userGroupRoleStringarr = [
  "user",
  "admin",
];

class UserGroup {
  final String nickname;
  final int groupId;
  final String role; // Representing PostgreSQL enum as a string

  UserGroup({
    required this.nickname,
    required this.groupId,
    required this.role,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) => UserGroup(
        nickname: json['nickname'],
        groupId: json['group_id'],
        role: json['role'], // Will be 'user' or 'admin'
      );

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'group_id': groupId,
        'role': role,
      };
}
