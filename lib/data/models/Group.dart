class Group {
  final int groupId;
  final String name;
  final String? description;
  final String color;
  final String iconName;

  Group({required this.groupId, required this.name, this.description, required this.color, required this.iconName});

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json['group_id'],
        name: json['name'],
        description: json['description'],
        color: json['color'],
        iconName: json['icon_name'],
      );

  Map<String, dynamic> toJson() => {
        'group_id': groupId,
        'name': name,
        'description': description,
        'color': color,
        'icon_name': iconName,
      };
}