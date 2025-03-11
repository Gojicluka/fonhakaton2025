import 'package:flutter/material.dart';

class Achievement {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  DateTime? dateAchieved;

  Achievement({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.dateAchieved,
  });
}