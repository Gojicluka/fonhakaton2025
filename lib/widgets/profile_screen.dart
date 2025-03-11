import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Profile Page'),
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
          const Expanded(child: ProfileAchievements()), // Use Expanded to take available space
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('../../assets/image.png'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Player Name", style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Level: 3", style: GoogleFonts.lato(fontSize: 18, color: const Color(0xFFFFD700))),
                  Text("XP: 1200/1500", style: GoogleFonts.lato(fontSize: 18, color: const Color(0xFFFFD700))),
                ],
              ),
            ],
          ),
        ),
      ],
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
          ),
          _buildAchievementCard(
            context,
            "Puzzle Master",
            "Solved 10 puzzles.",
            Icons.lightbulb_outline,
          ),
          _buildAchievementCard(
            context,
            "Social Butterfly",
            "Made 5 new friends.",
            Icons.people,
          ),
          _buildAchievementCard(
            context,
            "Treasure Hunter",
            "Found a hidden item.",
            Icons.diamond,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      BuildContext context, String title, String description, IconData icon) {
    return Card(
      color: Colors.blueGrey,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(
          title,
          style: GoogleFonts.lato(fontSize: 18, color: Colors.yellow), // Increased font size
        ),
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
      ),
    );
  }
}