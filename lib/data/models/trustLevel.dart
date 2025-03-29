class TrustLevel {
  final int trustId;
  final String description;

  TrustLevel({required this.trustId, required this.description});

  factory TrustLevel.fromJson(Map<String, dynamic> json) => TrustLevel(
        trustId: json['trust_id'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'trust_id': trustId,
        'description': description,
      };
}