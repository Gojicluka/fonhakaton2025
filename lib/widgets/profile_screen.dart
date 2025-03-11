import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../achievement.dart';

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
      body: Column(
        children: [
          const ProfileHeader(),
          const SizedBox(height: 20),
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
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('../../assets/image.png'),
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
                        color: const Color(0xFFDDA0DD),
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
        children: [
          _buildAchievementCard(
            context,
            "First Steps",
            "Completed the tutorial.",
            Icons.directions_walk,
            const Color(0xFF90EE90),
            DateTime(2025, 3, 10),
          ),
          _buildAchievementCard(
            context,
            "Puzzle Master",
            "Solved 10 puzzles.",
            Icons.lightbulb_outline,
            const Color(0xFFADD8E6),
            DateTime(2025, 3, 11),
          ),
          _buildAchievementCard(
            context,
            "Social Butterfly",
            "Made 5 new friends.",
            Icons.people,
            const Color(0xFFF08080),
            DateTime(2025, 3, 12),
          ),
          _buildAchievementCard(
            context,
            "Treasure Hunter",
            "Found a hidden item.",
            Icons.diamond,
            const Color(0xFFBA55D3), // Changed to a more distinct pastel color
            DateTime(2025, 3, 13),
          ),
        ],
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

List<Achievement> allAchievements = [
  Achievement(
    name: "Zlatni Moderator",
    description: "Dostignuće za 5 uspešnih moderiranja. Hvala vam na posvećenosti!",
    icon: Icons.military_tech, // Ili neki drugi odgovarajući icon
    color: Colors.amber, // Zlatna boja
  ),
  Achievement(
    name: "Srebrni Moderator",
    description: "Dostignuće za 3 uspešna moderiranja. Nastavite sa dobrim radom!",
    icon: Icons.military_tech_outlined,
    color: Colors.grey, // Srebrna boja
  ),
  Achievement(
    name: "Moderator",
    description: "Dostignuće za jedno uspešno moderiranje. Hvala vam što ste deo tima!",
    icon: Icons.people,
    color: Colors.blue,
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
    color: Colors.amber,
  ),
  Achievement(
    name: "Srebrni Čuvar Fakulteta",
    description: "Dostignuće za 3 uspešna čuvanja ulaza fakulteta. Vaš rad je od velike pomoći!",
    icon: Icons.security_outlined,
    color: Colors.grey,
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
    color: Colors.orange,
  ),
  // Dodajte ostale achievement-e ovde
];