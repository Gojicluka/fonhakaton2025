class PredeterminedExisting {
  final int taskId;
  final int predId;

  PredeterminedExisting({
    required this.taskId,
    required this.predId,
  });

  factory PredeterminedExisting.fromJson(Map<String, dynamic> json) =>
      PredeterminedExisting(
        taskId: json['task_id'],
        predId: json['pred_id'],
      );

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'pred_id': predId,
      };
}
