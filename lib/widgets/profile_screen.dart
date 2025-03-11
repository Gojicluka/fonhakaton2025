import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Nicer off-white background
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Column(
        children: [
          const ProfileHeader(),
          const SizedBox(height: 20),
          const ProfileStats(),
          const SizedBox(height: 20),
          const ProfileAchievements(),
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
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/image.png'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Player Name", style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)), // Nicer font
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Level: 3", style: GoogleFonts.lato(fontSize: 18, color: Colors.blue)), // Nicer font
                  Text("XP: 1000", style: GoogleFonts.lato(fontSize: 18, color: Colors.blue)), // Nicer font
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatRow("XP", "1200/1500"),
            _buildStatRow("Strength", "85"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)), // Nicer font
        Text(value, style: GoogleFonts.lato(fontSize: 18, color: Colors.blue)), // Nicer font
      ],
    );
  }
}

class ProfileAchievements extends StatelessWidget {
  const ProfileAchievements({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAchievementCard("First Achievement"),
            _buildAchievementCard("Second Achievement"),
            _buildAchievementCard("Third Achievement"),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(String achievement) {
    return Card(
      color: Colors.blueGrey,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.amber),
        title: Text(
          achievement,
          style: GoogleFonts.lato(fontSize: 16, color: Colors.yellow), // Yellow text, nicer font
        ),
      ),
    );
  }
}