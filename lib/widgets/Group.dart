import 'package:flutter/material.dart';
import 'package:fonhakaton2025/data/models/student_group.dart';

final List<StudentGroup> groups = [
  StudentGroup(
      id: 1,
      name: "Logistika",
      iconName: "shield",
      color: "#795548",
      description:
          "A group responsible for managing supplies, routes, and resources."),
  StudentGroup(
      id: 2,
      name: "Dnevni red",
      iconName: "schedule",
      color: "#607D8B",
      description: "A group that organizes schedules, meetings, and plans."),
  StudentGroup(
      id: 3,
      name: "Mediji",
      iconName: "auto_awesome",
      color: "#673AB7",
      description:
          "A group handling magical broadcasts, announcements, and media."),
  StudentGroup(
      id: 4,
      name: "Red",
      iconName: "local_fire_department",
      color: "#F44336",
      description: "A fiery challenge."),
  StudentGroup(
      id: 5,
      name: "Blue",
      iconName: "water",
      color: "#2196F3",
      description: "A water-based mission."),
  StudentGroup(
      id: 6,
      name: "Pink",
      iconName: "local_florist",
      color: "#E91E63",
      description: "A soft and delicate task."),
];
