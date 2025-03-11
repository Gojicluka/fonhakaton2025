import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Column(
        children: [
          const ProfileHeader(), // Modified ProfileHeader
          const SizedBox(height: 20),
          const ProfileStats(),
          const SizedBox(height: 20),
          const ProfileAchievements(),
        ],
      ),
    );
  }
}

// 🔹 Profile Header (Image + Name + Level + HP)
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
        Expanded( // Added Expanded to allow the Column to take available space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Player Name", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8), // Added some spacing
              Row( // Added a Row to align Level and HP horizontally
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between
                children: const [
                  Text("Level: 3", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text("HP: 100", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 🔹 Profile Stats (HP, XP, Strength)
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
            _buildStatRow("HP", "100"),
            _buildStatRow("Level", "3"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 18, color: Colors.blue)),
      ],
    );
  }
}

// 🔹 Profile Achievements (List of Achievements)
class ProfileAchievements extends StatelessWidget {
  const ProfileAchievements({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: const [
            Card(
              color: Colors.blueGrey, // Example styling
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber), 
                title: Text("First Achievement"),
              ),
            ),
            Card(
              color: Colors.blueGrey, // Example styling
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber), 
                title: Text("Second Achievement"),
              ),
            ),
            // Wrapped last tile
            Card(
              color: Colors.blueGrey, // Example styling
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber), 
                title: Text("Third Achievement"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}