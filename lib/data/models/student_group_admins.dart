class StudentGroupAdmin {
  final int adminId;
  final int groupId;

  StudentGroupAdmin({
    required this.adminId,
    required this.groupId,
  });

  factory StudentGroupAdmin.fromJson(Map<String, dynamic> json) {
    return StudentGroupAdmin(
      adminId: json['admin_id'],
      groupId: json['group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_id': adminId,
      'group_id': groupId,
    };
  }
}
