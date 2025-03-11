import 'package:flutter/material.dart';

class Group {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  Group(this.name, this.icon, this.color, this.description);
}

final List<Group> groups = [
  Group("Logistika", Icons.shield, Colors.brown,
      "A group responsible for managing supplies, routes, and resources."),
  Group("Dnevni red", Icons.schedule, Colors.blueGrey,
      "A group that organizes schedules, meetings, and plans."),
  Group("Mediji", Icons.auto_awesome, Colors.deepPurple,
      "A group handling magical broadcasts, announcements, and media."),
  Group("Red", Icons.local_fire_department, Colors.red, "A fiery challenge."),
  Group("Blue", Icons.water, Colors.blue, "A water-based mission."),
  Group("Pink", Icons.local_florist, Colors.pink, "A soft and delicate task."),
];
