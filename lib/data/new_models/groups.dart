import 'dart:convert';

class Group {
  final int groupId;
  final String name;
  final String? description;

  Group({required this.groupId, required this.name, this.description});

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json['group_id'],
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'group_id': groupId,
        'name': name,
        'description': description,
      };
}
