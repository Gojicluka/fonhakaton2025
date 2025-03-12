import 'package:flutter/material.dart';
// Generates a static task ID (will be dynamic later)
import "package:fonhakaton2025/data/models/task.dart";

int generateTaskId() {
  return 1001; // Placeholder, replace with backend logic later
}

final List<Task> tasks = [
  Task(
      id: generateTaskId(),
      title: "Baci smeće",
      durationMinutes: 20,
      xpGain: 15,
      location: "Kontejner ispred zgrade",
      universityId: 1,
      peopleNeeded: 1,
      peopleApplied: 0,
      description: "Iznesi smeće do kontejnera ispred zgrade.",
      color: "#A52A2A"),
  Task(
      id: generateTaskId(),
      title: "Operi sudove",
      durationMinutes: 30,
      xpGain: 30,
      location: "Kuhinja",
      universityId: 1,
      peopleNeeded: 1,
      peopleApplied: 1,
      description: "Očisti i operi sudove nakon doručka.",
      color: "#0000FF"),
  Task(
      id: generateTaskId(),
      title: "Čuvaj vrata",
      durationMinutes: 50,
      xpGain: 120,
      location: "Glavni ulaz",
      universityId: 1,
      peopleNeeded: 2,
      peopleApplied: 1,
      description: "Obezbeđuj glavni ulaz tokom događaja.",
      color: "#FF0000"),
  Task(
      id: generateTaskId(),
      title: "Odnesi dušeke u 115",
      durationMinutes: 40,
      xpGain: 90,
      location: "Soba 115",
      universityId: 1,
      peopleNeeded: 2,
      peopleApplied: 0,
      description: "Prenesi rezervne dušeke u sobu 115.",
      color: "#008000"),
  Task(
      id: generateTaskId(),
      title: "Dočekuj donacije",
      durationMinutes: 60,
      xpGain: 180,
      location: "Skladište",
      universityId: 1,
      peopleNeeded: 3,
      peopleApplied: 2,
      description: "Pomozi u prijemu i sortiranju donacija.",
      color: "#800080"),
  Task(
      id: generateTaskId(),
      title: "Sortiraj opremu",
      durationMinutes: 35,
      xpGain: 60,
      location: "Magacin",
      universityId: 1,
      peopleNeeded: 2,
      peopleApplied: 1,
      description: "Razvrstaj i složi opremu u magacinu.",
      color: "#FFA500")
];
