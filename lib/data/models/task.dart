class Task {
  final int taskId;
  final String name;
  final String description;
  final String place;
  final int? uniId;
  final int xp;
  final int groupId;
  final bool urgent;
  final int existsForTime;
  final int pplNeeded;
  final int pplDoing;
  final int pplSubmitted;
  final String createdBy;
  final String color;
  final String iconName;
  final int durationInMinutes;

  Task({
    required this.taskId,
    required this.name,
    required this.description,
    required this.place,
    required this.uniId,
    required this.xp,
    required this.groupId,
    required this.urgent,
    required this.existsForTime,
    required this.pplNeeded,
    required this.pplDoing,
    required this.pplSubmitted,
    required this.createdBy,
    required this.color,
    required this.iconName,
    required this.durationInMinutes,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        taskId: json['task_id'],
        name: json['name'],
        description: json['description'],
        place: json['place'],
        uniId: json['uni_id'],
        xp: json['xp'],
        groupId: json['group_id'],
        urgent: json['urgent'],
        existsForTime: json['exists_for_time'],
        pplNeeded: json['ppl_needed'],
        pplDoing: json['ppl_doing'],
        pplSubmitted: json['ppl_submitted'],
        createdBy: json['created_by'],
        color: json['color'],
        iconName: json['icon_name'],
        durationInMinutes: json['duration_in_minutes'],
      );

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'name': name,
        'description': description,
        'place': place,
        'uni_id': uniId,
        'xp': xp,
        'group_id': groupId,
        'urgent': urgent,
        'exists_for_time': existsForTime,
        'ppl_needed': pplNeeded,
        'ppl_doing': pplDoing,
        'ppl_submitted': pplSubmitted,
        'created_by': createdBy,
        'color': color,
        'icon_name': iconName,
        'duration_in_minutes': durationInMinutes,
      };
}
