class TaskWithState {
  final int taskId;
  final String takenBy;
  final int stateId;
  final String name;
  final String description;
  final String place;
  final int? uniId;
  final int xp;
  final int groupId;
  final bool urgent;
  final int
      existsForTime; // todo updated in real time? or perhaps some scheduled time for deletion...? how would this work.
  final int pplNeeded;
  final int pplDoing;
  final int pplSubmitted;
  final String createdBy;

  TaskWithState({
    required this.taskId,
    required this.takenBy,
    required this.stateId,
    required this.name,
    required this.description,
    required this.place,
    this.uniId,
    required this.xp,
    required this.groupId,
    required this.urgent,
    required this.existsForTime,
    required this.pplNeeded,
    required this.pplDoing,
    required this.pplSubmitted,
    required this.createdBy,
  });

  factory TaskWithState.fromJson(Map<String, dynamic> json) => TaskWithState(
        taskId: json['task_id'],
        takenBy: json['nickname'],
        stateId: json['state_id'],
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
      );

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'nickname': takenBy,
        'state_id': stateId,
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
      };
}
