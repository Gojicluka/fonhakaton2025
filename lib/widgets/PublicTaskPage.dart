import 'package:flutter/material.dart';
import 'package:fonhakaton2025/widgets/Group.dart';
import 'package:fonhakaton2025/widgets/Task.dart';
import 'package:fonhakaton2025/data/models/task.dart';
import 'package:fonhakaton2025/data/models/student_group.dart';

void _acceptTask(BuildContext context, Task task) {
  // Adds the selected task to a list of active tasks
  //activeTasks.add(task);

  // Increases the amount of people who have accepted the quest
  // and the player can't accept it again. Perhaps show that the quest has been accepted somewhere.
  //task.appliedPeople += 1;

  // Pop the context to close the dialog
  Navigator.pop(context);
}

class PublicTaskPage extends StatelessWidget {
  PublicTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskWidget(task: task);
        },
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({super.key, required this.task});

  String formatDuration(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}";
  }

  void showTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.amber, width: 3),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(int.parse(task.color
                .replaceAll('#', '0xff'))), // Background color = Group color
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                task.description ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              if (task.location.length > 15) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.location,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "XP: ${task.xpGain}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      task.location,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "XP: ${task.xpGain}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
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
                    onPressed: () => _acceptTask(context, task),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
      onTap: () => showTaskDialog(context, task),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(int.parse(
              task.color.replaceAll('#', '0xff'))), // Convert hex to color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.block_rounded, color: Colors.white, size: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text("XP: ${task.xpGain}",
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(formatDuration(task.durationMinutes),
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 12),
                      const Icon(Icons.people, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text("${task.peopleApplied}/${task.peopleNeeded}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
