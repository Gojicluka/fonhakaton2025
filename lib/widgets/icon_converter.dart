import 'package:flutter/material.dart';

IconData? getIconFromString(String iconName) {
  try {
    return IconsData[iconName] ?? Icons.help_outline; // Fallback icon
  } catch (e) {
    print("Icon not found: $iconName");
    return Icons.help_outline; // Default icon
  }
}

/// Generate all available Flutter Material Icons dynamically
final Map<String, IconData> IconsData = {
  for (var icon in _availableIcons) icon.toString(): icon
};

/// Manually extract icons (avoid hardcoding in main code)
const List<IconData> _availableIcons = [
  Icons.home,
  Icons.school,
  Icons.group,
  Icons.people,
  Icons.work,
  Icons.star,
  Icons.settings,
  Icons.check,
  Icons.add,
  Icons.camera_alt,
  Icons.alarm,
  Icons.airplane_ticket,
  Icons.bike_scooter,
  Icons.car_rental,
  Icons.favorite,
  Icons.shopping_cart,
  // Added icons from StudentGroup
  Icons.shield,
  Icons.schedule,
  Icons.auto_awesome,
  Icons.local_fire_department,
  Icons.water,
  Icons.local_florist,
];
