class StudentGroupUser {
  final int userId;
  final int groupId;

  StudentGroupUser({
    required this.userId,
    required this.groupId,
  });

  factory StudentGroupUser.fromJson(Map<String, dynamic> json) {
    return StudentGroupUser(
      userId: json['user_id'],
      groupId: json['group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'group_id': groupId,
    };
  }
}
