class TaskUser {
  final int taskId;
  final int userId;
  final String? photo;
  final String? description;
  final bool approved;
  final bool denied;

  TaskUser({
    required this.taskId,
    required this.userId,
    this.photo,
    this.description,
    this.approved = false,
    this.denied = false,
  });

  factory TaskUser.fromJson(Map<String, dynamic> json) {
    return TaskUser(
      taskId: json['TaskId'],
      userId: json['UserId'],
      photo: json['Photo'],
      description: json['Description'],
      approved: json['Approved'] ?? false,
      denied: json['Denied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TaskId': taskId,
      'UserId': userId,
      'Photo': photo,
      'Description': description,
      'Approved': approved,
      'Denied': denied,
    };
  }
}
