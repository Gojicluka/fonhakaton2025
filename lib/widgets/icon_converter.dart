import 'package:flutter/material.dart';

IconData getIconFromString(String iconName) {
  return IconsData[iconName] ?? Icons.help_outline; // Default fallback icon
}

String iconToString(IconData icon) {
  return IconsData.entries
      .firstWhere((entry) => entry.value == icon,
          orElse: () => MapEntry('help_outline', Icons.help_outline))
      .key;
}

/// Generate all available Flutter Material Icons dynamically
const Map<String, IconData> IconsData = {
  'home': Icons.home,
  'school': Icons.school,
  'group': Icons.group,
  'people': Icons.people,
  'work': Icons.work,
  'star': Icons.star,
  'settings': Icons.settings,
  'check': Icons.check,
  'add': Icons.add,
  'camera_alt': Icons.camera_alt,
  'alarm': Icons.alarm,
  'airplane_ticket': Icons.airplane_ticket,
  'bike_scooter': Icons.bike_scooter,
  'car_rental': Icons.car_rental,
  'favorite': Icons.favorite,
  'shopping_cart': Icons.shopping_cart,
  'shield': Icons.shield,
  'schedule': Icons.schedule,
  'auto_awesome': Icons.auto_awesome,
  'local_fire_department': Icons.local_fire_department,
  'water': Icons.water,
  'local_florist': Icons.local_florist,
};
