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
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
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
              Text("Player Name", style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(width: 16), // Add spacing between header and stats
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align stats to the left
          children: [
            Text("Level: 3", style: GoogleFonts.lato(fontSize: 18, color: Colors.blue)),
            Text("XP: 1200/1500", style: GoogleFonts.lato(fontSize: 18, color: Colors.blue)),
          ],
        ),
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