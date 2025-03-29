class TasksPredetermined {
  final int predId;
  final int canUse;
  final int forGroup;
  final String name;
  final String? description;
  final String? place;
  final int xp;
  final bool urgent;
  final int existsForTime;
  final int pplNeeded;
  final int pplDoing;
  final int pplSubmitted;

  TasksPredetermined({
    required this.predId,
    required this.canUse,
    required this.forGroup,
    required this.name,
    this.description,
    this.place,
    required this.xp,
    required this.urgent,
    required this.existsForTime,
    required this.pplNeeded,
    required this.pplDoing,
    required this.pplSubmitted,
  });

  factory TasksPredetermined.fromJson(Map<String, dynamic> json) =>
      TasksPredetermined(
        predId: json['pred_id'],
        canUse: json['can_use'],
        forGroup: json['for_group'],
        name: json['name'],
        description: json['description'],
        place: json['place'],
        xp: json['xp'],
        urgent: json['urgent'],
        existsForTime: json['exists_for_time'],
        pplNeeded: json['ppl_needed'],
        pplDoing: json['ppl_doing'],
        pplSubmitted: json['ppl_submitted'],
      );

  Map<String, dynamic> toJson() => {
        'pred_id': predId,
        'can_use': canUse,
        'for_group': forGroup,
        'name': name,
        'description': description,
        'place': place,
        'xp': xp,
        'urgent': urgent,
        'exists_for_time': existsForTime,
        'ppl_needed': pplNeeded,
        'ppl_doing': pplDoing,
        'ppl_submitted': pplSubmitted,
      };
}
