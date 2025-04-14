class AchWithUser {
  // final String nickname;
  final int achId;
  final String name;
  final String? desc;
  // final int statId;
  // final int pointAmount;
  final String? linkImage;
  final bool earned;
  final bool claimedAward;

  AchWithUser({
    // required this.nickname,
    required this.achId,
    required this.name,
    this.desc,
    // required this.statId,
    // required this.pointAmount,
    this.linkImage,
    required this.earned,
    required this.claimedAward,
  });

  factory AchWithUser.fromUserAchJson(Map<String, dynamic> json) {
    return AchWithUser(
      // nickname: json['nickname'],
      achId: json['achievements']['ach_id'],
      name: json['achievements']['name'],
      desc: json['achievements']['description'],
      // statId: json['stat_id'],
      // pointAmount: json['point_amount'],
      linkImage: json['achievements']['link_image'],
      earned: true,
      claimedAward: json['claim_award'],
    );
  }

  factory AchWithUser.fromAchNotWonJson(Map<String, dynamic> json) {
    return AchWithUser(
      // nickname: "", //mozda nam ne treba
      achId: json['ach_id'],
      name: json['name'],
      desc: json['description'],
      // statId: json['stat_id'],
      // pointAmount: json['point_amount'],
      linkImage: json['link_image'],
      earned: false,
      claimedAward: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'nickname': nickname,
      'ach_id': achId,
      'name': name,
      'desc': desc,
      // 'stat_id': statId,
      // 'point_amount': pointAmount,
      'link_image': linkImage,
      'earned': earned,
      'claimed_award': claimedAward,
    };
  }
}
