class TaskWithState {
  // from tasks
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

  // from user_task

  final String userDoing;
  final String? evalDescription;
  final String? imageEvidence;
  final String? stateId; // this is string enum in supabase table  .
  TaskWithState({
    required this.taskId,
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
    required this.color,
    required this.iconName,
    required this.durationInMinutes,
    required this.userDoing,
    required this.evalDescription,
    required this.imageEvidence,
    required this.stateId,
  });

  bool isApproved() {
    return this.stateId == "accepted";
  }

  bool isDenied() {
    return this.stateId == "denied";
  }

  // todo - implement new factory that will take two jsons, one with data from user_task, and another with data from task!!!

  factory TaskWithState.fromJoinJson(
    Map<String, dynamic> userTask,
    Map<String, dynamic> tasks,
  ) {
    return TaskWithState(
      taskId: tasks['task_id'],
      name: tasks['name'],
      description: tasks['description'],
      place: tasks['place'],
      uniId: tasks['uni_id'],
      xp: tasks['xp'],
      groupId: tasks['group_id'],
      urgent: tasks['urgent'],
      existsForTime: tasks['exists_for_time'],
      pplNeeded: tasks['ppl_needed'],
      pplDoing: tasks['ppl_doing'],
      pplSubmitted: tasks['ppl_submitted'],
      createdBy: tasks['created_by'],
      color: tasks['color'],
      iconName: tasks['icon_name'],
      durationInMinutes: tasks['duration_in_minutes'],
      userDoing: userTask['nickname'],
      evalDescription: userTask['eval_description'],
      imageEvidence: userTask['image_evidence'],
      stateId: userTask['state_id'],
    );
  }

  factory TaskWithState.fromJson(Map<String, dynamic> json) {
    return TaskWithState(
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
      userDoing: json['nickname'],
      evalDescription: json['eval_description'],
      imageEvidence: json['image_evidence'],
      stateId: json['state_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'nickname': userDoing,
      'eval_description': evalDescription,
      'image_evidence': imageEvidence,
      'state_id': stateId,
    };
  }
}
