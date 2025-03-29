class State {
  final int stateId;
  final String description;

  State({required this.stateId, required this.description});

  factory State.fromJson(Map<String, dynamic> json) => State(
        stateId: json['state_id'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'state_id': stateId,
        'description': description,
      };
}