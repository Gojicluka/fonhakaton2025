class Task {
  final int id;
  final int? creatorId;
  final int durationMinutes;
  final int xpGain;
  final bool done;
  final int? studentGroupId;
  final int universityId;
  final String location;
  final int peopleNeeded;

  Task({
    required this.id,
    this.creatorId,
    required this.durationMinutes,
    required this.xpGain,
    this.done = false,
    this.studentGroupId,
    required this.universityId,
    required this.location,
    required this.peopleNeeded,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      creatorId: json['creator_id'],
      durationMinutes: json['duration_minutes'],
      xpGain: json['xp_gain'],
      done: json['done'] ?? false,
      studentGroupId: json['student_group_id'],
      universityId: json['university_id'],
      location: json['location'],
      peopleNeeded: json['people_needed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'duration_minutes': durationMinutes,
      'xp_gain': xpGain,
      'done': done,
      'student_group_id': studentGroupId,
      'university_id': universityId,
      'location': location,
      'people_needed': peopleNeeded,
    };
  }
}
