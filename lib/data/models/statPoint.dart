class StatPoint {
  final int statId;
  final String statName;
  final String nickname;
  final int amount;

  StatPoint({
    required this.statId,
    required this.statName,
    required this.nickname,
    required this.amount,
  });

  factory StatPoint.fromJson(Map<String, dynamic> json) {
    return StatPoint(
      statId: json['stat_id'],
      statName: json['stat_points']
          ['stat_name'], // joined table so we have to access object's object.
      nickname: json['nickname'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'user_id': userId,
      'nickname': nickname,
      'stat_id': statId,
      'stat_name': statName,
      'amount': amount,
    };
  }
}
