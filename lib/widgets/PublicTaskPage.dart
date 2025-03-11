import 'package:flutter/material.dart';

class PublicTaskPage extends StatelessWidget {
  PublicTaskPage({super.key});

  final List<Group> groups = [
    Group("Logistika", Icons.shield, Colors.brown,
        "A group responsible for managing supplies, routes, and resources."),
    Group("Dnevni red", Icons.schedule, Colors.blueGrey,
        "A group that organizes schedules, meetings, and plans."),
    Group("Mediji", Icons.auto_awesome, Colors.deepPurple,
        "A group handling magical broadcasts, announcements, and media."),
    Group("Red", Icons.local_fire_department, Colors.red, "A fiery challenge."),
    Group("Blue", Icons.water, Colors.blue, "A water-based mission."),
    Group(
        "Pink", Icons.local_florist, Colors.pink, "A soft and delicate task."),
  ];

  final List<PublicTask> tasks = [
    PublicTask("Deliver Supplies", 50, "2h", "Logistika"),
    PublicTask("Schedule a Meeting", 30, "1h", "Dnevni red"),
    PublicTask("Announce Event", 40, "1.5h", "Mediji"),
    PublicTask("Fire Ritual", 60, "3h", "Red"),
    PublicTask("Underwater Exploration", 70, "2.5h", "Blue"),
    PublicTask("Flower Arrangement", 20, "45m", "Pink"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Public Tasks")),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final group = groups.firstWhere((g) => g.name == task.groupName);
          return PublicTaskWidget(
            task: task,
            group: group,
          );
        },
      ),
    );
  }
}

class Group {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  Group(this.name, this.icon, this.color, this.description);
}

class PublicTask {
  final String title;
  final int xp;
  final String duration;
  final String groupName;

  PublicTask(this.title, this.xp, this.duration, this.groupName);
}

class PublicTaskWidget extends StatelessWidget {
  final PublicTask task;
  final Group group;

  const PublicTaskWidget({super.key, required this.task, required this.group});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(task.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Group: ${group.name}"),
                Text("XP: ${task.xp}"),
                Text("Duration: ${task.duration}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Accept task logic
                  Navigator.pop(context);
                },
                child: const Text("Accept Task"),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: group.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(group.icon, color: Colors.white, size: 30),
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
                      Text("XP: ${task.xp}",
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(task.duration,
                          style: const TextStyle(color: Colors.white)),
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
