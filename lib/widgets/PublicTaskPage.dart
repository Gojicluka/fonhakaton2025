import 'package:flutter/material.dart';
import 'package:fonhakaton2025/widgets/Group.dart';

class PublicTaskPage extends StatelessWidget {
  PublicTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Public Tasks")),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final group = groups.firstWhere((g) => g.name == task.groupName);
          return TaskWidget(task: task, group: group);
        },
      ),
    );
  }
}

// Generates a static task ID (will be dynamic later)
int generateTaskId() {
  return 1001; // Placeholder, replace with backend logic later
}

class Task {
  final int id;
  final String title;
  final int xp;
  final int durationMinutes;
  final String groupName;
  final String location;
  final String faculty; // Added faculty
  int appliedPeople; // Mutable
  final int neededPeople;
  bool isPublic;
  final String description;
  final String createdBy; // Nickname of the creator

  Task(
      this.title,
      this.xp,
      this.durationMinutes,
      this.groupName,
      this.location,
      this.faculty, // Added in constructor
      this.appliedPeople,
      this.neededPeople,
      this.isPublic,
      this.description,
      this.createdBy)
      : id = generateTaskId();
}

// Updated task list with "ETF" as the faculty
final List<Task> tasks = [
  Task("Baci smeće", 20, 15, "Logistika", "Kontejner ispred zgrade", "ETF", 1,
      0, true, "Iznesi smeće do kontejnera ispred zgrade.", "Milica"),
  Task("Operi sudove", 30, 30, "Dnevni red", "Kuhinja", "ETF", 1, 1, true,
      "Očisti i operi sudove nakon doručka.", "Luka"),
  Task("Čuvaj vrata", 50, 120, "Red", "Glavni ulaz", "ETF", 2, 1, true,
      "Obezbeđuj glavni ulaz tokom događaja.", "Irena"),
  Task("Odnesi dušeke u 115", 40, 90, "Logistika", "Soba 115", "ETF", 2, 0,
      false, "Prenesi rezervne dušeke u sobu 115.", "Vladana"),
  Task("Dočekuj donacije", 60, 180, "Mediji", "Skladište", "ETF", 3, 2, true,
      "Pomozi u prijemu i sortiranju donacija.", "Milica"),
  Task("Sortiraj opremu", 35, 60, "Logistika", "Magacin", "ETF", 2, 1, true,
      "Razvrstaj i složi opremu u magacinu.", "Luka"),
];

class TaskWidget extends StatelessWidget {
  final Task task;
  final Group group;

  const TaskWidget({super.key, required this.task, required this.group});

  String formatDuration(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}";
  }

  void showTaskDialog(BuildContext context, Task task, Group group) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side:
              const BorderSide(color: Colors.amber, width: 3), // Golden border
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: group.color, // Background color = Group color
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Centered Title
              Text(
                task.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Visible text color
                ),
              ),
              const SizedBox(height: 12),

              // Task Description
              Text(
                task.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),

              const SizedBox(height: 20),
// Location and XP Row in the Same Line
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Location Icon + Text
                  const Icon(Icons.location_on, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    task.location,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 20), // Spacing between location and XP

                  // XP
                  Text(
                    "XP: ${task.xp}",
                    style: const TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text("Zatvori",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Accept task logic
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Prihvati zadatak",
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showTaskDialog(context, task, group),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: group.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row - Task Title
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24, // Bigger font
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Second Row - XP, Duration, Applied/Needed
            Row(
              children: [
                const Icon(Icons.star, color: Colors.white, size: 22),
                const SizedBox(width: 6),
                Text("XP: ${task.xp}",
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, color: Colors.white, size: 22),
                const SizedBox(width: 6),
                Text(formatDuration(task.durationMinutes),
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
                const SizedBox(width: 16),
                const Icon(Icons.people, color: Colors.white, size: 22),
                const SizedBox(width: 6),
                Text("${task.appliedPeople}/${task.neededPeople}",
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 8),

            // Third Row - Location
            Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.white, size: 22),
                const SizedBox(width: 6),
                Text(
                  task.location,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
