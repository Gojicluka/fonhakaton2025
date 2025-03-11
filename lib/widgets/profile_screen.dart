import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../achievement.dart';
import 'Task.dart';

// ... (Task class and task list from task.dart)

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        title: const SizedBox.shrink(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea( // Wrap with SafeArea
        child: Column(
          children: [
            const ProfileHeader(),
            // Removed SizedBox(height: 10) here
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Achievements:",
                        style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Expanded(child: ProfileAchievements()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Tasks:",
                        style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Expanded(child: ProfileTasks()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('../../assets/nanana.png'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Player Name",
                  style: GoogleFonts.lato( // Use a more standard font
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 2, 1, 14),
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Level: 3",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 16, 1, 16),
                        fontWeight: FontWeight.w600, // Slightly bolder
                      ),
                    ),
                    Text(
                      "XP: 1200/1500",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: const Color(0xFFDDA0DD),
                        fontWeight: FontWeight.w600, // Slightly bolder
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAchievements extends StatelessWidget {
  const ProfileAchievements({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: allAchievements.map((achievement) { // Koristimo map da generišemo widget-e za svaki achievement
          return _buildAchievementCard(
            context,
            achievement.name,
            achievement.description,
            achievement.icon,
            achievement.color,
            achievement.dateAchieved ?? DateTime.now(), // Koristimo trenutni datum ako nije postavljen dateAchieved
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAchievementCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      Color color,
      DateTime date) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                content: Text(description),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Stack(
            children: [
              ListTile(
                leading: Icon(icon, color: Colors.white, size: 36),
                title: Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Text(
                  DateFormat('yyyy-MM-dd').format(date),
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTasks extends StatelessWidget {
  const ProfileTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: tasks.map((task) {
          return _buildTaskCard(
            context,
            task,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return Card(
      color: Colors.accents[tasks.indexOf(task) % Colors.accents.length], // Different color for each task
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: const Icon(Icons.check, color: Colors.white), // Checked icon
        title: Text(task.title, style: GoogleFonts.lato(color: Colors.white)),
        // Add other task details here
      ),
    );
  }
}

List<Achievement> allAchievements = [
  Achievement(
    name: "Zlatni Moderator",
    description: "Dostignuće za 5 uspešnih moderiranja. Hvala vam na posvećenosti!",
    icon: Icons.military_tech,
    color: const Color.fromARGB(255, 110, 8, 86),
  ),
  Achievement(
    name: "Srebrni Moderator",
    description: "Dostignuće za 3 uspešna moderiranja. Nastavite sa dobrim radom!",
    icon: Icons.military_tech_outlined,
    color: const Color.fromARGB(255, 48, 164, 104),
  ),
  Achievement(
    name: "Moderator",
    description: "Dostignuće za jedno uspešno moderiranje. Hvala vam što ste deo tima!",
    icon: Icons.people,
    color: const Color.fromARGB(255, 2, 40, 71),
  ),
  Achievement(
    name: "Zapisničar",
    description: "Dostignuće za uspešno vođenje zapisnika. Vaš doprinos je dragocen!",
    icon: Icons.computer,
    color: Colors.green,
  ),
  Achievement(
    name: "Zlatni Čuvar Fakulteta",
    description: "Dostignuće za 5 uspešnih čuvanja ulaza fakulteta. Hvala vam na posvećenosti i brizi!",
    icon: Icons.security,
    color: const Color.fromARGB(255, 196, 101, 166),
  ),
  Achievement(
    name: "Srebrni Čuvar Fakulteta",
    description: "Dostignuće za 3 uspešna čuvanja ulaza fakulteta. Vaš rad je od velike pomoći!",
    icon: Icons.security_outlined,
    color: const Color.fromARGB(255, 85, 24, 24),
  ),
  Achievement(
    name: "Čuvar Fakulteta",
    description: "Dostignuće za čuvanje fakulteta. Hvala Vam na pomoći!",
    icon: Icons.security,
    color: Colors.blue,
  ),
  Achievement(
    name: "Redar",
    description: "Dostignuće za učešće u redarskoj službi na blokadama. Hvala vam na angažmanu!",
    icon: Icons.accessibility_new,
    color: const Color.fromARGB(255, 175, 110, 14),
  ),
];