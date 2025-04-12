class GroupJoinRequest {
  final String nickname;
  final int groupId;

  GroupJoinRequest({
    required this.nickname,
    required this.groupId,
  });

  factory GroupJoinRequest.fromJson(Map<String, dynamic> json) =>
      GroupJoinRequest(
        nickname: json['nickname'],
        groupId: json['group_id'],
      );

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'group_id': groupId,
      };
}
